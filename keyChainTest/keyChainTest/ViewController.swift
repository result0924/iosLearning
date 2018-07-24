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
    
    let service = "myService"
    let account = "myAccount"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            let password = try KeychainService(service: KeychainConfiguration.serviceName, account: "justin", accessGroup: KeychainConfiguration.accessGroup).readPassword()
            print("password:\(password)")
        } catch {
            print(error)
        }
        
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainService(service: KeychainConfiguration.serviceName,
                                                    account: "justin",
                                                    accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword("123456")
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        do {
            let password = try KeychainService(service: KeychainConfiguration.serviceName, account: "justin", accessGroup: KeychainConfiguration.accessGroup).readPassword()
            print("password:\(password)")
        } catch {
            print(error)
        }
        
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainService(service: KeychainConfiguration.serviceName,
                                               account: "justin",
                                               accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.savePassword("7533967")
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        do {
            let password = try KeychainService(service: KeychainConfiguration.serviceName, account: "justin", accessGroup: KeychainConfiguration.accessGroup).readPassword()
            print("password:\(password)")
        } catch {
            print(error)
        }
        
        do {
            // This is a new account, create a new keychain item with the account name.
            let passwordItem = KeychainService(service: KeychainConfiguration.serviceName,
                                               account: "justin",
                                               accessGroup: KeychainConfiguration.accessGroup)
            
            // Save the password for the new item.
            try passwordItem.deleteItem()
        } catch {
            fatalError("Error updating keychain - \(error)")
        }
        
        do {
            let password = try KeychainService(service: KeychainConfiguration.serviceName, account: "justin", accessGroup: KeychainConfiguration.accessGroup).readPassword()
            print("password:\(password)")
        } catch {
            print(error)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

