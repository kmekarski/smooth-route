//
//  MapViewRepresentable.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 28/10/2023.
//

import SwiftUI
import MapKit

struct MapViewRepresentable: UIViewRepresentable {
    let mapView = MKMapView()
    let locationManager: LocationManager
    let firebaseManager: FirebaseManager
    
    @EnvironmentObject var locationSearchVM: LocationSearchViewModel
    @EnvironmentObject var routeSelectVM: RouteSelectViewModel
    @EnvironmentObject var mapStateManager: MapStateManager
    
    init(locationManager: LocationManager, firebaseManager: FirebaseManager) {
        self.locationManager = locationManager
        self.firebaseManager = firebaseManager
    }
    
    func makeUIView(context: Context) -> some UIView {
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.showsCompass = false
        
        return mapView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        switch mapStateManager.current {
        case .initial:
            context.coordinator.clearMapView()
        case .searchingForLocation:
            context.coordinator.clearMapView()
        case .selectingRoute:
            if locationSearchVM.routes.isEmpty && !locationSearchVM.isFetchingRoutes {
                var startingLocationCoordinate = CLLocationCoordinate2D()
                
                if let destinationCoordinate = locationSearchVM.selectedDestinationCoordinate, locationSearchVM.routes.isEmpty {
                    
                    if locationSearchVM.isStartingLocationEqualToCurrentLocation {
                        guard let userLocationCoordinate = context.coordinator.userLocationCoordinate else { return }
                        startingLocationCoordinate = userLocationCoordinate
                        context.coordinator.addAndSelectAnnotations(startingCoordinate: nil, destinationCoordinate: destinationCoordinate)
                        
                    } else {
                        guard let selectedStartingLocationCoordinate = locationSearchVM.selectedStartingLocationCoordinate else { return }
                        startingLocationCoordinate = selectedStartingLocationCoordinate
                        context.coordinator.addAndSelectAnnotations(startingCoordinate: startingLocationCoordinate, destinationCoordinate: destinationCoordinate)
                        
                    }
                    context.coordinator.configurePolylines(withDesinationCoordinate: destinationCoordinate)
                }
            }
            context.coordinator.bringCurrentRouteToFront()
            context.coordinator.changePolylineColors()
            
        case .locationSelected:
            break;
        case .collectingDataWithoutRoute:
            if routeSelectVM.drivingStarted == false {
                routeSelectVM.drivingStarted = true
                context.coordinator.setCameraToStartDriving()
            }
        case .collectingDataWithRoute:
            context.coordinator.clearUnselectedRoutes()
            if let startCoordinate = context.coordinator.userLocationCoordinate ?? locationSearchVM.selectedStartingLocationCoordinate,
               let destinationCoordinate = locationSearchVM.selectedDestinationCoordinate, routeSelectVM.drivingStarted == false {
                routeSelectVM.drivingStarted = true
                context.coordinator.setCameraToStartDriving(startCoordinate: startCoordinate, destinationCoordinate: destinationCoordinate)
            }
        }
    }
    
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(parent: self)
    }
}

extension MapViewRepresentable {
    
    class MapCoordinator: NSObject, MKMapViewDelegate {
        
        // MARK: - Properties
        
        var parent: MapViewRepresentable
        var userLocationCoordinate: CLLocationCoordinate2D?
        var currentRegion: MKCoordinateRegion?
        
        var polylines: [MKPolyline] = []
        var polylineRenderers: [MKPolylineRenderer] = []
        var overlayCopies: [MKOverlay] = []
        
        // MARK: - Lifecycle
        
        init(parent: MapViewRepresentable) {
            self.parent = parent
            super.init()
        }
        
        // MARK: - MKMapViewDelegate
        
        func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
            self.userLocationCoordinate = userLocation.coordinate
            let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            let region = MKCoordinateRegion(
                center: center,
                span: span)
            
            if self.currentRegion == nil {
                parent.mapView.setRegion(region, animated: true)
            }
            
            self.currentRegion = region
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !(annotation is MKUserLocation) else { return nil }
            guard let title = annotation.title else { return nil }

            let customPinView: UIView

            if title == "start" {
                customPinView = UIHostingController(rootView: StartPinView()).view
            } else if title == "destination" {
                customPinView = UIHostingController(rootView: DestinationPinView()).view
            } else {
                let index = routeIndexFromTitle(title ?? "0")
                let rating = routeRatingFromTitle(title ?? "0")
                let coverage = routeCoverageFromTitle(title ?? "0")

                customPinView = UIHostingController(rootView: RoutePinView(index: index, rating: rating, coverage: coverage)).view
            }

            let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "customPin")
            annotationView.addSubview(customPinView)

            return annotationView
        }

        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let polyLineRenderer = MKPolylineRenderer(overlay: polyline)
                let index = routeIndexFromTitle(polyline.title ?? "")
                polyLineRenderer.strokeColor = UIColor(parent.routeSelectVM.selectedRouteIndex == index ? Color.theme.routeHighlight : Color.gray)
                polyLineRenderer.lineWidth = 7
                addAnnotationWithRouteRating(polyline: polyline)
                polylineRenderers.append(polyLineRenderer)
                return polyLineRenderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
        
        // MARK: - Helpers
        
        func addAnnotationWithRouteRating(polyline: MKPolyline) {
            let annotation = MKPointAnnotation()
            let points = polyline.points()
            let midCoordinate = points[polyline.pointCount / 2].coordinate
            annotation.coordinate = midCoordinate
            annotation.title = polyline.title
            parent.mapView.addAnnotation(annotation)
        }
        
        func routeIndexFromTitle(_ title: String) -> Int {
            let components = title.components(separatedBy: " ")
            if components.count > 0, let index = Int(components[0]) {
                return index
            } else {
                return 0
            }
        }
        
        func routeRatingFromTitle(_ title: String) -> Double {
            let components = title.components(separatedBy: " ")
            if components.count > 1, let rating = Double(components[1]) {
                return rating
            } else {
                return 0
            }
        }
        
        func routeCoverageFromTitle(_ title: String) -> Double {
            let components = title.components(separatedBy: " ")
            if components.count > 2, let coverage = Double(components[2]) {
                return coverage
            } else {
                return 0
            }
        }
        
        func addAndSelectAnnotations(startingCoordinate: CLLocationCoordinate2D?, destinationCoordinate: CLLocationCoordinate2D) {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
            let startAnnotation = MKPointAnnotation()
            if let startingCoordinate = startingCoordinate {
                startAnnotation.coordinate = startingCoordinate
                startAnnotation.title = "start"
                parent.mapView.addAnnotation(startAnnotation)
            } else {
                startAnnotation.coordinate = userLocationCoordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)
            }
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.coordinate = destinationCoordinate
            destinationAnnotation.title = "destination"
            parent.mapView.addAnnotation(destinationAnnotation)
            parent.mapView.selectAnnotation(destinationAnnotation, animated: true)
            
            setCameraToShowRoutes(startCoordinate: startAnnotation.coordinate, destinationCoordinate: destinationAnnotation.coordinate)
        }
        
        @MainActor func configurePolylines(withDesinationCoordinate coordinate: CLLocationCoordinate2D) {
            var startingLocationCoordinate = CLLocationCoordinate2D()
            if parent.locationSearchVM.isStartingLocationEqualToCurrentLocation {
                guard let userLocationCoordinate = self.userLocationCoordinate else { return }
                startingLocationCoordinate = userLocationCoordinate
            } else {
                guard let selectedStartingLocationCoordinate = parent.locationSearchVM.selectedStartingLocationCoordinate else { return }
                startingLocationCoordinate = selectedStartingLocationCoordinate
            }
            getDestinationRoute(from: startingLocationCoordinate, to: coordinate) {
                for (index, route) in self.parent.locationSearchVM.routes.enumerated() {
                    let polyline = route.route.polyline
                    polyline.title = "\(index) \(route.rating) \(route.coverage)"
                    self.polylines.append(polyline)
                    self.parent.mapView.addOverlay(polyline, level: .aboveRoads)
                    self.overlayCopies.append(polyline)
                }
            }
        }
        
        @MainActor func getDestinationRoute(from startingLocation: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping() -> Void) {
            withAnimation(.linear) {
                self.parent.locationSearchVM.isFetchingRoutes = true
            }
            let startingLocationPlacemark = MKPlacemark(coordinate: startingLocation)
            let destinationPlacemark = MKPlacemark(coordinate: destination)
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: startingLocationPlacemark)
            request.destination = MKMapItem(placemark: destinationPlacemark)
            request.requestsAlternateRoutes = true
            let directions = MKDirections(request: request)
            
            directions.calculate { response, error in
                if let error = error {
                    print("Route generating failed with an error: \(error.localizedDescription)")
                    return
                }
                guard let routes = response?.routes else { return }
                Task {
                    do {
                        self.parent.locationSearchVM.routes = try await self.parent.firebaseManager.getRoutes(routes: routes)
                    }
                    catch {
                        print(error)
                    }
                    withAnimation(.linear) {
                        self.parent.locationSearchVM.isFetchingRoutes = false
                    }
                    completion()
                }
            }
        }
        
        func calculateCameraAltitude(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) -> CLLocationDistance {
            let earthRadius: CLLocationDistance = 6371000
            
            let startLatRad = startCoordinate.latitude * .pi / 180
            let startLonRad = startCoordinate.longitude * .pi / 180
            let destLatRad = destinationCoordinate.latitude * .pi / 180
            let destLonRad = destinationCoordinate.longitude * .pi / 180
            let deltaLat = destLatRad - startLatRad
            let deltaLon = destLonRad - startLonRad
            
            // Haversine formula to calculate great-circle distance
            let a = sin(deltaLat / 2) * sin(deltaLat / 2) +
            cos(startLatRad) * cos(destLatRad) *
            sin(deltaLon / 2) * sin(deltaLon / 2)
            let c = 2 * atan2(sqrt(a), sqrt(1 - a))
            
            let groundDistance = earthRadius * c
            let altitudeFactor: CLLocationDistance = 1.5
            let cameraAltitude = groundDistance * altitudeFactor
            return cameraAltitude
        }
        
        func calculateHeading(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) -> CLLocationDirection {
            let deltaLongitude = destination.longitude - source.longitude
            let deltaLatitude = destination.latitude - source.latitude
            let angle = atan2(deltaLongitude, deltaLatitude)
            let heading = (angle * 180.0) / Double.pi
            return heading
        }
        
        func setCameraToShowRoutes(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
            let startLat = startCoordinate.latitude
            let startLon = startCoordinate.longitude
            let destLat = destinationCoordinate.latitude
            let destLon = destinationCoordinate.longitude
            let center = CLLocationCoordinate2D(latitude: (startLat + destLat) / 2, longitude: (startLon + destLon) / 2)
            let distance = calculateCameraAltitude(startCoordinate: startCoordinate, destinationCoordinate: destinationCoordinate)
            let camera = MKMapCamera(lookingAtCenter: center, fromDistance: distance * 3, pitch: 0, heading: calculateHeading(from: startCoordinate, to: destinationCoordinate))
            parent.mapView.setCamera(camera, animated: true)
        }
        
        func setCameraToStartDriving(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
            let start = userLocationCoordinate ?? startCoordinate
            let camera = MKMapCamera(lookingAtCenter: start, fromDistance: 2000, pitch: 0, heading: calculateHeading(from: start, to: destinationCoordinate))
            parent.mapView.setCamera(camera, animated: true)
        }
        
        func setCameraToStartDriving() {
            if let userLocation = userLocationCoordinate {
                let camera = MKMapCamera(lookingAtCenter: userLocation, fromDistance: 2000, pitch: 0, heading: .zero)
                parent.mapView.setCamera(camera, animated: true)
            }
        }
        
        func clearUnselectedRoutes() {
            clearOverlays()
            let selectedRouteIndex = parent.routeSelectVM.selectedRouteIndex
            parent.mapView.addOverlay(overlayCopies[selectedRouteIndex], level: .aboveRoads)
            
            let routeAnnotations = parent.mapView.annotations.filter { annotation in
                return annotation.title != "start" && annotation.title != "destination"
            }
            parent.mapView.removeAnnotations(routeAnnotations)
        }
        
        func clearAnnotations() {
            parent.mapView.removeAnnotations(parent.mapView.annotations)
        }
        
        func clearMapView() {
            parent.routeSelectVM.drivingStarted = false
            clearAnnotations()
            clearOverlays()
            if let currentRegion = self.currentRegion {
                parent.mapView.setRegion(currentRegion, animated: true)
            }
            overlayCopies = []
        }
        
        func clearOverlays() {
            parent.mapView.removeOverlays(parent.mapView.overlays)
        }
        
        func bringCurrentRouteToFront() {
            clearOverlays()
            let selectedRouteIndex = parent.routeSelectVM.selectedRouteIndex
            guard overlayCopies.count > selectedRouteIndex else { return }
            for (index, overlay) in overlayCopies.enumerated() {
                if index != selectedRouteIndex {
                    parent.mapView.addOverlay(overlay, level: .aboveRoads)
                }
            }
            parent.mapView.addOverlay(overlayCopies[selectedRouteIndex], level: .aboveRoads)
        }
        
        func changePolylineColors() {
            let selectedRouteIndex = parent.routeSelectVM.selectedRouteIndex
            guard overlayCopies.count > selectedRouteIndex else { return }
            for (index, _) in polylines.enumerated() {
                let renderer = polylineRenderers[index]
                withAnimation(.linear(duration: 0.2)) {
                    renderer.strokeColor = index == selectedRouteIndex ? UIColor(Color.theme.routeHighlight) : UIColor(Color.gray)
                }
            }
        }
    }
}
