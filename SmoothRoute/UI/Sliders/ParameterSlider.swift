//
//  ParameterSlider.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 08/11/2023.
//

import SwiftUI

struct ParameterSlider: View {
    var title: String
    var value: Binding<Double>
    var range: ClosedRange<Double>
    var body: some View {
        VStack(spacing: 10) {
            Text(title)
                .font(.title2)
            Text("\(value.wrappedValue, specifier: "%.2f")")
                .font(.headline)
            Slider(value: value, in: range, step: 0.02)

        }
    }
}

struct ParameterSlider_Previews: PreviewProvider {
    static var previews: some View {
        ParameterSlider(title: "Instability threshold", value: .constant(0.5), range: -1...1)
    }
}
