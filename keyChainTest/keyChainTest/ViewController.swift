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
    static var serviceGroup: String = {
        var serviceGroup = ""
        
        if let appIdentifierPrefix = Bundle.main.infoDictionary?["AppIdentifierPrefix"] as? String {
            serviceGroup = appIdentifierPrefix + "group.h2.keyChainTest"
        }
        
        return serviceGroup
    }()
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

    @IBAction func reloadLabel(_ sender: Any) {
        if keychainValueLabel.text?.contains("token") ?? false {
            return
        }
        
        if let value = UserDefaults.standard.object(forKey: "backgroundFetchTest") as? String {
            keychainValueLabel.text = value
        }
    }
}

