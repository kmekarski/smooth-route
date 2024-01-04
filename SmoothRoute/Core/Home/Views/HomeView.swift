//
//  HomeView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 28/10/2023.
//

import SwiftUI


struct HomeView: View {
    
    @State private var showLocationSearchView = false
    @State private var showCalibration = false
    @State private var showLocationsList = true
    @State private var showExitDriveConfirm = false
    @State private var showSettings = false
    
    var locationManager: LocationManager
    var firebaseManager: FirebaseManager
    
    @EnvironmentObject var mapStateManager: MapStateManager
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @EnvironmentObject var sensorsVM: SensorsViewModel
    @EnvironmentObject var routeSelectVM: RouteSelectViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            MapViewRepresentable(locationManager: locationManager, firebaseManager: firebaseManager)
                .ignoresSafeArea()
            // Top panel
            ZStack {
                VStack {
                    HStack(alignment: .top) {
                        // Action button
                        MapViewActionButton(showExitDriveConfirm: $showExitDriveConfirm, showSettings: $showSettings, border: mapStateManager.current == .searchingForLocation)
                        Spacer()
                        if mapStateManager.current == .searchingForLocation {
                            LocationSearchHeaderView(showLocationsList: $showLocationsList)
                        }
                        if mapStateManager.current == .initial {
                            ClearableTextField("Where you want to go?", text: .constant(""), clearButtonVisible: false)
                                .onTapGesture {
                                    withAnimation(.spring()) {
                                        mapStateManager.go(to: .searchingForLocation)
                                    }
                                }
                        }
                        if mapStateManager.current == .locationSelected {
                            Spacer()
                        }
                        if mapStateManager.current == .selectingRoute {
                        }
                        if mapStateManager.current == .collectingDataWithRoute {
                            Spacer()
                            RouteSummaryView()
                        }
                        if mapStateManager.current == .collectingDataWithoutRoute {
                            Spacer()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    
                    if mapStateManager.current == .searchingForLocation {
                        LocationSearchListView(isShowing: $showLocationsList)
                            .padding(.bottom)
                    }
                }
                .background(Material.ultraThick.opacity(mapStateManager.current == .searchingForLocation ? 1.0 : 0.0))
            }
            
            if locationSearchVM.isFetchingRoutes {
                VStack {
                    Spacer()
                    Spinner()
                    Spacer()
                }
                .frame(maxHeight: .infinity)
            }
            
            // Bottom panel
            ZStack {
                VStack {
                    Spacer()
                    if mapStateManager.current == .initial && !showCalibration {
                        Button {
                            withAnimation(.spring()) {
                                showCalibration = true
                            }
                        } label: {
                            WideAccentButton("Start collecting road data")
                                .padding()
                                .padding(.bottom)
                                .animation(nil, value: showCalibration)
                        }
                    }
                }
                VStack {
                    Spacer()
                    if mapStateManager.current == .selectingRoute {
                        RouteSelectView(routes: locationSearchVM.routes, showCalibration: $showCalibration)
                    }
                }
                VStack {
                    Spacer()
                    if mapStateManager.current == .collectingDataWithoutRoute {
                        DriveScreenView(showExitConfirmation: $showExitDriveConfirm)
                    }
                }
                VStack {
                    Spacer()
                    if mapStateManager.current == .collectingDataWithRoute {
                        DriveScreenView(showExitConfirmation: $showExitDriveConfirm)
                    }
                }
                VStack {
                    Spacer()
                    CalibrationView(isShowing: $showCalibration) {
                        withAnimation(.spring()) {
                            showCalibration = false
                            switch mapStateManager.current {
                            case .initial:
                                mapStateManager.go(to: .collectingDataWithoutRoute)
                                sensorsVM.startDriving()
                            case .selectingRoute:
                                mapStateManager.go(to: .collectingDataWithRoute)
                                sensorsVM.startDriving()
//                                locationSearchVM.changeUnselectedPolylinesColorToClear()
                            default: break
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()
            SettingsView(isShowing: $showSettings)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView(locationManager: dev.locationManager, firebaseManager: dev.firebaseManager)
            .environmentObject(dev.sensorsVM)
            .environmentObject(dev.locationSearchVM)
            .environmentObject(dev.mapStateManager)
            .environmentObject(dev.sensorsVM)
            .environmentObject(dev.routeSelectVM)
    }
}
