//
//  LaunchView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 01/11/2023.
//

import SwiftUI

struct LaunchView: View {
    @Binding var showLaunchView: Bool
    var body: some View {
        ZStack {
            Color.launch.background
            Image("Logo")
                .resizable()
                .frame(width: 300, height: 300)
            
        }
        .ignoresSafeArea()
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                withAnimation(.spring()) {
                    showLaunchView = false
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
