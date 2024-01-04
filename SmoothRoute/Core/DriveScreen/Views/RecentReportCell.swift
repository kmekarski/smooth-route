//
//  RecentReportCell.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import SwiftUI

struct RecentReportCell: View {
    var report: ReportInHistory
    var body: some View {
        HStack {
            RatingCircleView(rating: report.rating)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(report.type == .automatic ? "Auto report" : "Manual report")
                    .font(.body)
                    .foregroundColor(.theme.primaryText)
                Text(report.timestamp.timeAgoDisplay())
                    .font(.system(size: 15))
                    .foregroundColor(.theme.secondaryText)
            }
            .padding(.leading, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

struct RecentReportCell_Previews: PreviewProvider {
    static var previews: some View {
        RecentReportCell(report: ReportInHistory(rating: 3.9, timestamp: Date(), type: .manual))
    }
}
