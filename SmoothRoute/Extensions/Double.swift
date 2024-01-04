//
//  Double.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 13/12/2023.
//

import Foundation

extension Double {
    var toRadians: Double { self * .pi / 180 }
    var toDegrees: Double { self * 180 / .pi }
}
