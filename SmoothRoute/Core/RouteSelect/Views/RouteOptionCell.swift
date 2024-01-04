//
//  RouteOptionCell.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI
import MapKit

struct RouteOptionCell: View {
    var route: Route
    var isSelected: Bool
    var body: some View {
        ZStack {
            Rectangle()
                .cornerRadius(24)
                .foregroundColor(isSelected ? .theme.accent : .theme.secondaryBackground)
                .shadow(color: .theme.border.opacity(isSelected ? 0 : 1), radius: 1, x: 0, y: 0)

            
            VStack(alignment: .center, spacing: 10) {
                RatingCircleView(rating: route.rating, isNA: route.coverage < 0.01)
                    .frame(width: 50, height: 50)
                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                        Text(route.route.expectedTravelTime.asHourMinutesString())
                    }
                    HStack(spacing: 4) {
                        Image(systemName: "fuelpump.fill")
                        Text(route.route.distance.asKilometersString())
                    }
                }
                .font(.caption)
            }
            .padding(.vertical)
            .frame(width: 110, height: 110)
            .background(Color.theme.secondaryBackground)
            .cornerRadius(20)
        }
        .frame(width: 118, height: 118)
    }
    
    struct RouteOptionCell_Previews: PreviewProvider {
        static var previews: some View {
            ZStack {
                Color(.systemGray3).ignoresSafeArea()
                VStack(spacing: 16) {
                    HStack(spacing: 10) {
                        RouteOptionCell(route: dev.routes[0], isSelected: true)
                        RouteOptionCell(route: dev.routes[1], isSelected: false)
                        RouteOptionCell(route: dev.routes[2], isSelected: false)
                        
                    }
                    HStack(spacing: 10) {
                        RouteOptionCell(route: dev.routes[0], isSelected: true)
                        RouteOptionCell(route: dev.routes[1], isSelected: false)
                    }
                }
            }
        }
    }
}
