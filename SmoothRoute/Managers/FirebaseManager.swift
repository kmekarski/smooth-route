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
            let result = try await functions.httpsCallable("getRouteData").call([
                "latitudes": latitudes,
                "longitudes": longitudes,
                "distance": distance,
            ] as [String : Any])
            if let data = try? JSONSerialization.data(withJSONObject: result.data), let resultRoute = try?
                JSONDecoder().decode(FirebaseRouteData.self, from: data) {
                return resultRoute
            }
        } catch {
            print(error)
        }
        
        // Return a default ResultRoute if there's an error
        return FirebaseRouteData(rating: 0, coverage: 2)
    }
}
