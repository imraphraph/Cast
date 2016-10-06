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
//    @IBOutlet weak var portfolio: UILabel!
    @IBOutlet weak var portfolioButton: UIButton!
    
    var portfolioLink : String  = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.profileImageView.layer.borderColor = UIColor.white.cgColor
        
        
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
            self.portfolioLink = portfolio
                
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
    @IBAction func editButton(_ sender: AnyObject) {
        
        performSegue(withIdentifier: "editProfileSegue", sender: self)
    }
    
    @IBAction func openPortfolio(_ sender: AnyObject) {
        
        if self.portfolioLink.lowercased() .hasPrefix("http://"){
        let myURL = self.portfolioLink
        UIApplication.shared.openURL(URL(string: myURL)!)
        } else if self.portfolioLink.lowercased() .hasPrefix("https://"){
        let myURL = self.portfolioLink
        UIApplication.shared.openURL(URL(string: myURL)!)
        } else {
        let myURL = "http://" + self.portfolioLink
        UIApplication.shared.openURL(URL(string: myURL)!)
        }
        
    }
}



