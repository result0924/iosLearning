//
//  ViewController.swift
//  BiometricIDAuthTest
//
//  Created by justin on 2019/4/1.
//  Copyright © 2019 h2. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var isAuthenticated = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !isAuthenticated {
            self.performSegue(withIdentifier: "identifierMe", sender: nil)
        }
        
        isAuthenticated = true
    }

    @IBAction func tryAgain() {
        self.performSegue(withIdentifier: "identifierMe", sender: nil)
    }
    
}

