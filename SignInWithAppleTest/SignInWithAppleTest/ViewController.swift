//
//  ViewController.swift
//  SignInWithAppleTest
//
//  Created by justin on 2020/02/24.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit
import AuthenticationServices

class ViewController: UIViewController {

    @IBOutlet weak var customAppleLoginButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var givenNameLabel: UILabel!
    @IBOutlet weak var familyNameLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var identityTokenLabel: UILabel!
    let signInWithAppleButton = ASAuthorizationAppleIDButton()
    fileprivate let kUserInfoKey = "userInfo"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        signInWithAppleButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInWithAppleButton)
        
        NSLayoutConstraint.activate([
            signInWithAppleButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50.0),
            signInWithAppleButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50.0),
            signInWithAppleButton.bottomAnchor.constraint(equalTo: customAppleLoginButton.safeAreaLayoutGuide.topAnchor, constant: -50.0),
            signInWithAppleButton.heightAnchor.constraint(equalToConstant: 44.0)
        ])
        
        signInWithAppleButton.addTarget(self, action: #selector(tapSingInWithApple), for: .touchUpInside)
        
        if let userInfo = UserDefaults.standard.dictionary(forKey: kUserInfoKey) as? [String: String], let userID = userInfo["userID"] {
            // get the login status of Apple sign in for the app
            // asynchronous
            ASAuthorizationAppleIDProvider().getCredentialState(forUserID: userID, completion: {
                credentialState, error in

                switch(credentialState){
                case .authorized:
                    print("user remain logged in, proceed to another view")
                case .revoked:
                    print("user logged in before but revoked")
                case .notFound:
                    print("user haven't log in before")
                default:
                    print("unknown state")
                }
            })
            
            checkViewStatus(userInfo)
        } else {
            checkViewStatus(nil)
        }
        
    }
    
    fileprivate func checkViewStatus(_ dict: [String: String]?) {
        var isLogin = false
        if let _ = dict {
            isLogin = true
        }
        print("isLogin:\(isLogin)")
        
        userIDLabel.isHidden = !isLogin
        userIDLabel.text = "userID: " + (dict?["userID"] ?? "")
        userIDLabel.textColor = .black
        
        emailLabel.isHidden = !isLogin
        emailLabel.text = "email: " + (dict?["email"] ?? "")
        
        givenNameLabel.isHidden = !isLogin
        givenNameLabel.text = "givenName: " + (dict?["givenName"] ?? "")
        
        familyNameLabel.isHidden = !isLogin
        familyNameLabel.text = "familyName: " + (dict?["familyName"] ?? "")
        
        nickNameLabel.isHidden = !isLogin
        nickNameLabel.text = "nickName: " + (dict?["nickName"] ?? "")
        
        identityTokenLabel.isHidden = !isLogin
        identityTokenLabel.text = "identityToken: \n" + (dict?["identityToken"] ?? "")
        
        logoutButton.isHidden = !isLogin
        
        customAppleLoginButton.isHidden = isLogin
        signInWithAppleButton.isHidden = isLogin
    }

    @objc fileprivate func tapSingInWithApple() {
        let provider = ASAuthorizationAppleIDProvider()
        let request = provider.createRequest()
        request.requestedScopes = [.fullName, .email]
        let authController = ASAuthorizationController(authorizationRequests: [request])
        authController.presentationContextProvider = self
        authController.delegate = self
        authController.performRequests()
        
    }

    @IBAction func tapSignInWithAppleWithCustomButton(_ sender: Any) {
        tapSingInWithApple()
    }
    
    @IBAction func tapLogout(_ sender: Any) {
        UserDefaults.standard.set(nil, forKey: kUserInfoKey)
        checkViewStatus(nil)
    }
    
}

/// (ASAuthorizationControllerPresentationContextProviding) asks for which window should the authorization dialog appear, this is in case for app that has multiple window on iPadOS.

extension ViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let window = self.view.window else {
            fatalError("Cant find window")
        }
        
        return window
    }
    
}

/// (ASAuthorizationControllerDelegate), which includes two methods that will be called when the sign in is successful (with user data) or failed (with error).

extension ViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("authorization error")
        guard let error = error as? ASAuthorizationError else {
            return
        }

        switch error.code {
        case .canceled:
            // user press "cancel" during the login prompt
            print("Canceled")
        case .unknown:
            // user didn't login their Apple ID on the device
            print("Unknown")
        case .invalidResponse:
            // invalid response received from the login
            print("Invalid Response")
        case .notHandled:
            // authorization request not handled, maybe internet failure during login
            print("Not handled")
        case .failed:
            // authorization failed
            print("Failed")
        @unknown default:
            print("Default")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            // unique ID for each user, this uniqueID will always be returned
            let userID = appleIDCredential.user
            // optional, might be nil
            let email = appleIDCredential.email ?? "can't find email"
            // optional, might be nil
            let givenName = appleIDCredential.fullName?.givenName ?? "can't find given name"
            // optional, might be nil
            let familyName = appleIDCredential.fullName?.familyName ?? "can't find family name"
            // optional, might be nil
            let nickName = appleIDCredential.fullName?.nickname ?? "can't find nick name"
            
            /*
                useful for server side, the app can send identityToken and authorizationCode
                to the server for verification purpose
            */
            var identityToken : String
            if let token = appleIDCredential.identityToken {
                identityToken = String(bytes: token, encoding: .utf8) ?? "ending identity token fail"
            } else {
                identityToken = "can't find identity token"
            }
            
            var authorizationCode : String
            if let code = appleIDCredential.authorizationCode {
                authorizationCode = String(bytes: code, encoding: .utf8) ?? "ending authorization code fail"
            } else {
                authorizationCode = "can't find authorization code"
            }
            
            // do what you want with the data here
            
            let userInfo: [String: String] = ["userID": userID, "email": email, "givenName": givenName,
                        "familyName": familyName, "nickName": nickName, "identityToken": identityToken,
                        "authorizationCode": authorizationCode]
            
            // save it to user defaults
            UserDefaults.standard.set(userInfo, forKey: kUserInfoKey)
            checkViewStatus(userInfo)
        }
    }
}
