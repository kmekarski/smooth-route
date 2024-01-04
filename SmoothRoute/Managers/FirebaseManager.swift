//
//  FirebaseManager.swift
//  SmoothRoute
//
//  Created by Klaudiusz Mękarski on 19/11/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFunctions
import CoreLocation
import MapKit

struct MetaReportDistanceInfo: Decodable {
    let latitude: Double
    let longitude: Double
    let distance: Double
}

struct FirebaseRouteData: Decodable {
    let rating: Double
    let coverage: Double
}

final class FirebaseManager {
    private let reportsCollection = Firestore.firestore().collection("reports")
    private let metaReportsCollection = Firestore.firestore().collection("metaReports")
    private lazy var functions = Functions.functions()
    private func reportDocument(reportId: String) -> DocumentReference {
        return reportsCollection.document(reportId)
    }
    private func metaReportDocument(metaReportId: String) -> DocumentReference {
        return metaReportsCollection.document(metaReportId)
    }
    
    func sendReport(report: Report) throws {
        try reportDocument(reportId: report.id).setData(from: report, merge: false)
    }
    
    func getRoutes(routes: [MKRoute]) async throws -> [Route] {
//        routes.forEach { route in
//            var routePoints: [CLLocationCoordinate2D] = []
//            for index in 0..<route.polyline.pointCount - 1 {
//                print(route.polyline.points()[index].coordinate)
//                routePoints.append(route.polyline.points()[index].coordinate)
//            }
//            try? createTestMetaReports(coordinates: routePoints)
//        }
        var resultRoutes: [Route] = []
        for route in routes {
            var coordinates: [CLLocationCoordinate2D] = []
            
            for i in 0...route.polyline.pointCount {
                let coordinate = route.polyline.points().advanced(by: i).pointee.coordinate
                coordinates.append(coordinate)
            }
            let routeData = try await getRouteData(coordinates: coordinates, distance: route.distance)
            resultRoutes.append(Route(route: route, rating: routeData.rating, coverage: routeData.coverage))
        }
        return resultRoutes
    }
    
    func getRouteData(coordinates: [CLLocationCoordinate2D], distance: CLLocationDistance) async throws -> FirebaseRouteData {
        var latitudes: [Double] = []
        var longitudes: [Double] = []
        
        for (index, coordinate) in coordinates.enumerated() {
            if index < coordinates.count - 1 {
                latitudes.append(coordinate.latitude)
                longitudes.append(coordinate.longitude)
            }
        }
        
        do {
            print("trying to get route data...")
            let result = try await functions.httpsCallable("getRouteData").call([
                "latitudes": latitudes,
                "longitudes": longitudes,
                "distance": distance,
            ] as [String : Any])
            
            print("trying to decode the route data...")
            
            if let data = try? JSONSerialization.data(withJSONObject: result.data), let resultRoute = try? JSONDecoder().decode(FirebaseRouteData.self, from: data) {
                print("data about route from Firebase:", resultRoute)
                return resultRoute
            }
        } catch {
            print(error)
        }
        
        // Return a default ResultRoute if there's an error
        print("there was an error getting route data")
        return FirebaseRouteData(rating: 0, coverage: 2)
    }
    
    func createTestMetaReports(coordinates: [CLLocationCoordinate2D]) throws {
        try coordinates.forEach { coordinate in
            let metaReport = MetaReport(rating: 2.1, coordinate: coordinate)
            try metaReportDocument(metaReportId: metaReport.id).setData(from: metaReport, merge: false)
        }
    }
}
