//
//  CalibrationView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 31/10/2023.
//

import SwiftUI

struct CalibrationView: View {
    @Binding var isShowing: Bool
    var onConfirm: () -> () = {}
    var body: some View {
        ModalWithHeaderView(isShowing: $isShowing, height: 300, title: "Calibration", subtitle: "Place your device on a phone holder or dashboard.") {
            Button {
                onConfirm()
            } label: {
                WideAccentButton("OK")
            }
            
        }
    }
}

struct CalibrationView_Previews: PreviewProvider {
    static var previews: some View {
        CalibrationView(isShowing: .constant(true)) {
            
        }
    }
}
