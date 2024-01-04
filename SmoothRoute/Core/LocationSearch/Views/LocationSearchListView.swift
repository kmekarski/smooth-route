//
//  LocationSearchListView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 29/10/2023.
//

import SwiftUI
import MapKit

struct LocationSearchListView: View {
    @EnvironmentObject var vm: LocationSearchViewModel
    @EnvironmentObject var mapStateManager: MapStateManager
    @Binding var isShowing: Bool
    @State var results = [MKLocalSearchCompletion]()
    
    var body: some View {
        VStack {
            if vm.isFetchingLocations {
                Spinner()
            }
            if vm.showResults {
                ScrollView {
                    VStack(alignment: .leading) {
                        if vm.requestedLocationsType == .startingLocation {
                            ForEach(vm.startingLocationResults, id: \.self) { result in
                                LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                                    .onTapGesture {
                                        vm.selectStartingLocation(result)
                                    }
                                Divider()
                            }
                        } else {
                            ForEach(vm.destinationResults, id: \.self) { result in
                                LocationSearchResultCell(title: result.title, subtitle: result.subtitle)
                                    .onTapGesture {
                                        vm.selectDestination(result)
                                    }
                                Divider()
                            }
                        }
                        
                    }
                }
            }
            Spacer()
            if vm.readyForGeneratingRoute {
                Button {
                    mapStateManager.go(to: .selectingRoute)
                } label: {
                    WideAccentButton("Find route")
                    
                }
                
            }
        }
        .padding(.horizontal)
    }
}

struct LocationSearchListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchListView(isShowing: .constant(true))
            .environmentObject(dev.locationSearchVM)
            .environmentObject(dev.mapStateManager)
            .environmentObject(dev.sensorsVM)
    }
}
