//
//  AutoReportViewModel.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 08/11/2023.
//

import Foundation
import CoreMotion
import MapKit
import SwiftUI
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class SensorsViewModel: ObservableObject {
    @AppStorage("blockAutoReports") private var blockAutoReports = false
    var locationManager: LocationManager
    var accelerometerManager: AccelerometerManager
    var firebaseManager: FirebaseManager
    var reportsManager: ReportsManager
    
    private var tokens: Set<AnyCancellable> = []
    
    private let manualReportCooldownTime: Double = 5
    @Published var manualReportCooldown: Bool = false
    
    @Published var currentLocation = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    @Published var speed: Double = 0
    
    @Published var reportsHistory: [ReportInHistory] = []
    
    @Published var result = 0.0
    
    // Current sensors history
    var verticalAccelerationHistory: [Double] = []
    var speedHistory: [Double] = []
    var locationHistory: [CLLocationCoordinate2D] = []
    
    // Timers
    private var sensorsTimer: Timer?
    private var reportsTimer: Timer?
    
    // Used in View to determine how many times instability threshold was exceeded in last report
    @Published var thresholdExceededCount: Int = 0
    
    var instabilityThreshold: Double = 0.2
    var accWeight: Double = 1.0
    var speedSensitivity: Double = 0.1
    var instabilityImpact: Double = 7.0
    
    init(locationManager: LocationManager,
         accelerometerManager: AccelerometerManager,
         firebaseManager: FirebaseManager,
         reportsManager: ReportsManager) {
        self.locationManager = locationManager
        self.accelerometerManager = accelerometerManager
        self.firebaseManager = firebaseManager
        self.reportsManager = reportsManager
    }
    
    func startDriving() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.observeDeviceLocation()
            self.startSensors()
            self.startSendingReports()
        }
    }
    
    func endDriving() {
        stopObservingLocationAndSpeed()
        stopSensors()
        stopSendingReports()
    }
    
    private func observeDeviceLocation() {
        observeSpeedUpdates()
        observeCoordinateUpdates()
        observeDeniedLocationAccess()
    }
    
    private func observeCoordinateUpdates() {
        locationManager.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { currentLocation in
                self.currentLocation = currentLocation
                self.locationHistory.append(self.currentLocation)
            }
            .store(in: &tokens)
    }
    
    private func observeSpeedUpdates() {
        locationManager.speedPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { speed in
                let speedInKilometersPerHour = speed * 3.6
                self.speed = speedInKilometersPerHour
            }
            .store(in: &tokens)
    }
    
    private func observeDeniedLocationAccess() {
        locationManager.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
    
    private func stopObservingLocationAndSpeed() {
        tokens = []
    }
    
    private func startSensors() {
        verticalAccelerationHistory = []
        accelerometerManager.initializeAccelerometer()
        sensorsTimer = Timer(fire: Date(), interval: 0.1,
                             repeats: true, block: { (timer) in
            let accData = self.accelerometerManager.getAccelerometerData()
            let verticalAcc = self.accelerometerManager.getVerticalAcceleration(accData: accData)
            self.verticalAccelerationHistory.append(verticalAcc)
            self.speedHistory.append(self.speed)
        })
        RunLoop.current.add(self.sensorsTimer!, forMode: .default)
    }
    
    private func stopSensors() {
        sensorsTimer?.invalidate()
    }
    
    private func startSendingReports() {
        reportsTimer = Timer(fire: Date(), interval: 5.0, repeats: true, block: { _ in
            if self.locationHistory.count > 0 && !self.manualReportCooldown {
                self.makeAutoReport()
            }
        })
        RunLoop.current.add(self.reportsTimer!, forMode: .default)
    }
    
    private func stopSendingReports() {
        reportsTimer?.invalidate()
    }
    
    private func excludeAdjacentLocations(locations: [CLLocationCoordinate2D], minDistance: CLLocationDistance) -> [CLLocationCoordinate2D]{
        var filteredLocations: [CLLocationCoordinate2D] = []
        var previousLocation: CLLocation?
        for location in locations {
            let currentLocation = CLLocation(latitude: location.latitude, longitude: location.longitude)
            if let previousLocation = previousLocation {
                if currentLocation.distance(from: previousLocation) >= minDistance {
                    // include current location, its far enough from previous one
                    filteredLocations.append(location)
                }
            } else {
                // always include first location
                filteredLocations.append(location)
            }
            // set current location as previous
            previousLocation = currentLocation
        }
        return filteredLocations
    }
    
    func makeManualReport(rating: Double) {
        // Add report to recent reports history
        let reportInHistory = ReportInHistory(rating: rating, timestamp: Date(), type: .manual)
        reportsHistory.insert(reportInHistory, at: 0)
        
        // Filter out locations that are too close to each other
        locationHistory = excludeAdjacentLocations(locations: locationHistory, minDistance: 20)
        if locationHistory.count > 0 {
            // Send report to Firebase
            let report = Report(rating: rating, coordinates: locationHistory, type: .manual)
            try? firebaseManager.sendReport(report: report)
            locationHistory = []
        }

        
        // Reset history
        verticalAccelerationHistory = []
        speedHistory = []
        
        manualReportCooldown = true
        DispatchQueue.main.asyncAfter(deadline: .now() + manualReportCooldownTime) {
            self.manualReportCooldown = false
        }
    }
    
    private func makeAutoReport() {
        // Get result for report
        let resultData = reportsManager.getResultData(
            verticalAccelerationHistory: verticalAccelerationHistory,
            speedHistory: speedHistory,
            speedSensitivity: speedSensitivity,
            instabilityThreshold: instabilityThreshold,
            instabilityImpact: instabilityImpact)
        
        result = resultData.result
        thresholdExceededCount = resultData.thresholdExceededCount
       
        // Filter out locations that are too close to each other
        locationHistory = excludeAdjacentLocations(locations: locationHistory, minDistance: 20)
        if !blockAutoReports && locationHistory.count > 0 {
            let reportInHistory = ReportInHistory(rating: result, timestamp: Date(), type: .automatic)
            reportsHistory.insert(reportInHistory, at: 0)
            // Send report to Firebase
            let report = Report(rating: result, coordinates: locationHistory, type: .automatic)
            try? firebaseManager.sendReport(report: report)
            locationHistory = []
        }

        // Reset history
        verticalAccelerationHistory = []
        speedHistory = []
    }
}
