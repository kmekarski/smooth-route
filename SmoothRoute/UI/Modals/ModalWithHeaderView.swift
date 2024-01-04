//
//  ModalWithHeaderView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 31/10/2023.
//

import SwiftUI

struct ModalWithHeaderView<Content: View>: View {
    @Binding var isShowing: Bool
    var height: CGFloat
    var title: String
    var subtitle: String
    @ViewBuilder let content: Content
    var body: some View {
        ModalView(isShowing: $isShowing, height: height) {
            VStack {
                VStack(alignment: .leading, spacing: 10) {
                    Text(title)
                        .font(.title2)
                    Text(subtitle)
                        .foregroundColor(.theme.secondaryText)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
                Divider()
                    .padding(.vertical)
                content
            }
        }
    }
}

struct ModalWithHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ModalWithHeaderView(isShowing: .constant(true), height: 300, title: "Modal with header", subtitle: "Some message to the user") {
            Text("Hello!")
        }
    }
}
