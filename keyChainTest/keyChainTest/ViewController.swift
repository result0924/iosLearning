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
    static let accessGroup: String? = nil
}

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let password = try KeychainService(service: KeychainConfiguration.serviceName, account: "justin", accessGroup: KeychainConfiguration.accessGroup).readToken()
            print("password:\(password)")
        } catch {
            print(error)
        }
        
        do {
            // This is a new account, create a new keychain item with the account name.
            let tokenItem = KeychainService(service: KeychainConfiguration.serviceName,
                                                    account: "justin",
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try tokenItem.saveToken("123456")
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        do {
            let token = try KeychainService(service: KeychainConfiguration.serviceName,
                                            account: "justin",
                                            accessGroup: KeychainConfiguration.accessGroup).readToken()
            print("token:\(token)")
        } catch {
            print(error)
        }
        
        do {
            // This is a new account, create a new keychain item with the account name.
            let tokenItem = KeychainService(service: KeychainConfiguration.serviceName,
                                               account: "justin",
                                               accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try tokenItem.saveToken("7533967")
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        do {
            let token = try KeychainService(service: KeychainConfiguration.serviceName,
                                            account: "justin",
                                            accessGroup: KeychainConfiguration.accessGroup).readToken()
            print("token:\(token)")
        } catch {
            print(error)
        }
        
        do {
            // This is a new account, create a new keychain item with the account name.
            let tokenItem = KeychainService(service: KeychainConfiguration.serviceName,
                                            account: "justin",
                                            accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try tokenItem.deleteItem()
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        do {
            let token = try KeychainService(service: KeychainConfiguration.serviceName,
                                            account: "justin",
                                            accessGroup: KeychainConfiguration.accessGroup).readToken()
            print("token:\(token)")
            
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

