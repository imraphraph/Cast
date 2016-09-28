//
//  SignInViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class SignInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        }

    @IBAction func facebookButton(_ sender: AnyObject) {
        
        let facebookLogin = FBSDKLoginManager()
        
        //read from email address
        //viewcontroller requesting it
        facebookLogin.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print ("Unable to authenticate with Facebook - \(error)")
            }else if result?.isCancelled == true {
                print("User cancelled Facebook authentication")
            } else {
                print("successfully authenticated with Facebook")
                //use token string to authenticate with Firebase
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
                
                //calling the firebaseAuthApps
                self.firebaseAuthByApps(credential)
            }
        }  
        
    }
    
    func firebaseAuthByApps(_ credential: FIRAuthCredential) {
    
        FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
            if error != nil {
             print("unable to authenticate with Firebase - \(error)")
            } else {
                print("successfully authenticated with Firebase")
            }
        })
    }
    }

 

