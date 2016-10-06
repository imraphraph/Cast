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
    
    @IBOutlet weak var locationTextField: UITextField!
    
    var gender : String = "male"
    var fireBaseRef = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextField.delegate = self
        portfolioTextField.delegate = self
        roleTextField.delegate = self
        locationTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard)))
        

        
    }


    func dismissKeyboard() {

        descriptionTextField.resignFirstResponder()
        portfolioTextField.resignFirstResponder()
        roleTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        
    }


    @IBAction func genderSegment(_ sender: AnyObject) {
        
        if genderSegment.selectedSegmentIndex == 0 {
            self.gender = "male"
        }
        if genderSegment.selectedSegmentIndex == 1{
            self.gender = "female"
        }
    }
  
    @IBAction func nextButton(_ sender: AnyObject) {
        
        if let description = descriptionTextField.text, let portfolio = portfolioTextField.text, let location = locationTextField.text, let role = roleTextField.text {
            let userDictionary = ["Gender": self.gender, "ProfileDescription": description, "PortfolioLink" : portfolio, "Location": location, "Role" : role]
            self.fireBaseRef.child("users").child(Session.currentUserUid).updateChildValues(userDictionary)
            Session.storeUserSession()
        
        }
        performSegue(withIdentifier: "toOverviewSegue", sender: self)
    }

}
