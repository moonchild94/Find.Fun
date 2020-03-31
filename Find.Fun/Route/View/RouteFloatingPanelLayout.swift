//
//  RouteFloatingPanelLayout.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 26.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit
import FloatingPanel

internal class RouteFloatingPanelLayout: FloatingPanelLayout {
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.half, .tip]
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .half: return 264.0 // A bottom inset from the safe area
        case .tip: return 90.0 // A bottom inset from the safe area
        default: return nil
        }
    }
}
