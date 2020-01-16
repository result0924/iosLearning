//
//  SettingsCoordinator.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/07.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit

// MARK: - Coordinator

final class SettingsCoordinator: NSObject, CoordinatorNavigable  {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var navigator: NavigatorType
    var rootViewController: SettingsViewController
    
    override init() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController {
            navigationController = UINavigationController(rootViewController: vc)
            navigator = Navigator(navigationController: navigationController)
            rootViewController = vc

        } else {
            fatalError("can't find SettingsViewController")
        }
    }
    
    func start() {
        
    }
    
}
