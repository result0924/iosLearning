//
//  ViewController.swift
//  keyChainTest
//
//  Created by justin on 2018/7/20.
//  Copyright © 2018 justin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let service = "myService"
    let account = "myAccount"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        KeychainService.savePassword(service: service, account: account, data: "7533967")
        
        if let password = KeychainService.loadPassword(service: service, account: account) {
            print(password)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

