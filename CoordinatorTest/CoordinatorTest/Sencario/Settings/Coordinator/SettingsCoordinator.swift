//
//  SettingsCoordinator.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/07.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit

// MARK: - Coordinator

final class SettingsCoordinator: CoordinatorNavigable  {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var navigator: NavigatorType
    var rootViewController: SettingsViewController
    
    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withClass: SettingsViewController.self)
        
        navigationController = UINavigationController(rootViewController: vc)
        navigator = Navigator(navigationController: navigationController)
        rootViewController = vc
    }
    
    func start() {
        
    }
    
}
