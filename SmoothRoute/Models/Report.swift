//
//  Report.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 17/11/2023.
//

import Foundation
import CoreLocation
import Firebase

struct Report: Identifiable, Codable {
    let id: String
    let rating: Double
    let timestamp: Date
    let coordinates: [GeoPoint]
    let type: ReportType
    
    enum CodingKeys: String, CodingKey {
        case id
        case rating
        case timestamp
        case coordinates
        case type
    }
    
    init(rating: Double, coordinates: [CLLocationCoordinate2D], type: ReportType) {
        self.id = UUID().uuidString
        self.rating = rating
        self.timestamp = Date()
        self.coordinates = coordinates.map({ coordinate in
            GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        })
        self.type = type
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.timestamp = try container.decode(Date.self, forKey: .timestamp)
        self.coordinates = try container.decode([GeoPoint].self, forKey: .coordinates)
        self.type = try container.decode(ReportType.self, forKey: .type)
    }
}
