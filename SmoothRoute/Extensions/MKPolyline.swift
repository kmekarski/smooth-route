//
//  MKPolyline.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 13/12/2023.
//

import Foundation
import MapKit

extension MKPolyline {
    var length: CLLocationDistance {
        var length: CLLocationDistance = 0

        for i in 0..<pointCount - 1 {
            let coordinate1 = points()[i].coordinate
            let coordinate2 = points()[i + 1].coordinate
            let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
            let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)
            length += location1.distance(from: location2)
        }

        return length
    }

    func interpolateBearing(distance: CLLocationDistance) -> CLLocationCoordinate2D {
        var distanceRemaining = distance

        for i in 0..<pointCount - 1 {
            let coordinate1 = points()[i].coordinate
            let coordinate2 = points()[i + 1].coordinate
            let location1 = CLLocation(latitude: coordinate1.latitude, longitude: coordinate1.longitude)
            let location2 = CLLocation(latitude: coordinate2.latitude, longitude: coordinate2.longitude)

            let segmentLength = location1.distance(from: location2)

            if distanceRemaining <= segmentLength {
                let fraction = distanceRemaining / segmentLength
                let interpolatedCoordinate = location1.coordinate.interpolateBearing(to: location2.coordinate, fraction: fraction)
                return interpolatedCoordinate
            } else {
                distanceRemaining -= segmentLength
            }
        }

        // Return the last coordinate if the distance is beyond the polyline length
        return points()[pointCount - 1].coordinate
    }
}
