//
//  MapKitExtensions.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 24.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import MapKit
import Polyline

extension MKPolyline {
    static func from(encoded: String) -> MKPolyline? {
        return Polyline(encodedPolyline: encoded).mkPolyline
    }
}
