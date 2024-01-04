//
//  ExitConfirmView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 03/11/2023.
//

import SwiftUI

struct ExitConfirmView: View {
    @Binding var isShowing: Bool
    var onConfirm: () -> ()
    var body: some View {
        ModalWithHeaderView(isShowing: $isShowing, height: 300, title: "Confirm", subtitle: "Are you sure you want to finish driving?") {
            HStack(spacing: 10) {
                Button {
                    withAnimation(.spring()) {
                        isShowing = false
                    }
                } label: {
                    WideAccentButton("No")
                }
                Button {
                    isShowing = false
                    onConfirm()
                } label: {
                    WideAccentButton("Yes")
                }
            }
        }
    }
}

struct ExitConfirmView_Previews: PreviewProvider {
    static var previews: some View {
        ExitConfirmView(isShowing: .constant(true)) {
            
        }
    }
}
