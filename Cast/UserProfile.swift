//
//  UserProfile.swift
//  Cast
//
//  Created by Raphael Lim on 11/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class UserProfile: UIViewController {

    @IBOutlet weak var descriptionTextField: UILabel!
    @IBOutlet weak var genderTextField: UILabel!
    @IBOutlet weak var locationTextField: UILabel!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var usernameTextField: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    
    var userUID : String = ""
    var portfolioLink : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadUserInfo()
        retrieveProfileImage()
    }

    func loadUserInfo () {
    
        DataService.userRef.child(userUID).observe(.value, with: { (snapshot) in
            let userDictionary: [String: AnyObject]? = snapshot.value as? [String: AnyObject]
            if let username = userDictionary?["username"] as? String{
                self.usernameTextField.text = username
            }
            if let title = userDictionary?["Role"] as? String{
                self.titleTextField.text = title
            }
            if let gender = userDictionary?["Gender"] as? String{
                self.genderTextField.text = gender
            }
            if let description = userDictionary?["ProfileDescription"] as? String{
                self.descriptionTextField.text = description
            }
            if let portfolio = userDictionary?["PortfolioLink"] as? String{
                self.portfolioLink = portfolio
            }
            if let location = userDictionary?["Location"] as? String {
                self.locationTextField.text = location
            }
        })
        
    }
    
    func retrieveProfileImage (){
        
        DataService.userRef.child(userUID).child("profilePicture").observe(.value, with: {(snapshot) in
            
            if let profileImageLink = snapshot.value as? String {
                let profileImageUrl = NSURL(string: profileImageLink)
                URLSession.shared.dataTask(with: profileImageUrl as! URL, completionHandler: {
                    (data, response, error) in
                    
                    if error != nil{
                        print(error)
                        return
                    }
                    
                    let image = UIImage(data: data!)
                    DispatchQueue.main.async(execute: {
                        self.profileImage.image = image
                    })
                    
                }).resume()
            }
        })
    }

    
    @IBAction func portfolioButton(_ sender: AnyObject) {
        
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
