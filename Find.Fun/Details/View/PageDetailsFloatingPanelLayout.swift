//
//  PageDetailsFloatingPanelLayout.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 25.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import FloatingPanel

internal class PageDetailsFloatingPanelLayout: FloatingPanelLayout {
    public var initialPosition: FloatingPanelPosition {
        return .half
    }
    
    public func insetFor(position: FloatingPanelPosition) -> CGFloat? {
        switch position {
        case .full: return 16.0 // A top inset from safe area
        case .half: return 264.0 // A bottom inset from the safe area
        case .tip: return 90.0 // A bottom inset from the safe area
        default: return nil // Or `case .hidden: return nil`
        }
    }
}
