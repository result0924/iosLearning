//
//  MainCoordinator.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/07.
//  Copyright © 2020 jlai. All rights reserved.
//
import UIKit

final class MainCoordinator: NSObject, CoordinatorNavigable  {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var navigator: NavigatorType
    var rootViewController: MainViewController
    
    override init() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        if let vc = storyboard.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController {
            navigationController = UINavigationController(rootViewController: vc)
            navigator = Navigator(navigationController: navigationController)
            rootViewController = vc
        } else {
            fatalError("can't find MainViewController")
        }
    }
    
    func start() {
        rootViewController.delegate = self
    }
    
}

extension MainCoordinator: MainViewControllerDelegate {
    func tapCellWithIndexPath(_ indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let aboutVC = storyboard.instantiateViewController(withIdentifier: "AboutViewController")
        navigator.push(aboutVC, animated: true)
    }
}
