//
//  Storyboard+Extension.swift
//  CoordinatorTest
//
//  Created by justin on 2020/02/19.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit

extension UIStoryboard {
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: String(describing: T.self)) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(String(describing: T.self)) ")
        }
        
        return viewController
    }
}
