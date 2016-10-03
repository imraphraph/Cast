//
//  ProfileViewController.swift
//  Cast
//
//  Created by Raphael Lim on 30/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FBSDKCoreKit

class ProfileViewController: UIViewController {
    @IBOutlet weak var genderTextField: UILabel!
    @IBOutlet weak var usernameTextField: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!

    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var descriptionTextField: UILabel!
    @IBOutlet weak var portfolio: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        self.profileImageView.layer.borderWidth = 1
        self.profileImageView.layer.masksToBounds = false
        self.profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        self.profileImageView.clipsToBounds = true
        
        retrieveUserData()
        retrieveProfileImage()
        
        

    }
    
    func retrieveUserData () {
        DataService.userRef.child(Session.currentUserUid).observe(.value, with: { (snapshot) in
            let userDictionary: [String:String]? = snapshot.value as? [String:String]
            if let username = userDictionary?["username"]{
                self.usernameTextField.text = username
            }
            if let title = userDictionary?["Role"]{
            self.titleTextField.text = title
            }
            if let gender = userDictionary?["Gender"]{
            self.genderTextField.text = gender
            }
            if let description = userDictionary?["ProfileDescription"]{
            self.descriptionTextField.text = description
            }
            if let portfolio = userDictionary?["PortfolioLink"]{
            self.portfolio.text = portfolio
            }
            
        })
    }
    

    func retrieveProfileImage (){
        
        DataService.userRef.child(Session.currentUserUid).child("profilePicture").observe(.value, with: {(snapshot) in
           
            let profileImageLink = snapshot.value as? String
//            let randomURL = NSURL(string: <#T##String#>)
            let profileImageUrl = NSURL(string: profileImageLink!)
                URLSession.shared.dataTask(with: profileImageUrl as! URL, completionHandler: {
                    (data, response, error) in
                    
                    if error != nil{
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async(execute: {
                        self.profileImageView.image = image
                    })
                    
                }).resume()
            })
    }
    
    
    
    
    
    }



