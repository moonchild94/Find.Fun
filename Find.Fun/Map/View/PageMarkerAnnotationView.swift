//
//  PageMarkerAnnotationView.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 24.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import MapKit

internal class PageMarkerAnnotationView: MKMarkerAnnotationView {
    private enum Constants {
        static let clusteringIdentifier = Bundle.main.bundleIdentifier! + ".PageMarkerAnnotationView"
    }

    override var annotation: MKAnnotation? {
        didSet {
            displayPriority = .required
            clusteringIdentifier = Constants.clusteringIdentifier
        }
    }
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        clusteringIdentifier = Constants.clusteringIdentifier
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
