//
//  WideAccentButton.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI

struct WideAccentButton: View {
    var text: String
    
    init(_ text: String) {
        self.text = text
    }
    var body: some View {
        Text(text)
            .font(.system(size: 18, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical)
            .background(Color.theme.accent)
            .cornerRadius(10)
    }
}

struct WideAccentButton_Previews: PreviewProvider {
    static var previews: some View {
        WideAccentButton("START")
    }
}
