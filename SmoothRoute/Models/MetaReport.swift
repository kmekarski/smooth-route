//
//  MetaReport.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 12/12/2023.
//

import Foundation

import Foundation
import CoreLocation
import Firebase

struct MetaReport: Identifiable, Codable {
    let id: String
    let rating: Double
    let coordinate: GeoPoint
    
    enum CodingKeys: String, CodingKey {
        case id
        case rating
        case coordinate
    }
    
    init(rating: Double, coordinate: CLLocationCoordinate2D) {
        self.id = UUID().uuidString
        self.rating = rating
        self.coordinate = GeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.rating = try container.decode(Double.self, forKey: .rating)
        self.coordinate = try container.decode(GeoPoint.self, forKey: .coordinate)
    }
}

