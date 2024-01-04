//
//  ManagersProvider.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 19/11/2023.
//

import Foundation

class ManagerProvider {
    static func provideLocationManager() -> LocationManager {
        return LocationManager()
    }
    
    static func provideMapStateManager() -> MapStateManager {
        return MapStateManager()
    }
    
    static func provideAccelerometerManager() -> AccelerometerManager {
        return AccelerometerManager()
    }
    
    static func provideFirebaseManager() -> FirebaseManager {
        return FirebaseManager()
    }
    
    static func provideReportsManager() -> ReportsManager {
        return ReportsManager()
    }
}
