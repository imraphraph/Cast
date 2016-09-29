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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        descriptionTextField.delegate = self
        portfolioTextField.delegate = self
        roleTextField.delegate = self
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SignInViewController.dismissKeyboard)))
        
        var desription = descriptionTextField.text
        var portfolio = portfolioTextField.text
        var role = roleTextField.text
        
    }


    func dismissKeyboard() {

        descriptionTextField.resignFirstResponder()
        portfolioTextField.resignFirstResponder()
        roleTextField.resignFirstResponder()
        
        
    }

        


    

    @IBAction func genderSegment(_ sender: AnyObject) {
    }
  
    @IBAction func nextButton(_ sender: AnyObject) {
    }

}
