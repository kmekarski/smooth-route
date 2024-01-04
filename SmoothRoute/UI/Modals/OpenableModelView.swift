//
//  OpenableModelView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 31/10/2023.
//

import SwiftUI

struct OpenableModalView<ContentWhenHidden: View, ContentWhenOpen: View>: View {
    @Binding var isShowing: Bool
    var height: CGFloat
    @ViewBuilder let contentWhenHidden: ContentWhenHidden
    @ViewBuilder let contentWhenOpen: ContentWhenOpen
    
    var body: some View {
        ZStack {
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
                Spacer()
                mainView
            }
        }
        .ignoresSafeArea()
    }
    
    var mainView: some View {
        VStack {
            contentWhenHidden
            if isShowing {
                contentWhenOpen
                    .frame(maxHeight: height)
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal)
        .frame(maxWidth: .infinity)
        .background(Material.thick)
        .cornerRadius(20, corners: [.topLeft, .topRight])
    }
}

struct OpenableModalView_Previews: PreviewProvider {
    static var previews: some View {
        OpenableModalView(isShowing: .constant(false), height: 280) {
            Text("Open me!")
        } contentWhenOpen: {
            Text("Hello!")
        }
        
    }
}

