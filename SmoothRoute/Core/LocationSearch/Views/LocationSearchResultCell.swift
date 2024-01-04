//
//  LocationSearchResultCell.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 29/10/2023.
//

import SwiftUI

struct LocationSearchResultCell: View {
    let title: String
    let subtitle: String
    var body: some View {
        HStack {
            Image(systemName: "mappin.circle")
                .resizable()
                .foregroundColor(.theme.accent)
                .frame(width: 40, height: 40)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .foregroundColor(.theme.primaryText)
                Text(subtitle)
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

struct LocationSearchResultCell_Previews: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading) {
            ForEach(1...5, id: \.self) { _ in
                LocationSearchResultCell(title: "Starbucks Coffee", subtitle: "123 Main St, Cupertino CA")
                Divider()
            }
        }
        .padding(.horizontal)
    }
}
