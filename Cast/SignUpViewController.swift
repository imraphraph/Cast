//
//  SignUpViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SignUpViewController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    var fireBaseRef = FIRDatabase.database().reference()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignUpViewController.dismissKeyboard)))
    }

    
    func dismissKeyboard() {
        passwordTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }

    @IBAction func registerButton(_ sender: AnyObject) {
        
        if let email = emailTextField.text, let password = passwordTextField.text {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                let controller = UIAlertController(title: "Registration Failed", message: "Please check if you are connected to the internet", preferredStyle: .alert)
                let dismissButton = UIAlertAction(title: "Try Again", style: .default, handler: nil)
                controller.addAction(dismissButton)
                
                self.present(controller, animated: true, completion: nil)
            }else {
                if let person = user {
                let userDictionary = ["email": email]
                    self.fireBaseRef.child("users").child(person.uid).setValue(userDictionary)
                    Session.storeUserSession()
                }
                
            print ("user successfully authenticated with Firebase")
                self.performSegue(withIdentifier: "welcomeSegue", sender: self)
            }
        })
        }
        
    }

    @IBAction func haveAnAccountButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: {});
    }
}




