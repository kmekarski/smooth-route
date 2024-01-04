//
//  CLLocationDistance.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import Foundation
import CoreLocation

extension CLLocationDistance {
    func asKilometersString() -> String {
        
        switch self {
        case 0..<1000:
            return "\(Int((self/100).rounded()*100)) m"
        case 1000..<10000:
            return "\((self/100).rounded()/10) km"
        default:
            return "\(Int((self/1000).rounded())) km"
        }
    }
}
