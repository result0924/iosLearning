//
//  AboutCoordinator.swift
//  CoordinatorTest
//
//  Created by justin on 2020/02/19.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit

protocol AboutCoordinatorDelegate: class {
    func aboutCoordinatorDidTapClose(_ coordinator: AboutCoordinator)
}

final class AboutCoordinator: CoordinatorNavigable {
    var navigator: NavigatorType
    var childCoordinators: [Coordinator] = []
    var rootViewController: AboutViewController
    
    weak var delegate: AboutCoordinatorDelegate?
    
    init(navigator: NavigatorType) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withClass: AboutViewController.self)
        self.navigator = navigator
        rootViewController = vc
    }
    
    func start() {
        rootViewController.delegate = self
    }
    
}

extension AboutCoordinator: AboutViewControllerDelegate {
    func aboutViewControllerDidTapClose() {
        delegate?.aboutCoordinatorDidTapClose(self)
    }

}
