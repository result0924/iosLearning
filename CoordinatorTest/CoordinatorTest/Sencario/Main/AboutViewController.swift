//
//  AboutViewController.swift
//  CoordinatorTest
//
//  Created by justin on 2020/01/03.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit

protocol AboutViewControllerDelegate: class {
    func aboutViewControllerDidTapClose()
}

class AboutViewController: UIViewController {
    weak var delegate: AboutViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "About"
        
        if self.navigationController == nil {
            let closeButton = UIButton.init(frame: CGRect(x: 20, y: 20, width: 60, height: 40))
            closeButton.backgroundColor = .red
            closeButton.setTitle("Close", for: .normal)
            closeButton.setTitleColor(.white, for: .normal)
            closeButton.addTarget(self, action: #selector(tapClose), for: .touchUpInside)
            self.view.addSubview(closeButton)
        }
    }
    
    @objc func tapClose() {
        delegate?.aboutViewControllerDidTapClose()
    }

}
