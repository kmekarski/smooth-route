//
//  Spinner.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 03/11/2023.
//

import SwiftUI

struct Spinner: View {
    @State var animate = false
         
        var body: some View {
            VStack {
                Circle()
                    .trim(from: 0, to: 0.8)
                    .stroke(Color.theme.accent, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.init(degrees: self.animate ? 360 : 0))
                    .animation(Animation.linear(duration: 1.2).repeatForever(autoreverses: false), value: animate)
            }
            .frame(width: 60, height: 60)
            .padding()
            .cornerRadius(15)
            .onAppear {
                self.animate.toggle()
            }
        }
}

struct Spinner_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.black
            Spinner()
        }
    }
}
