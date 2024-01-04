//
//  ActionButton.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 29/10/2023.
//

import SwiftUI

struct MapViewActionButton: View {
    @EnvironmentObject var mapStateManager: MapStateManager
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @Binding var showExitDriveConfirm: Bool
    @Binding var showSettings: Bool
    var border: Bool = false
    
    var body: some View {
        Button {
            actionForState()
        } label: {
            CircleButton(systemName: imageNameForState(), border: showSettings)
                .frame(width: 50, height: 50)
        }
    }
    
    func actionForState() {
        switch mapStateManager.current {
        case .initial:
            withAnimation(.spring()) {
                showSettings.toggle()
            }
        case .searchingForLocation:
            withAnimation(.spring()) {
                mapStateManager.goHome()
            }
        case .locationSelected:
            withAnimation(.spring()) {
                mapStateManager.goBack()
            }
        case .selectingRoute:
            locationSearchVM.clearSelectedLocations()
//            locationSearchVM.clearPolylines()
            withAnimation(.spring()) {
                mapStateManager.go(to: .searchingForLocation)
            }
        case .collectingDataWithRoute, .collectingDataWithoutRoute:
            withAnimation(.spring()) {
                showExitDriveConfirm = true
            }
        }
    }
    
    func imageNameForState() -> String {
        switch mapStateManager.current {
        case .initial:
            return "line.3.horizontal"
        case .searchingForLocation, .locationSelected, .selectingRoute:
            return "chevron.left"
        case .collectingDataWithoutRoute, .collectingDataWithRoute:
            return "xmark"
            
        }
    }
    
    struct ActionButton_Previews: PreviewProvider {
        static var previews: some View {
            ZStack {
                Color.gray.ignoresSafeArea()
                MapViewActionButton(showExitDriveConfirm: .constant(false), showSettings: .constant(false))
                    .environmentObject(dev.locationSearchVM)
                    .environmentObject(dev.mapStateManager)
                    .environmentObject(dev.sensorsVM)
            }
        }
    }
}
