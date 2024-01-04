//
//  RoutePinView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 13/12/2023.
//

import SwiftUI

struct RoutePinView: View {
    var index: Int
    var rating: Double
    var coverage: Double
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    
    var body: some View {
        RatingCircleView(rating: rating, isNA: coverage < 0.01)
            .frame(width: 40, height: 40)
            .shadow(color: .black.opacity(0.15), radius: 3)
    }
}

struct RoutePinView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack{
            MapViewRepresentable(locationManager: dev.locationManager, firebaseManager: dev.firebaseManager)
            HStack {
                RoutePinView(index: 0, rating: 3.6, coverage: 0.2)
                RoutePinView(index: 1, rating: 3.6, coverage: 0)
            }
        }
        .ignoresSafeArea()
        .environmentObject(dev.locationSearchVM)
        .environmentObject(dev.mapStateManager)
        .environmentObject(dev.sensorsVM)
    }
}
