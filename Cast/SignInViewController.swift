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
    @IBOutlet weak var facebookOutlet: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var facebookLogin : FBSDKLoginManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.facebookOutlet.isHidden = true
        
        self.facebookLogin = FBSDKLoginManager()
//        var profileImageLink : NSURL? = ""
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard)))
        
        self.facebookLogin = FBSDKLoginManager()
        
        
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
        super.viewDidAppear(animated)
        

        
    }
    
    @IBAction func SignUpButton(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "SignUpSegue", sender: self)
        
    }
    @IBAction func facebookButton(_ sender: AnyObject) {
        
        //read from email address
        //viewcontroller requesting it
        self.facebookLogin!.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
            if error != nil {
                print ("Unable to authenticate with Facebook)")
            }else if result?.isCancelled == true {
                print("User cancelled Facebook authentication")
            } else {
                print("successfully authenticated with Facebook")
                //use token string to authenticate with Firebase
                let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
            
//                let fbGraphRequest = FBSDKGraphRequest(graphPath: "/me/picture", parameters: ["type" : "large"])
//                fbGraphRequest?.start(completionHandler: { (connection, result, error) in
                    // get the json object here
//                    let profileImagePath = result["data"]["url"] as String
//                    fetchUserImage(path: profileImagePath!)
//                })
                //calling the firebaseAuthApps
                self.firebaseAuthByApps(credential)
                print("successfully authenticated")
                Session.storeUserSession()
                self.performSegue(withIdentifier: "overviewSegue", sender: self)
            }
        }
        
    }
    
    func fetchUserImage(path: String){
    
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
                    Session.storeUserSession()
                    self.performSegue(withIdentifier: "overviewSegue", sender: self)

//                    if let uid = user?.uid{
//                        print("user authenticated with Firebase")
//                        
//                    }
                }
            })
        }
        
    }
    
    @IBAction func forgotPassButton(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "forgotPassSegue", sender: self)
        
    }
}



