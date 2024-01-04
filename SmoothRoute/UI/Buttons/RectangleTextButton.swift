//
//  RectangleTextButton.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 03/11/2023.
//

import SwiftUI

struct RectangleTextButton: View {
    var text: String
    var border: Bool = false
    
    var body: some View {
            Text(text)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 40)
                .padding(.vertical, 8)
                .background(Color.theme.accent)
                .cornerRadius(10)
            .shadow(color: border ? .theme.border : .black.opacity(0.25), radius: border ? 1 : 3, x: 0, y: border ? 0 : 2)
        }
}

struct RectangleTextButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HStack {
                RectangleTextButton(text: "Yes")
                RectangleTextButton(text: "No")
            }
            HStack {
                RectangleTextButton(text: "Yes", border: true)
                RectangleTextButton(text: "No", border: true)
            }
        }
    }
}
