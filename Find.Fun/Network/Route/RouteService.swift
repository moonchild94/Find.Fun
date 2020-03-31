//
//  RouteService.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 27.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Apollo

internal class RouteService {
    private enum Constants {
        static let baseUrl = "https://api.digitransit.fi/routing/v1/routers/hsl/index/graphql"
    }
    
    private let graphQLClient = ApolloClient(url: URL(string: Constants.baseUrl)!)
    
    func fetchRoutes(from: Coordinate,
                     to: Coordinate,
                     type: TransportType,
                     completion: @escaping (RouteResponse?, Error?) -> Void) {
        let planQuery = PlanQuery(fromPlace: from.queryString,
                                  toPlace: to.queryString,
                                  numItineraries: 1,
                                  transportModes: [type.convertToTransportMode()])
        
        graphQLClient.fetch(query: planQuery, cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .failure(let error):
                completion(nil, error)
            case .success(let graphQLResult):
                guard let plan = graphQLResult.data?.plan else {
                    completion(nil, RouteServiceError.invalidResponse)
                    return
                }
                
                guard !plan.itineraries.isEmpty,
                    let itinerary = plan.itineraries[0],
                    !itinerary.legs.isEmpty,
                    let leg = itinerary.legs[0],
                    let encodedPolyline = leg.legGeometry?.points else {
                    completion(nil, RouteServiceError.invalidResponse)
                    return
                }
                
                let distance = Int(leg.distance ?? 0)
                let duration = Int(itinerary.duration ?? "0") ?? 0
                
                let route = RouteResponse(duration: duration,
                                          distance: distance,
                                          encodedPolyline: encodedPolyline)
                
                completion(route, nil)
            }
        }
    }
}

internal enum RouteServiceError: Error {
    case invalidResponse
    case emptyResponse
    case unknown
}

private extension TransportType {
    func convertToTransportMode() -> TransportMode {
        switch self {
        case .walk:
            return TransportMode(mode: .walk)
        case .car:
            return TransportMode(mode: .car)
        }
    }
}

private extension Coordinate {
    var queryString: String {
        return "\(latitude),\(longitude)"
    }
}
