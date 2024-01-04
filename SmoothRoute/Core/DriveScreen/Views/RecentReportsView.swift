//
//  RecentReportsView.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI

struct RecentReportsView: View {
    @EnvironmentObject var sensorsVM: SensorsViewModel
    @Binding var expanded: Bool
    var body: some View {
        OpenableModalView(isShowing: $expanded, height: 285) {
            HStack {
                Text(expanded ? "RECENT ROAD REPORTS" : "RECENT ROAD REPORT:")
                    .font(.subheadline)
                    .foregroundColor(.theme.secondaryText)
                if !expanded && !sensorsVM.reportsHistory.isEmpty {
                    RatingCircleView(rating: sensorsVM.reportsHistory.first!.rating)
                        .frame(width: 50, height: 50)
                        .padding(.leading, 8)
                }
                Spacer()
                Button {
                    withAnimation(.spring()) {
                        expanded.toggle()
                    }
                } label: {
                    CircleButton(systemName: "chevron.up",  border: true, rotated: expanded)
                        .frame(width: 50, height: 50)
                }
            }
        } contentWhenOpen: {
            VStack{
                Divider()
                ScrollView {
                    VStack {
                        ForEach(sensorsVM.reportsHistory.indices, id: \.self) { index in
                            RecentReportCell(report: sensorsVM.reportsHistory[index])
                            if index < 30 {
                                Rectangle()
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 1)
                                    .foregroundColor(Color(.systemGray3))
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

struct RecentReportsView_Previews: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color(.systemGray3).ignoresSafeArea()
            RecentReportsView(expanded: .constant(true))
                .environmentObject(dev.sensorsVM)
        }
    }
}

