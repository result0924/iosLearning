//
//  ViewController.swift
//  keyChainTest2
//
//  Created by justin on 2018/7/24.
//  Copyright © 2018 justin. All rights reserved.
//

import UIKit
import Crashlytics

struct KeychainConfiguration {
    static let serviceName = "TestKeyChain"
    static var serviceGroup: String?
    
    init(serviceGroup: String) {
        if let appIdentifierPrefix = Bundle.main.infoDictionary?["AppIdentifierPrefix"] as? String {
            self.init(serviceGroup: appIdentifierPrefix + "group.h2.keyChainTest")
        } else {
            self.init(serviceGroup: "")
        }
    }
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        do {
            let password = try KeychainService(service: KeychainConfiguration.serviceName, account: "justin", accessGroup: KeychainConfiguration.serviceGroup).readToken()
            print("password:\(password)")
        } catch {
            print(error)
        }
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: UIScreen.main.bounds.size.width / 2 - 50, y: 200, width: 100, height: 44)
        button.setTitle("Test Crash", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func crashButtonTapped(_ sender: AnyObject) {
//        let error = NSError(domain: "test non-fatal issue", code: -1, userInfo: nil)
//        Crashlytics.sharedInstance().recordError(error)
        assert(false)
    }
    
}

