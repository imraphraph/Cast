//
//  ViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase

class ForgotPassViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ForgotPassViewController.dismissKeyboard)))
        
    }
    
    func dismissKeyboard() {
        emailTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true

    }
    
    @IBAction func resetButton(_ sender: AnyObject) {
        
        if let email = emailTextField.text {
            
            FIRAuth.auth()?.sendPasswordReset(withEmail: email, completion: {(error) in
                
                var title = ""
                var message = ""
                
                if error != nil
                {
                    title = "Oops"
                    message = (error?.localizedDescription)!
                }else {
                    title = "success"
                    message = "Password reset email sent"
                    self.emailTextField.text = ""
                    
                    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let dismissButton = UIAlertAction(title: "Done", style: .default, handler: { (action) in
                        self.dismiss(animated: true, completion: {})
                    })
                    alertController.addAction(dismissButton)
                    
                    self.present(alertController, animated: true, completion: nil)
                    
                }
                
                
            })
            
        }else{
            
            let alertController = UIAlertController(title: "Password Reset Failure", message: "Please enter an email", preferredStyle: .alert)
            let alertButton = UIAlertAction(title: "Try Again", style: .cancel, handler: nil)
            
            alertController.addAction(alertButton)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
    }
    
    
    }



