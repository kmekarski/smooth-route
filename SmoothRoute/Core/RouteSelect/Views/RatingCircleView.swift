//
//  RatingCircleView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI

struct RatingCircleView: View {
    var rating: Double = 0
    var isNA: Bool = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .frame(width: geometry.size.width*0.93, height: geometry.size.width*0.93)
                    .foregroundColor(Color.theme.secondaryBackground.opacity(0.65))
                    .overlay(
                        Circle()
                            .stroke(isNA ? Color.secondary : Color.fromRating(rating), lineWidth: geometry.size.width*0.07)
                    )
                
                Text(isNA ? "N/A" : "\(rating, specifier: "%.1f")")
                    .font(.system(size: geometry.size.width/3))
            }
        }
    }
}

struct RatingCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
            VStack {
                RatingCircleView(isNA: true)
                    .frame(width: 50, height: 50)
                RatingCircleView(rating: 1.0)
                    .frame(width: 50, height: 50)
                RatingCircleView(rating: 2.1)
                    .frame(width: 60, height: 60)
                RatingCircleView(rating: 4.6)
                    .frame(width: 70, height: 70)
                RatingCircleView(rating: 6.9)
                    .frame(width: 80, height: 80)
                RatingCircleView(rating: 8.3)
                    .frame(width: 90, height: 90)
            }
        }
    }
}
