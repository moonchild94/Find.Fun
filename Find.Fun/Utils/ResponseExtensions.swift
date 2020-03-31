//
//  ResponseExtensions.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 31.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

extension LocationInfo {
    func convertToCoordinate() -> Coordinate {
        return Coordinate(latitude: latitude, longitude: longitude)
    }
}
