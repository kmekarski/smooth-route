//
//  LocationSearchViewModel.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 29/10/2023.
//

import Foundation
import MapKit
import SwiftUI

class LocationSearchViewModel: NSObject, ObservableObject {
    
    // MARK: - Properties
    
    @Published var startingLocationResults = [MKLocalSearchCompletion]()
    @Published var destinationResults = [MKLocalSearchCompletion]()
    
    @Published var routes: [Route] = []
    
    @Published var selectedDestinationCoordinate: CLLocationCoordinate2D?
    @Published var selectedDestinationTitle: String?
    
    @Published var selectedStartingLocationCoordinate: CLLocationCoordinate2D?
    @Published var selectedStartingLocationTitle: String?
    
    @Published var startingTime: Date?
    @Published var arrivalTime: Date?
    
    var requestedLocationsType: RequestedLocationType = .destination
    
    private var startingLocationSelected: Bool = false
    private var destinationSelected: Bool = false
    
    var readyForGeneratingRoute: Bool {
        return destinationSelected && (startingLocationSelected || startingLocationQueryFragment == "") && isDestinationCorrect && isStartingLocationCorrect && (selectedStartingLocationTitle != selectedDestinationTitle)
    }
    
    @Published var isStartingLocationCorrect: Bool = true
    @Published var isDestinationCorrect: Bool = true
    
    var isStartingLocationEqualToCurrentLocation: Bool {
        return startingLocationQueryFragment == ""
    }
    
    @Published var showResults: Bool = true
    
    @Published var isFetchingRoutes: Bool = false
    
    private let startingLocationSearchCompleter = MKLocalSearchCompleter()
    private let destinationSearchCompleter = MKLocalSearchCompleter()
    
    @Published var isFetchingLocations: Bool = false
    
    @Published var destinationQueryFragment: String = "" {
        didSet {
            showResults = true
            destinationSelected = false
            isDestinationCorrect = true
            destinationSearchCompleter.queryFragment = destinationQueryFragment
            if destinationQueryFragment == "" {
                destinationResults = []
                routes = []
            }
            isFetchingLocations = destinationQueryFragment != "" && destinationResults.isEmpty
            
        }
    }
    @Published var startingLocationQueryFragment: String = "" {
        didSet {
            showResults = true
            startingLocationSelected = false
            isStartingLocationCorrect = true
            startingLocationSearchCompleter.queryFragment = startingLocationQueryFragment
            if startingLocationQueryFragment == "" {
                startingLocationResults = []
                routes = []
            }
            isFetchingLocations = startingLocationQueryFragment != "" && startingLocationResults.isEmpty
        }
    }
    
    override init() {
        super.init()
        destinationSearchCompleter.delegate = self
        destinationSearchCompleter.queryFragment = destinationQueryFragment
        startingLocationSearchCompleter.delegate = self
        startingLocationSearchCompleter.queryFragment = startingLocationQueryFragment
    }
    
    func addRoute(_ route: Route) {
        routes.append(route)
    }
    
    func selectRequestedLocationsType(_ locationsType: RequestedLocationType) {
        requestedLocationsType = locationsType
    }
    
    func clearSelectedLocations() {
        startingLocationSelected = false
        destinationSelected = false
        selectedStartingLocationTitle = ""
        selectedDestinationTitle = ""
        selectedStartingLocationCoordinate = nil
        selectedDestinationCoordinate = nil
        requestedLocationsType = .destination
        routes = []
    }
    
    func clearQueries() {
        startingLocationQueryFragment = ""
        destinationQueryFragment = ""
    }
    
    func selectStartingLocation(_ localSearch: MKLocalSearchCompletion) {
        startingLocationQueryFragment = localSearch.title
        requestedLocationsType = .startingLocation
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                self.isStartingLocationCorrect = false
                print("Location search failed with an error: \(error.localizedDescription)")
                return
            }
            self.isStartingLocationCorrect = true
            self.startingLocationSelected = true
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selectedStartingLocationCoordinate = coordinate
            self.selectedStartingLocationTitle = localSearch.title
            self.showResults = false
        }
    }
    
    func selectDestination(_ localSearch: MKLocalSearchCompletion) {
        destinationQueryFragment = localSearch.title
        requestedLocationsType = .destination
        locationSearch(forLocalSearchCompletion: localSearch) { response, error in
            if let error = error {
                self.isDestinationCorrect = false
                print("Location search failed with an error: \(error.localizedDescription)")
                return
            }
            self.destinationSelected = true
            self.isDestinationCorrect = true
            guard let item = response?.mapItems.first else { return }
            let coordinate = item.placemark.coordinate
            self.selectedDestinationCoordinate = coordinate
            self.selectedDestinationTitle = localSearch.title
            self.showResults = false
        }
    }
    
    func locationSearch(forLocalSearchCompletion localSearch: MKLocalSearchCompletion, completion: @escaping MKLocalSearch.CompletionHandler) {
        let searchRequest = MKLocalSearch.Request()
        searchRequest.naturalLanguageQuery = localSearch.title.appending(localSearch.subtitle)
        let search = MKLocalSearch(request: searchRequest)
        search.start(completionHandler: completion)
    }
}

// MARK: - MKLocalSearchCompleterDelegate

extension LocationSearchViewModel: MKLocalSearchCompleterDelegate {
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        isFetchingLocations = false
        switch requestedLocationsType {
        case .startingLocation:
            self.startingLocationResults = completer.results
            break
        case .destination:
            self.destinationResults = completer.results
            break
        }
    }
    
}
