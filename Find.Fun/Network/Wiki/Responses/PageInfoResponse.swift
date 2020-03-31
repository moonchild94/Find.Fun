//
//  PageInfoResponse.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 24.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Foundation

internal struct LocationInfo: Decodable, Equatable {
    let latitude: Double
    let longitude: Double
    let distance: Double
    
     private enum CodingKeys : String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
        case distance = "dist"
    }
}

internal struct PageInfo: Decodable, Equatable {
    let id: UInt64
    let title: String
    let description: String?
    let url: String
    let locations: [LocationInfo]

     private enum CodingKeys : String, CodingKey {
        case id = "pageid"
        case title
        case description
        case url = "fullurl"
        case locations = "coordinates"
    }
}

internal struct PageInfoResponse: Decodable {
    let pages: [PageInfo]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let query = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .query)
        pages = try query.decode([PageInfo].self, forKey: .pages)
    }
    
     private enum CodingKeys : String, CodingKey {
        case pages
        case query
    }
}
