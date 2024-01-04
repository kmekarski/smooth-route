//
//  LocationManager.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 28/10/2023.
//

import CoreLocation
import Combine
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    
    var coordinatesPublisher = PassthroughSubject<CLLocationCoordinate2D, Error>()
    var speedPublisher = PassthroughSubject<Double, Error>()
    
    var deniedLocationAccessPublisher = PassthroughSubject<Void, Never>()
        
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard !locations.isEmpty else { return }
//        locationManager.stopUpdatingLocation()
        coordinatesPublisher.send(locations.last!.coordinate)
        speedPublisher.send(locations.last!.speed)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        coordinatesPublisher.send(completion: .failure(error))
    }
}
