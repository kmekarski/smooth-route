//
//  PreviewProvider.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 19/11/2023.
//

import Foundation
import SwiftUI
import MapKit

extension PreviewProvider {
    static var dev: DeveloperPreview {
        DeveloperPreview.instance
    }
}

class DeveloperPreview {
    static let instance = DeveloperPreview()

    let routes: [Route] = [
        Route(rating: 2.1, coverage: 0.8),
        Route(rating: 4.3, coverage: 0.49),
        Route(rating: 7.9, coverage: 0),
    ]
    let locationManager: LocationManager
    let locationSearchVM: LocationSearchViewModel
    let mapStateManager: MapStateManager
    let sensorsVM: SensorsViewModel
    let routeSelectVM: RouteSelectViewModel
    let firebaseManager: FirebaseManager
    let accelerometerManager: AccelerometerManager
    let reportsManager: ReportsManager
    
    private init() {
        self.locationManager = ManagerProvider.provideLocationManager()
        self.firebaseManager = ManagerProvider.provideFirebaseManager()
        self.accelerometerManager = ManagerProvider.provideAccelerometerManager()
        self.reportsManager = ManagerProvider.provideReportsManager()
        self.locationSearchVM = LocationSearchViewModel()
        self.routeSelectVM = RouteSelectViewModel()
        self.mapStateManager = MapStateManager()
        self.sensorsVM = SensorsViewModel(
            locationManager: locationManager,
            accelerometerManager: accelerometerManager,
            firebaseManager: firebaseManager,
            reportsManager: reportsManager
        )
    }
}
