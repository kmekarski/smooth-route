//
//  DriveScreenView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI

struct DriveScreenView: View {
    @EnvironmentObject var mapStateManager: MapStateManager
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @EnvironmentObject var sensorsVM: SensorsViewModel
    @Binding var showExitConfirmation: Bool
    @State var historyExpanded: Bool = false
    @State var showManualReport: Bool = false
    @State var showCalibrate: Bool = false
    @State var showSensorsData: Bool = false
    var buttonsVisible: Bool {
        return !historyExpanded && !showManualReport && !showCalibrate
    }
    var body: some View {
        ZStack {
            VStack(spacing: 10) {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 10, height: UIScreen.main.bounds.height/2.5)
                Button {
                    withAnimation(.spring()) {
                        showSensorsData.toggle()
                    }
                } label: {
                    VStack(spacing: 4) {
                        IconButton(systemName: "move.3d", foregroundColor: .theme.accent, backgroundColor: .white, iconSize: 0.45)
                            .frame(width: 50, height: 50)

                        Text("Sensors Data")
                            .font(.headline)
                            .foregroundColor(.theme.buttonLabelText)
                    }
                }
                
                Button {
                    withAnimation(.spring()) {
                        showManualReport.toggle()
                    }
                } label: {
                    VStack(spacing: 4) {
                        IconButton(systemName: "exclamationmark.circle.fill", foregroundColor: .theme.accent, backgroundColor: .white, disabled: sensorsVM.manualReportCooldown)
                            .frame(width: 50, height: 50)
                        
                        Text("Report")
                            .font(.headline)
                            .foregroundColor(.theme.buttonLabelText)
                    }
                }
                .disabled(sensorsVM.manualReportCooldown)
                
                
                Button {
                    withAnimation(.spring()) {
                        showCalibrate.toggle()
                    }
                } label: {
                    VStack(spacing: 4) {
                        IconButton(systemName: "scope", foregroundColor: .theme.accent, backgroundColor: .white, iconSize: 0.6)
                            .frame(width: 50, height: 50)
                        Text("Calibration")
                            .font(.headline)
                            .foregroundColor(.theme.buttonLabelText)
                    }
                }
                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding()
            
            VStack {
                Spacer()
                RecentReportsView(expanded: $historyExpanded)
                    .transition(.move(edge: .bottom))
                    .animation(nil, value: showManualReport)
            }
            VStack {
                Spacer()
                SensorsView(expanded: $showSensorsData)
                    .transition(.move(edge: .bottom))
            }
            VStack {
                Spacer()
                ManualReportView(isShowing: $showManualReport)
            }
            VStack {
                Spacer()
                CalibrationView(isShowing: $showCalibrate) {
                    withAnimation(.spring()) {
                        showCalibrate.toggle()
                    }
                }
            }
            VStack {
                Spacer()
                ExitConfirmView(isShowing: $showExitConfirmation) {
                    locationSearchVM.clearSelectedLocations()
                    locationSearchVM.clearQueries()
//                    locationSearchVM.clearPolylines()
                    withAnimation(.spring()) {
                        mapStateManager.go(to: .initial)
                        sensorsVM.endDriving()
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
}


struct DriveScreenView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            MapViewRepresentable(locationManager: dev.locationManager, firebaseManager: dev.firebaseManager)
            VStack {
                Spacer()
                DriveScreenView(showExitConfirmation: .constant(false))
            }
        }
        .ignoresSafeArea()
        .environmentObject(dev.locationSearchVM)
        .environmentObject(dev.mapStateManager)
        .environmentObject(dev.sensorsVM)
        .environmentObject(dev.routeSelectVM)
    }
}
