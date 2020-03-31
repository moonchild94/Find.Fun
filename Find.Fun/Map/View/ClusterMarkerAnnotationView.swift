//
//  ClusterMarkerAnnotationView.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 24.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import MapKit

internal class ClusterMarkerAnnotationView: MKMarkerAnnotationView {
    private enum Constants {
        static let preferredClusteringIdentifier = Bundle.main.bundleIdentifier! + ".ClusterMarkerAnnotationView"
    }

    override var annotation: MKAnnotation? {
        didSet {
            displayPriority = .required
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
