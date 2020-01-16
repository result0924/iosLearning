//
//  MainTabBarCoordinator.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/07.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit

final class MainTabBarCoordinator: CoordinatorPresentable {
    var childCoordinators: [Coordinator] = []
    var rootViewController: MainTabBarController
    
    init(_ rootVC: MainTabBarController) {
        rootViewController = rootVC
    }
    
    func start() {
        rootViewController.selectVC(.main)
    }
    
}
