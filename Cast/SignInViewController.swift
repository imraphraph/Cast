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

class SignInViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard)))

    }
    
    
    func dismissKeyboard() {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        
        }

    @IBAction func SignUpButton(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "SignUpSegue", sender: self)
        
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
    
    @IBAction func signInButton(_ sender: AnyObject) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
            FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                if error == nil {
                 print("user authenticated with Firebase")
                }
            })
        }
        
    }
    
    @IBAction func forgotPassButton(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "forgotPassSegue", sender: self)
        
    }
    }

 

