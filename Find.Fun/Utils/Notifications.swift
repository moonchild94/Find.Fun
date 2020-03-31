//
//  Notifications.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 30.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let didReceiveRoute = Notification.Name("didReceiveRoute")
}

internal enum NotificationKeys {
    static let route = "route"
}
