//
//  RouteSelectViewModel.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 16/12/2023.
//

import Foundation

final class RouteSelectViewModel: ObservableObject {
    @Published var selectedRouteIndex = 0
    var drivingStarted: Bool = false
}
