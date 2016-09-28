//
//  UserComment.swift
//  instalkgram
//
//  Created by khong fong tze on 15/09/2016.
//  Copyright © 2016 EndeJeje. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserComment {
    
    var user : User
    var createdAt : Double
    var text : String
    var commentID : String
    var castID : String
    
    init() {
        user = User()
        createdAt = 0
        text = ""
        commentID = ""
        castID = ""
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        user = User()
        commentID = snapshot.key
        

        if let dictText = dict["text"] as? String {
            self.text = dictText
        } else {
            self.text = ""
        }
        
        if let dictCreatedAt = dict["created_at"] as? Double {
            self.createdAt = dictCreatedAt
        } else {
            self.createdAt = 0.0
        }
        
        if let dictCastID = dict["castID"] as? String {
            self.castID = dictCastID
        }
        else {
            self.castID = ""
        }
        
        if let dictUserUID = dict["userUID"] as? String {
            self.user.userUID = dictUserUID
        }
        else {
            self.user.userUID = ""
        }
        
       retrieveUser()
        
    }
    
    func retrieveUser() {
    
        DataService.userRef.child(self.user.userUID).observeSingleEvent(of: .value, with: {(snapshot) in
            if let aUser = User.init(snapshot: snapshot){
                self.user = aUser
                //print("photurl \(self.user.photoURL)")
            }
        })
        
    }
    
    func displayDateTime() -> String {
        
        let currentDate = Date()
        
        let dateFormatter = DateFormatter()
        let tweetDate = Date(timeIntervalSince1970: createdAt)
        let x = Calendar(identifier: Calendar.Identifier.gregorian)
        
        let duration = currentDate.timeIntervalSince1970 - tweetDate.timeIntervalSince1970
        print("diff \(duration/60)..\(currentDate.timeIntervalSince1970)..\(tweetDate.timeIntervalSince1970)")
        
//        let today = x!.isDateInToday(tweetDate)
//        
//        if today {
//            dateFormatter.dateFormat = "HH:MM"
//        } else {
//            dateFormatter.dateFormat = "MMM dd, yyyy HH:MM"
//        }
        
//        return dateFormatter.stringFromDate(tweetDate)
        
        //var d : Int
        let d = Int(round(duration/60))
        
        
        if d < 2 {
            return "\(d) minute ago"
        } else {
            if (d>=2) && (d<60) {
                return "\(d) minutes ago"
            } else {
                if (d>=60) && (d<120) {
                    return "\(d/60) hour ago"
                } else {
                    if (d<1440) {
                        return "\(d/60) hours ago"
                    } else {
                        if (d >= 1440) && (d<2880) {
                            return "\(d/(60*24)) day ago"
                        } else {
                            return "\(d/(60*24)) days ago"
                        }
                    }
                }
            }
        }
    }
 
}
