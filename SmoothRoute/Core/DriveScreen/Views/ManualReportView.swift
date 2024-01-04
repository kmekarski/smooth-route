//
//  ManualReportView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 31/10/2023.
//

import SwiftUI

struct ManualReportView: View {
    @EnvironmentObject var sensorsVM: SensorsViewModel
    @Binding var isShowing: Bool
    var body: some View {
        
        ModalWithHeaderView(isShowing: $isShowing, height: 300, title: "Manual report", subtitle: "Choose your subjective rating of current road.") {
            HStack(spacing: 10) {
                ForEach(Array(stride(from: 0, to: 10.1, by: 2.5)), id: \.self) { rating in
                    Button {
                        sensorsVM.makeManualReport(rating: rating)
                        withAnimation(.spring()) {
                            isShowing.toggle()
                        }
                    } label: {
                        RatingCircleView(rating: rating)
                            .foregroundColor(.theme.primaryText)
                    }
                }
            }
        }
    }
}

struct ManualReportView_Previews: PreviewProvider {
    static var previews: some View {
        ManualReportView(isShowing: .constant(true))
            .environmentObject(dev.sensorsVM)
    }
}
