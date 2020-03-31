//
//  NavigationFloatingPanelLayout.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 27.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import FloatingPanel

internal class NavigationFloatingPanelLayout: FloatingPanelLayout {
    var supportedPositions: Set<FloatingPanelPosition> {
        return [.tip]
    }
    
    public var initialPosition: FloatingPanelPosition {
        return .tip
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .tip: return 90.0 // A bottom inset from the safe area
        default: return nil
        }
    }
}
