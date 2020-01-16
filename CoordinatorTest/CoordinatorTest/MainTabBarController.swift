//
//  MainTabBarController.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/02.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit

enum TabBarViewController {
    case main
    case settings
}

class MainTabBarController: UITabBarController {
    var mainCoordinator = MainCoordinator()
    var settingsCoordinator = SettingsCoordinator()

    override func viewDidLoad() {
        super.viewDidLoad()
        let mainNavigation = mainCoordinator.navigationController
        let settingsNavigation = settingsCoordinator.navigationController
        
        let mainViewController = mainCoordinator.rootViewController
        mainViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 0)
        
        let settingsViewController = settingsCoordinator.rootViewController
        settingsViewController.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        let controllers: [UIViewController] = [mainNavigation, settingsNavigation]
        
        self.viewControllers = controllers
        self.tabBar.isTranslucent = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectVC(_ tabBarViewController: TabBarViewController) {
        switch tabBarViewController {
        case .main:
            self.selectedIndex = 0
            mainCoordinator.start()
        case .settings:
            self.selectedIndex = 1
            settingsCoordinator.start()
        }
    }

}
