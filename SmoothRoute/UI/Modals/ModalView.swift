//
//  ModalView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 31/10/2023.
//

import SwiftUI

struct ModalView<Content: View>: View {
    @Binding var isShowing: Bool
    var height: CGFloat
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottom) {
                if isShowing {
                    Color.black
                        .frame(maxWidth: .infinity, alignment: .bottom)
                        .opacity(0.3)
                        .ignoresSafeArea()
                        .onTapGesture {
                            withAnimation(.spring()) {
                                isShowing = false
                            }
                        }
                }
                VStack {
                    mainView
                }
                .frame(height: isShowing ? height : 0)
                .transition(.move(edge: .bottom))
            }
            .ignoresSafeArea()
        }
    }
    
    var mainView: some View {
        VStack {
            if isShowing {
                content
                Spacer()
            }
        }
        .frame(maxHeight: height)
        .padding(.vertical, isShowing ? 20 : 0)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(Material.thick)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

struct ModalView_Previews: PreviewProvider {
    static var previews: some View {
        ModalView(isShowing: .constant(true), height: 300) {
            Text("Hello!")
        }
    }
}
