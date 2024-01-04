//
//  RouteSelectView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI
import MapKit

struct RouteSelectView: View {
    @EnvironmentObject var mapStateManager: MapStateManager
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @EnvironmentObject var routeSelectVM: RouteSelectViewModel
    var routes: [Route]
    @Binding var showCalibration: Bool
    @State private var expanded: Bool = false
    var body: some View {
        VStack {
            OpenableModalView(isShowing: $expanded, height: 335) {
                HStack(spacing: 24) {
                    VStack {
                        Circle()
                            .frame(width: 6, height: 6)
                        Rectangle()
                            .frame(width: 1, height: 24)
                        Circle()
                            .frame(width: 6, height: 6)
                            .foregroundColor(.theme.primaryText)
                    }
                    .foregroundColor(.secondary)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        Text(locationSearchVM.startingLocationQueryFragment == "" ? "Curent Location" : locationSearchVM.startingLocationQueryFragment)
                            .font(.headline)
                            .foregroundColor(.theme.secondaryText)
                        Text(locationSearchVM.selectedDestinationTitle ?? "Destination")
                            .font(.headline)
                            .foregroundColor(.theme.primaryText)
                    }
                    Spacer()
                    Button {
                        withAnimation(.spring()) {
                            expanded.toggle()
                        }
                    } label: {
                        CircleButton(systemName: "chevron.up", border: true, rotated: expanded)
                            .frame(width: 50, height: 50)
                        
                    }
                }
                .padding(.bottom, 8)
            } contentWhenOpen: {
                VStack {
                    Divider()
                        .padding(.bottom, 8)
                    Text("SUGGESTED ROUTES")
                        .font(.subheadline)
                        .foregroundColor(.theme.secondaryText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    if locationSearchVM.isFetchingRoutes {
                        Spacer()
                        Spinner()
                        Spacer()
                    }
                    ScrollView(.horizontal) {
                        HStack(spacing: 10) {
                            ForEach(routes.indices, id: \.self) { index in
                                RouteOptionCell(route: routes[index], isSelected: (index == routeSelectVM.selectedRouteIndex))
                                    .onTapGesture {
                                        withAnimation(.linear(duration: 0.2)) {
                                            routeSelectVM.selectedRouteIndex = index
                                        }
                                    }
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    if routes.count > routeSelectVM.selectedRouteIndex && routes[routeSelectVM.selectedRouteIndex].coverage < 0.5 {
                        warningMessage
                    }
                    Spacer()
                    if locationSearchVM.isStartingLocationEqualToCurrentLocation && !locationSearchVM.isFetchingRoutes {
                        Button {
                            locationSearchVM.startingTime = Date()
                            locationSearchVM.arrivalTime = Date().addingTimeInterval(locationSearchVM.routes[routeSelectVM.selectedRouteIndex].route.expectedTravelTime)
                            withAnimation(.spring()) {
                                expanded = false
                                showCalibration = true
                            }
                        } label: {
                            WideAccentButton("Start")
                        }
                    }
                }
            }
        }
    }
}

struct RouteSelectView_Previews: PreviewProvider {
    static var previews: some View {
        RouteSelectView(routes: dev.routes, showCalibration: .constant(false))
            .environmentObject(dev.locationSearchVM)
            .environmentObject(dev.mapStateManager)
            .environmentObject(dev.sensorsVM)
            .environmentObject(dev.routeSelectVM)
    }
}

extension RouteSelectView {
    private var warningMessage: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 30))
            Text(routes[routeSelectVM.selectedRouteIndex].coverage < 0.01 ? "Selected route doesn't contain any information about road quality." : "Only \(routes[routeSelectVM.selectedRouteIndex].coverage * 100, specifier: "%.f")% of selected route contain information about road quality.")
                .frame(width: 270, alignment: .leading)
        }
        .padding(.horizontal)
        .foregroundColor(.red)
    }
}
