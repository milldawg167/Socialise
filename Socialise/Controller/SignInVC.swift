//
//  SignInVC.swift
//  Socialise
//
//  Created by Andrew Miller on 18/05/2018.
//  Copyright © 2018 Andrew Miller. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase

class SignInVC: UIViewController {

    @IBOutlet weak var emailField: FancyField!
    @IBOutlet weak var passwordField: FancyField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func fbBtnTapped(_ sender: Any) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print("Andrew: Unable to authenticate with Facebook - \(String(describing: error))")
            } else if result?.isCancelled == true{
                print("Andrew: User cancelled Facebook authentication")
            } else {
                print("Andrew: Successfully authenticated with Facebook")
                let credential = FacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                self.firebaseAuth(credential)
            }
        }
    }
    
    func firebaseAuth(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential, completion: { (user, error) in
            if error != nil {
                print("Andrew: Unable to authenticate with Firebase - \(String(describing: error))")
            } else {
                print("Andrew: Successfully authenticated with Firebase")
            }
        })
    }
    
    @IBAction func signInTapped(_ sender: Any) {
        if let email = emailField.text, let pwd = passwordField.text {
            Auth.auth().signIn(withEmail: email, password: pwd, completion: { (user,error) in
                if error != nil {
                    print("Andrew: Email user authenticated with Firebase")
                } else {
                    Auth.auth().createUser(withEmail: email, password: pwd, completion: { (user,error) in
                        if error != nil {
                            print("Andrew: Unable to authenticate with Firebase using email")
                        } else {
                            print("Andrew: Successfully authenticated with Firebase")
                        }
                    })
                }
            })
        }
    }
    
}

