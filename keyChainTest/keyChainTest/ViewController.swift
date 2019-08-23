//
//  ViewController.swift
//  keyChainTest
//
//  Created by justin on 2018/7/20.
//  Copyright © 2018 justin. All rights reserved.
//

import UIKit

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
    
    @IBOutlet weak var keychainValueLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        do {
            let token = try KeychainService(service: KeychainConfiguration.serviceName,
                                            account: "justin",
                                            accessGroup: KeychainConfiguration.serviceGroup).readToken()
            keychainValueLabel.text = token
        } catch {
            print(error)
        }
        
//        do {
//            // This is a new account, create a new keychain item with the account name.
//            let tokenItem = KeychainService(service: KeychainConfiguration.serviceName,
//                                                    account: "justin",
//                                                    accessGroup: KeychainConfiguration.serviceGroup)
//
//            // Save the password for the new item.
//            try tokenItem.saveToken("123456")
//        } catch {
//            fatalError("Error updating keychain - \(error)")
//        }
//
//        do {
//            let token = try KeychainService(service: KeychainConfiguration.serviceName,
//                                            account: "justin",
//                                            accessGroup: KeychainConfiguration.serviceGroup).readToken()
//            print("token:\(token)")
//        } catch {
//            print(error)
//        }
//
//        do {
//            // This is a new account, create a new keychain item with the account name.
//            let tokenItem = KeychainService(service: KeychainConfiguration.serviceName,
//                                               account: "justin",
//                                               accessGroup: KeychainConfiguration.serviceGroup)
//
//            // Save the password for the new item.
//            try tokenItem.saveToken("7533968")
//        } catch {
//            fatalError("Error updating keychain - \(error)")
//        }
//
//        do {
//            let token = try KeychainService(service: KeychainConfiguration.serviceName,
//                                            account: "justin",
//                                            accessGroup: KeychainConfiguration.serviceGroup).readToken()
//            print("token:\(token)")
//        } catch {
//            print(error)
//        }
        
    }
    
    func updateLabel() {
        if keychainValueLabel.text?.contains("token") ?? false {
            return
        }
        
        do {
            let token = try KeychainService(service: KeychainConfiguration.serviceName,
                                            account: "justin",
                                            accessGroup: KeychainConfiguration.serviceGroup).readToken()
            
            if token.isEmpty {
                keychainValueLabel.text = "token is clear"
            } else {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                
                let currentTime = Date()
                keychainValueLabel.text = formatter.string(from: currentTime)
            }
        } catch {
            keychainValueLabel.text = "token is clear error: \(error)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

