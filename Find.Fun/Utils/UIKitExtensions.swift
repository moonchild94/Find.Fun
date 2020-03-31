//
//  UIKitExtensions.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 29.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit

extension UILabel {
    var numberOfVisibleLines: Int {
        return Int(round(frame.size.height / font.lineHeight))
    }
}
