//
//  SmoothRouteApp.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 28/10/2023.
//

import SwiftUI
import FirebaseCore

@main
struct SmoothRouteApp: App {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State var showLaunchView: Bool = true
    
    var locationManager: LocationManager
    var mapStateManager: MapStateManager
    var accelerometerManager: AccelerometerManager
    var firebaseManager: FirebaseManager
    var reportsManager: ReportsManager
    var locationSearchVM = LocationSearchViewModel()
    var routeSelectVM = RouteSelectViewModel()
    var sensorsVM: SensorsViewModel
    
    init() {
        FirebaseApp.configure()
        self.locationManager = ManagerProvider.provideLocationManager()
        self.mapStateManager = ManagerProvider.provideMapStateManager()
        self.accelerometerManager = ManagerProvider.provideAccelerometerManager()
        self.firebaseManager = ManagerProvider.provideFirebaseManager()
        self.reportsManager = ManagerProvider.provideReportsManager()
        self.sensorsVM = SensorsViewModel(
            locationManager: locationManager,
            accelerometerManager: accelerometerManager,
            firebaseManager: firebaseManager,
            reportsManager: reportsManager
        )
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                HomeView(locationManager: locationManager, firebaseManager: firebaseManager)
                    .environmentObject(locationSearchVM)
                    .environmentObject(mapStateManager)
                    .environmentObject(sensorsVM)
                    .environmentObject(routeSelectVM)
                    .preferredColorScheme(isDarkMode ? .dark : .light)
                ZStack {
                    if showLaunchView {
                        LaunchView(showLaunchView: $showLaunchView)
                            .transition(.move(edge: .leading))
                    }
                }
            }
        }
    }
}
