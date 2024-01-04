//
//  Route.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 12/12/2023.
//

import Foundation
import MapKit

struct Route {
    let route: MKRoute
    let rating: Double
    let coverage: Double
    
    init(route: MKRoute, rating: Double, coverage: Double) {
        self.route = route
        self.coverage = coverage
        self.rating = rating
    }
    
    init(rating: Double, coverage: Double) {
        self.route = MKRoute()
        self.coverage = coverage
        self.rating = rating
    }
}
