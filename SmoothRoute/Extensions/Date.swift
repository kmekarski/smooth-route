//
//  Date.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 04/11/2023.
//

import Foundation

extension Date {
    func asHourString() -> String {
        return self.formatted(date: .omitted, time: .shortened)
    }
    
    func timeAgoDisplay() -> String {
        let secondsAgo = Int(Date().timeIntervalSince(self))
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        if secondsAgo == 0 {
            return "just now"
        }
        if secondsAgo < minute {
            return "\(secondsAgo) sec ago"
        } else if secondsAgo < hour {
            return "\(secondsAgo / minute) min ago"
        } else if secondsAgo < day {
            return "\(secondsAgo / hour) hrs ago"
        }
        return "over a day ago"
    }
}
