//
//  CircleAccentButton.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI

struct IconButton: View {
    var systemName: String
    var foregroundColor: Color
    var backgroundColor: Color
    var iconSize: Double = 0.8
    var border: Bool = false
    var rotated: Bool = false
    var disabled: Bool = false
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Circle()
                    .foregroundColor(backgroundColor)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .shadow(color: border ? .theme.border : .black.opacity(0.25), radius: border ? 1 : 3, x: 0, y: border ? 0 : 2)
                Image(systemName: systemName)
                    .resizable()
                    .frame(width: geometry.size.width * iconSize, height: geometry.size.height * iconSize)
                    .rotationEffect(Angle(degrees: rotated ? 180 : 0))
                    .foregroundColor(foregroundColor)
                    .opacity(disabled ? 0.6 : 1)
                    .font(.title2)
            }
        }
    }
}

struct IconButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            IconButton(systemName: "magnifyingglass", foregroundColor: .theme.accent, backgroundColor: .white, iconSize: 0.4)
                .frame(width: 50, height: 50)
            IconButton(systemName: "exclamationmark.circle.fill", foregroundColor: .theme.accent, backgroundColor: .white)
                .frame(width: 70, height: 70)
            IconButton(systemName: "exclamationmark.circle.fill", foregroundColor: .theme.accent, backgroundColor: .white, disabled: true)
                .frame(width: 70, height: 70)


        }
    }
}
