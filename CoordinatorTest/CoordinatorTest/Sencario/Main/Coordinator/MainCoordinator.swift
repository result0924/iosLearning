//
//  MainCoordinator.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/07.
//  Copyright © 2020 jlai. All rights reserved.
//
import UIKit

final class MainCoordinator: CoordinatorNavigable {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var navigator: NavigatorType
    var rootViewController: MainViewController
    
    init() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withClass: MainViewController.self)
        navigationController = UINavigationController(rootViewController: vc)
        navigator = Navigator(navigationController: navigationController)
        rootViewController = vc
    }
    
    func start() {
        rootViewController.delegate = self
    }
    
}

extension MainCoordinator: MainViewControllerDelegate {
    func tapCellWithIndexPath(_ indexPath: IndexPath) {
        let aboutCoordinator = AboutCoordinator(navigator: navigator)
        
        if 0 == indexPath.row {
            pushCoordinator(aboutCoordinator, animated: true)
        } else {
            aboutCoordinator.delegate = self
            presentCoordinator(aboutCoordinator, animated: true, style: .fullScreen)
        }
        
    }
}

extension MainCoordinator: AboutCoordinatorDelegate {
    func aboutCoordinatorDidTapClose(_ coordinator: AboutCoordinator) {
        dismissCoordinator(coordinator, animated: true)
    }
    
}
