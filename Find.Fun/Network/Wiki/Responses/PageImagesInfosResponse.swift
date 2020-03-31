//
//  PageImagesInfosResponse.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 27.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

internal struct PageImagesInfosResponse: Decodable {
    let infos: [ImageInfo]
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let query = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .query)
        let pages = try query.decode([PageImageInfo].self, forKey: .infos)
        infos = pages.map { $0.infos[0] }
    }
    
    private enum CodingKeys: String, CodingKey {
        case infos = "pages"
        case query
    }
}

internal struct ImageInfo: Decodable {
    let url: String
    let thumbUrl: String
    let mediaType: MediaType
    let thumbWidth: Int
    let thumbHeight: Int
    
    private enum CodingKeys: String, CodingKey {
        case url
        case thumbUrl = "thumburl"
        case mediaType = "mediatype"
        case thumbWidth = "thumbwidth"
        case thumbHeight = "thumbheight"
    }
}

internal enum MediaType: String, Decodable {
    case bitmap = "BITMAP"
    case drawing = "DRAWING"
}

private struct PageImageInfo: Decodable {
    let infos: [ImageInfo]
    
    private enum CodingKeys: String, CodingKey {
        case infos = "imageinfo"
    }
}
