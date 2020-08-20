//
//  ViewController.swift
//  FirebaseCarthageTest
//
//  Created by jlai on 2020/8/19.
//  Copyright © 2020 jlai. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Initialize google sign-in
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.presentingViewController = self
    }

    @IBAction func tapGoogleSignIn(_ sender: Any) {
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            GIDSignIn.sharedInstance()?.signOut()
        }

        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        fatalError()
    }
    
    @IBAction func customizeCrashReport(_ sender: Any) {
        print("customizeCrashReport")
        let userInfo = [
          NSLocalizedDescriptionKey: NSLocalizedString("The request failed.", comment: ""),
          NSLocalizedFailureReasonErrorKey: NSLocalizedString("The response returned a 404.", comment: ""),
          NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString("Does this page exist?", comment: ""),
          "ProductID": "123456",
          "View": "MainView"
        ]

        let error = NSError.init(domain: NSCocoaErrorDomain,
                                 code: -1001,
                                 userInfo: userInfo)
        Crashlytics.crashlytics().record(error: error)
    }
}

extension ViewController: GIDSignInDelegate {
    // Present a view that prompts the user to sign in with Google
    func sign(_ signIn: GIDSignIn!,
              present viewController: UIViewController!) {
        self.present(viewController, animated: true, completion: nil)
    }
    
    // Dismiss the "Sign in with Google" view
    func sign(_ signIn: GIDSignIn!, dismiss viewController: UIViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
//            Crashlytics.sharedInstance().recordError(error)
            print("google login error\(error.localizedDescription)")
        } else if let googleToken = user.authentication.idToken {
            let firstName = user.profile.givenName ?? ""
            let lastName = user.profile.familyName ?? ""
            
            print("google token:\(googleToken)")
            print("firstName:\(firstName)")
            print("lastName:\(lastName)")
        }
    }
}


