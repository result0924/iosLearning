//
//  AppDelegate.swift
//  CoordinatorTest
//
//  Created by justin on 2019/12/27.
//  Copyright © 2019 jlai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        let appCoordinator = AppDelegateCoordinator(window: window)
        appCoordinator.start()
        return true
    }
    
}

