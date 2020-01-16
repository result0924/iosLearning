//
//  AppDelegateCoordinator.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/15.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit

final class AppDelegateCoordinator: CoordinatorPresentable {
    
    var childCoordinators: [Coordinator] = []
    var rootViewController: MainTabBarController
    
    init(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as? MainTabBarController {
            rootViewController = vc
        
            window.rootViewController = vc
            window.makeKeyAndVisible()
        } else {
            fatalError("can't find MainTabBarController")
        }
    }
    
    func start() {
        let tabBarCoordinator = MainTabBarCoordinator(rootViewController)
        tabBarCoordinator.start()
    }
    
}
