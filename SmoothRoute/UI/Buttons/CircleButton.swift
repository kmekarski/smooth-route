//
//  CircleButton.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI

struct CircleButton: View {
    var systemName: String
    var border: Bool = false
    var rotated: Bool = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .foregroundColor(.theme.secondaryBackground)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .shadow(color: border ? .theme.border : .black.opacity(0.15), radius: border ? 1 : 3, x: 0, y: border ? 0 : 2)
                Image(systemName: systemName)
                    .rotationEffect(Angle(degrees: rotated ? 180 : 0))
                    .foregroundColor(.theme.primaryText)
                    .font(.title2)
            }
        }
    }
}

struct CircleButton_Previews: PreviewProvider {
    static var previews: some View {
        HStack {
            CircleButton(systemName: "arrow.left")
                .frame(width: 50, height: 50)
            CircleButton(systemName: "arrow.left", rotated: true)
                .frame(width: 70, height: 70)
        }
    }
}
