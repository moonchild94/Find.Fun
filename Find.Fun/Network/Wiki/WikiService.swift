//
//  WikiService.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 28.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Foundation

internal class WikiService {
    private enum Constants {
        static let baseUrl = "https://en.wikipedia.org/w/api.php"
        static let baseParams: [String: Any] = ["action": "query",
                                                "format": "json",
                                                "formatversion": "2"
        ]
        
        static let thumnailSize = 200
    }
    
    func getPagesInfos(near coordinate: Coordinate,
                       for radius: Int,
                       with limit: Int,
                       completion: @escaping (PageInfoResponse?, Error?) -> Void) {
        let params: [String: Any] = ["generator":"geosearch",
                                     "ggsradius": radius,
                                     "ggslimit": limit,
                                     "prop": "coordinates|description|info",
                                     "inprop": "url",
                                     "ggscoord": coordinate.queryString,
                                     "codistancefrompoint": coordinate.queryString,
                                     "colimit":limit
        ]
        
        executeQuery(with: params) { response, error in completion(response, error) }
    }
    
    func getImagesInfos(for pageId: UInt64,
                        with scale: Int,
                        completion: @escaping (PageImagesInfosResponse?, Error?) -> Void) {
        let params: [String: Any] = ["generator": "images",
                                     "pageids": pageId,
                                     "gimlimit": 50,
                                     "prop": "imageinfo",
                                     "iiprop": "url|mediatype",
                                     "iiurlwidth": Constants.thumnailSize * scale,
                                     "iiurlheight": Constants.thumnailSize * scale
            
        ]
        
        executeQuery(with: params) { response, error in completion(response, error) }
    }
    
    private func executeQuery<T: Decodable>(with params: [String: Any], completion: @escaping (T?, Error?) -> Void) {
        var queryParams = Constants.baseParams
        queryParams.merge(params) { (current, _) in current }
        guard let url = URL(baseUrl: Constants.baseUrl, params: queryParams) else {
            completion(nil, WikiServiceError.invalidRequest)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, WikiServiceError.unknown)
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(nil, WikiServiceError.httpError(statusCode: httpResponse.statusCode))
                return
            }
            
            guard let data = data else {
                completion(nil, WikiServiceError.emptyResponse)
                return
            }
            
            guard let response = try? JSONDecoder().decode(T.self, from: data) else {
                completion(nil, WikiServiceError.invalidResponse)
                return
            }
            
            completion(response, nil)
        }
        
        task.resume()
    }
}

internal enum WikiServiceError: Error {
    case invalidRequest
    case httpError(statusCode: Int)
    case emptyResponse
    case invalidResponse
    case unknown
}

private extension Coordinate {
    var queryString: String {
        return "\(latitude)|\(longitude)"
    }
}

private extension URL {
    init?(baseUrl: String, params: Dictionary<String, Any>) {
        guard var components = URLComponents(string: baseUrl) else { return nil }
        components.queryItems = params.map { pair in
            URLQueryItem(name: pair.key, value: String(describing: pair.value))
        }
        
        guard let url = components.url else { return nil }
        self = url
    }
}
