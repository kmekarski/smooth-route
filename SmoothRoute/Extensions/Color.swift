//
//  Color.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 29/10/2023.
//

import Foundation
import SwiftUI

extension Color {
    static let theme = ColorTheme()
    static let launch = LaunchTheme()
    
    static func fromRating(_ rating: Double) -> Color {
        switch rating {
        case 0..<2:
            return Color("ResultRed")
        case 2..<4:
            return Color("ResultOrange")
        case 4..<6:
            return Color("ResultYellow")
        case 6..<8:
            return Color("ResultLightGreen")
        case 8...10:
            return Color("ResultDarkGreen")
        default:
            return theme.primaryText
        }
    }
}
struct ColorTheme {
    let accent = Color("AccentColor")
    let red = Color("ResultRed")
    let border = Color("BorderColor")
    let secondaryBackground = Color("SecondaryBackgroundColor")
    let primaryText = Color("PrimaryTextColor")
    let secondaryText =  Color.secondary
    let buttonLabelText = Color("ButtonLabelTextColor")
    let routeHighlight = Color("RouteHightlightColor")
}

struct LaunchTheme {
    let background = Color("LaunchBackgroundColor")
}
