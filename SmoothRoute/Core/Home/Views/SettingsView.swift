//
//  SettingsView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 04/11/2023.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = false
    @AppStorage("blockAutoReports") private var blockAutoReports = false
    @Binding var isShowing: Bool
    var body: some View {
        ZStack {
            Color.black.opacity(isShowing ? 0.3 : 0).ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring()) {
                        isShowing.toggle()
                    }
                }
            if isShowing {
                HStack {
                    ZStack {
                        Color.clear.ignoresSafeArea().background(Material.thick)
                        VStack {
                            header
                            Divider()
                                .padding(.vertical, 4)
                            toggle(title: "Don't make automatic reports", binding: $blockAutoReports)
                            toggle(title: "Dark mode", binding: $isDarkMode)
                            Spacer()
                            apiVersionInfo
//                            Divider()
//                                .padding(.vertical, 4)
//                            developerSection
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                    .frame(width: UIScreen.main.bounds.width * 0.8)
                    Spacer()
                }
                .transition(.move(edge: .leading))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(isShowing: .constant(true))
    }
}

extension SettingsView {
    private func toggle(title: String, binding: Binding<Bool>) -> some View {
        Toggle(isOn: binding) {
            Text(title)
        }
    }
    private var header: some View {
        HStack {
            Text("Settings")
                .font(.title2)
            Spacer()
            Button {
                withAnimation(.spring()) {
                    isShowing.toggle()
                }
            } label: {
                CircleButton(systemName: "xmark", border: true)
                    .frame(width: 50, height: 50)
            }
        }
    }
    
    private var apiVersionInfo: some View {
        HStack {
            Text("API version:")
            Spacer()
            Text("1.0")
        }
    }
    
    private var developerSection: some View {
            VStack(alignment: .leading) {
                Text("DEVELOPER")
                    .font(.subheadline)
                    .foregroundColor(.theme.secondaryText)
                Image("Logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.vertical, 4)
                Text("This app was developed by Klaudiusz Mękarski. It uses SwiftUI and is written 100% in Swift. The project benefits from multi-threading, publishers/subscribers and data persistance.")
            }
    }
}
