//
//  EditDetailViewController.swift
//  Cast
//
//  Created by Raphael Lim on 7/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage


class EditDetailViewController: UIViewController, UITextFieldDelegate {
    
    var userUID : String = ""
    var category: String = ""
    
    var username = "username"
    var bio = "bio"
    var userTitle = "title"
    var userDescription = "description"
    var userGender = "gender"
    var portfolio = "portfolio"
    var location = "location"
    
    var text = ""
    var selection = ""
    var userDictionary = [String:String]()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var editTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var saveButton2Outlet: UIButton!
    @IBOutlet weak var saveButton1Outlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch category {
        case username, userTitle, userGender, portfolio, location:
            descriptionTextField.isHidden = true
            saveButton2Outlet.isHidden = true
        default:
            saveButton1Outlet.isHidden = true
            editTextField.isHidden = true
        }
        
        loadUserDetails()
        
        //        if category == username || category == bio || category == userTitle || category == userGender {
        //        descriptionTextField.isHidden = true
        //        saveButton2Outlet.isHidden = true
        //        } else {
        //        saveButton1Outlet.isHidden = true
        //        editTextField.isHidden = true
        //        }
        
    }
    
    func loadUserDetails (){
        DataService.userRef.child(Session.currentUserUid).observe(.value, with: { (snapshot) in
            let userDictionary: [String:String]? = snapshot.value as? [String:String]
            
            switch self.category {
            case self.username:
                if let usernameText = userDictionary?["username"]{
                    self.editTextField.text = usernameText
                }
            case self.bio:
                if let bioText = userDictionary?["ProfileDescription"]{
                    self.descriptionTextField.text = bioText
                }
            case self.userTitle:
                if let titleText = userDictionary?["Role"]{
                    self.editTextField.text = titleText
                }
            case self.portfolio:
                if let portfolio = userDictionary?["PortfolioLink"]{
                    self.editTextField.text = portfolio
                }
            case self.userGender:
                if let gender = userDictionary?["Gender"]{
                    self.editTextField.text = gender
                }
            case self.location:
                if let location = userDictionary?["Location"]{
                    self.editTextField.text = location
                }
            default:
                print("hello")
            }
            }
        )
    }
    
    @IBAction func saveButton(_ sender: AnyObject) {
        
        switch self.category {
        case self.username:
            text = self.editTextField.text!
            selection = "username"
            userDictionary[selection] = text
            //                 userDictionary = [selection:text]
            saveUserData()
        case self.userTitle:
            text = self.editTextField.text!
            selection = "Role"
            userDictionary[selection] = text
            saveUserData()
        case self.userGender:
            text = self.editTextField.text!
            selection = "Gender"
            userDictionary[selection] = text
            saveUserData()
        case self.portfolio:
            text = self.editTextField.text!
            selection = "PortfolioLink"
            userDictionary[selection] = text
            saveUserData()
        case self.location:
            text = self.editTextField.text!
            selection = "Location"
            userDictionary[selection] = text
            saveUserData()
            
        default:
            print("hello")
        }
    }
    
    
    
    @IBAction func saveButton2(_ sender: AnyObject) {
        
        switch self.category {
        case self.bio:
            text = self.descriptionTextField.text!
            selection = "ProfileDescription"
            userDictionary[selection] = text
            saveUserData()
       
            
        default:
            print("hello")
        }
    }
    
    func saveUserData () {
        
        DataService.userRef.child(Session.currentUserUid).updateChildValues(self.userDictionary)
        Session.storeUserSession()
        
        dismiss(animated: true, completion: nil)
    }
}
