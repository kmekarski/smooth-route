//
//  CLLocationCoordinate2D.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 13/12/2023.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D {
    func interpolateBearing(to: CLLocationCoordinate2D, fraction: Double) -> CLLocationCoordinate2D {
        let lat1 = self.latitude.toRadians
        let lon1 = self.longitude.toRadians
        let lat2 = to.latitude.toRadians
        let lon2 = to.longitude.toRadians

        let delta = fraction
        let x = sin((1 - delta) * lat1) * cos(delta * lat2) * cos(lon1 - lon2) + cos((1 - delta) * lat1) * sin(delta * lat2)
        let y = sin(lon1 - lon2) * cos(delta * lat2)
        let lat3 = atan2(sin((1 - delta) * lat1) + sin(delta * lat2), sqrt(pow(x, 2) + pow(y, 2)))
        let lon3 = lon2 + atan2(y, sin((1 - delta) * lat1) * cos(delta * lat2))

        return CLLocationCoordinate2D(latitude: lat3.toDegrees, longitude: lon3.toDegrees)
    }
}
