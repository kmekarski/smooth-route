//
//  StartPinView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 18/12/2023.
//

import SwiftUI

struct StartPinView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.theme.secondaryBackground.opacity(0.85))
                .overlay(
                    Circle()
                        .stroke(Color.theme.accent, lineWidth: 3)
                )
            Image(systemName: "car.fill")
                .font(.system(size: 16))
                .foregroundColor(.theme.accent)
        }
        .shadow(color: .black.opacity(0.15), radius: 3)
    }
}

struct StartPinView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
            HStack {
                StartPinView()
                DestinationPinView()
                RoutePinView(index: 0, rating: 4.5, coverage: 1)
            }
        }
    }
}
