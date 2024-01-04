//
//  LocationSearchHeaderView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 29/10/2023.
//

import SwiftUI

struct LocationSearchHeaderView: View {

    enum FocusInput {
        case startingLocation
        case destination
    }
    @EnvironmentObject var vm: LocationSearchViewModel
    @FocusState private var focusInput: FocusInput?
    @Binding var showLocationsList: Bool
    
    var body: some View {
        HStack(spacing: 16) {
            VStack {
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(focusInput == .startingLocation ? .theme.primaryText : .secondary)
                Rectangle()
                    .frame(width: 1, height: 38)
                Circle()
                    .frame(width: 6, height: 6)
                    .foregroundColor(focusInput == .destination ? .theme.primaryText : .secondary)
            }
            .foregroundColor(.secondary)
            
            VStack(spacing: 10) {
                ClearableTextField("Current Location", text: $vm.startingLocationQueryFragment, border: true, invalid: !vm.isStartingLocationCorrect, clearButtonVisible: focusInput == .startingLocation, onClear: {
                    focusInput = nil
                })
                    .focused($focusInput, equals: .startingLocation)
                    .onTapGesture {
                        vm.showResults = true
                        vm.selectRequestedLocationsType(.startingLocation)
                        focusInput = .startingLocation
                    }
                ClearableTextField("Where to?", text: $vm.destinationQueryFragment, border: true, invalid: !vm.isDestinationCorrect, clearButtonVisible: focusInput == .destination, onClear: {
                    focusInput = nil
                })
                    .focused($focusInput, equals: .destination)
                    .onTapGesture {
                        vm.showResults = true
                        vm.selectRequestedLocationsType(.destination)
                        focusInput = .destination
                    }
            }
        }
        .padding(.leading, 8)
        .onAppear() {
            focusInput = .destination
        }
    }
}

struct LocationSearchHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchHeaderView(showLocationsList: .constant(true))
            .environmentObject(LocationSearchViewModel())
    }
}
