//
//  DestinationPinView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 18/12/2023.
//

import SwiftUI

struct DestinationPinView: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 30, height: 30)
                .foregroundColor(Color.theme.secondaryBackground.opacity(0.85))
                .overlay(
                    Circle()
                        .stroke(Color.theme.red, lineWidth: 3)
                )
            Image(systemName: "mappin")
                .font(.system(size: 16))
                .foregroundColor(.theme.red)
        }
        .shadow(color: .black.opacity(0.15), radius: 3)
    }
}

struct DestinationPinView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.green
            HStack {
                StartPinView()
                DestinationPinView()
            }
        }
    }
}
