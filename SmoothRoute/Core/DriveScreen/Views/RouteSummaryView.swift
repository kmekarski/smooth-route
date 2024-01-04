//
//  RouteSummaryView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 03/11/2023.
//

import SwiftUI

struct RouteSummaryView: View {
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @State var expanded: Bool = false
    var body: some View {
        HStack {
            if expanded {
                
                VStack(alignment: .leading, spacing: 16) {
                    Text(locationSearchVM.startingLocationQueryFragment == "" ? "Curent Location" : locationSearchVM.startingLocationQueryFragment)
                        .font(.headline)
                        .foregroundColor(.theme.secondaryText)
                    Text(locationSearchVM.selectedDestinationTitle ?? "Destination")
                        .font(.headline)
                        .foregroundColor(.theme.primaryText)
                }
                Spacer()
                VStack(alignment: .center, spacing: 16) {
                    Text((locationSearchVM.startingTime ?? Date()).asHourString())
                        .font(.headline)
                        .foregroundColor(.theme.secondaryText)
                    Text((locationSearchVM.arrivalTime ?? Date()).asHourString())
                        .font(.headline)
                        .foregroundColor(.theme.primaryText)
                }
            }
            Button {
                withAnimation(.spring()) {
                    expanded.toggle()
                }
                
            } label: {
                CircleButton(systemName: expanded ? "chevron.right" : "info", border: expanded)
                    .frame(width: 50, height: 50)
            }


        }
        .padding(expanded ? 16 : 1)
        .background(Material.regular)
        .cornerRadius(expanded ? 20 : 25)
    }
}

struct RouteSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            RouteSummaryView()
                .environmentObject(dev.locationSearchVM)
        }
    }
}
