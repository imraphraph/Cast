//
//  WelcomeViewController2.swift
//  Cast
//
//  Created by Raphael Lim on 29/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class WelcomeViewController2: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var genderSegment: UISegmentedControl!

    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var portfolioTextField: UITextField!
    @IBOutlet weak var roleTextField: UITextField!
    
    var fireBaseRef = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextField.delegate = self
        portfolioTextField.delegate = self
        roleTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard)))
        

        
    }


    func dismissKeyboard() {

        descriptionTextField.resignFirstResponder()
        portfolioTextField.resignFirstResponder()
        roleTextField.resignFirstResponder()
        
        
    }


    @IBAction func genderSegment(_ sender: AnyObject) {
        
    }
  
    @IBAction func nextButton(_ sender: AnyObject) {
        
        if let description = descriptionTextField.text, let portfolio = portfolioTextField.text, let role = roleTextField.text {
            let userDictionary = ["ProfileDescription": description, "PortfolioLink" : portfolio, "Role" : role]
            self.fireBaseRef.child("users").child(Session.currentUserUid).setValue(userDictionary)
            Session.storeUserSession()
        
        }
        performSegue(withIdentifier: "toOverviewSegue", sender: self)
    }

}
