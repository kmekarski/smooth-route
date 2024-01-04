//
//  MapStateManager.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 08/11/2023.
//

import Foundation

class MapStateManager: ObservableObject {
    @Published var current: MapViewState = .initial
    @Published var previous: MapViewState?
    @Published var anchor: MapViewState = .initial
    
    func goBack() {
        if let previous = previous {
            current = previous
        }
    }
    
    func go(to: MapViewState) {
        previous = current
        current = to
        if current == .collectingDataWithRoute || current == .collectingDataWithoutRoute || current == .initial {
            anchor = current
        }
    }
    
    func goHome() {
        previous = current
        current = anchor
    }
}
