//
//  AuthViewController.swift
//  BiometricIDAuthTest
//
//  Created by justin on 2019/4/2.
//  Copyright © 2019 h2. All rights reserved.
//

import UIKit

class AuthViewController: UIViewController {
    @IBOutlet weak var authButton: UIButton!
    let biometricIDAuth = BiometricIDAuth()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var authString = ""
        
        switch biometricIDAuth.biometricType() {
        case .faceID:
            authString = "點擊按鈕後使用臉部辨識解鎖"
        case .touchID:
            authString = "點擊按鈕後使用指紋解鎖"
        default:
            authString = "無法找到指紋或臉部辨識解鎖"
        }
        
        authButton.setTitle(authString, for: .normal)
    }
    
    @IBAction func touchIDAction() {
        biometricIDAuth.authenticateUser() { [weak self] message in
            if let message = message {
                // if the completion is not nil show an alert
                let alertView = UIAlertController(title: "Error",
                                                  message: message,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default)
                alertView.addAction(okAction)
                self?.present(alertView, animated: true)
            } else {
                // if the completion is not nil show an alert
                let alertView = UIAlertController(title: "Identify Success!!!",
                                                  message: nil,
                                                  preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: { (action: UIAlertAction!) -> Void in
                    self?.dismiss(animated: true, completion: nil)
                })
                
                alertView.addAction(okAction)
                self?.present(alertView, animated: true)
            }
        }
    }
    
    @IBAction func close() {
        self.dismiss(animated: true, completion: nil)
    }

}
