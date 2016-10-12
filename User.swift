//
//  InstalkgramUser.swift
//  instalkgram
//
//  Created by khong fong tze on 12/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseDatabase



open class User{
    
    var userUID: String
    var username: String
    var createdAt: Double
    
    var lastName: String
    var firstName: String
    var gender : String
    
    var email: String
    var phone: String
    var profilePhotoURL: String?
    var weblinks: String?
    var location: String?
    var role: String?
    
//    var collaborators = [Collaborator]()
    
//    enum Gender{
//        case Female
//        case Male
//        case Undefined
//    }
    
    init() {
        username = ""
        userUID = ""
        createdAt = 0.0
        firstName = ""
        lastName = ""
        email = ""
        phone = ""
        profilePhotoURL=""
        weblinks = ""
        gender = ""
        location = ""
    }
    

    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        userUID = snapshot.key
        

        print("Init User with dictionary \(dict)")

        if let dictUsername = dict["username"] as? String {
            self.username = dictUsername
        } else {
            self.username = ""
        }
        
        if let createdAt = dict["created_at"] as? Double {
            self.createdAt = createdAt
        } else {
            self.createdAt = 0.0
        }
        
        if let email = dict["email"] as? String{
            self.email = email
        }else {
            self.email = ""
        }
        
        if let firstName = dict["firstName"] as? String{
            self.firstName = firstName
        }else {
            self.firstName = ""
        }
        
        if let lastName = dict["lastName"] as? String{
            self.lastName = lastName
        }else {
            self.lastName = ""
        }
        
        if let phone = dict["phone"] as? String{
            self.phone = phone
        }else {
            self.phone = ""
        }
        
        if let weblinks = dict["PortfolioLink"] as? String{
            self.weblinks = weblinks
        }else {
            self.weblinks = ""
        }
        
        
        if let profilePhotoURL = dict["profilePicture"] as? String {
            self.profilePhotoURL = profilePhotoURL
        } else {
            self.profilePhotoURL = ""
        }
        
        if let gender = dict["Gender"] as? String {
            self.gender = gender
        } else {
            self.gender = ""
        }
        if let location = dict["Location"] as? String {
            self.location = location
        } else {
            self.location = ""
        }
        if let role = dict["Role"] as? String {
            self.role = role
        } else {
            self.role = ""
        }
    }
    
    class func verifyIfComplete(snapshot: FIRDataSnapshot) -> Bool{
        guard let dict = snapshot.value as? [String:AnyObject] else { return false}
        
        let requiredFields = ["username", "Role"]
        for key in requiredFields {
            if dict[key] == nil{
                return false
            }
        }
        return true
    }
}
