//
//  AppDelegate.swift
//  Find.Fun
//
//  Created by Daria Kalmykova on 24.03.2020.
//  Copyright © 2020 Daria Kalmykova. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let coordinator = Coordinator()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = coordinator.rootViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

