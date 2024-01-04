//
//  TimeInterval.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 30/10/2023.
//

import Foundation

extension TimeInterval {
    func asHourMinutesString() -> String {
        var resultString = ""
        let fullHours = floor(self/3600)
        let fullMinutes = floor((self - fullHours*3600)/60)
        
        switch self {
        case 0..<60:
            return "1 min"
        case 60..<3600:
            return "\(Int(fullMinutes)) min"
        case 3600..<36000:
            return "\(Int(fullHours)) h \(Int(fullMinutes)) min"
        default:
            return "\(Int(fullHours)) h)"
        }
    }
}
