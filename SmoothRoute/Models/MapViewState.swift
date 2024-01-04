//
//  apViewState.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 29/10/2023.
//

import Foundation

enum MapViewState {
    case initial
    case searchingForLocation
    case locationSelected
    case selectingRoute
    case collectingDataWithoutRoute
    case collectingDataWithRoute
}
