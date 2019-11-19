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
            authString = "Use face recognition to unlock"
        case .touchID:
            authString = "Use the fingerprint to unlock"
        default:
            authString = "Unable to find fingerprint or face recognition to unlock"
        }
        
        authButton.setTitle(authString, for: .normal)
        authButton.btnMultipleLines()
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

//UIButton extension
extension UIButton {
     //UIButton properties
     func btnMultipleLines() {
         titleLabel?.numberOfLines = 0
         titleLabel?.lineBreakMode = .byWordWrapping
         titleLabel?.textAlignment = .center
     }
}
