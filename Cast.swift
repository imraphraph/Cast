//
//  Cast.swift
//  CastPlayground
//
//  Created by khong fong tze on 26/09/2016.
//  Copyright © 2016 NextAcademy. All rights reserved.
//

import Foundation
import FirebaseDatabase


class Cast {
    
    var castID : String = ""
    var createdAt : Double = 0//created in the system
    var castName : String = ""
    var eventDate : Double = 0
    var location : String = ""
    var rewardAmount : Double = 0.0
    var rewardType : RewardType = .cash
    var description : String = ""
    var status : Status = .new
    //var category : Category = .other
    var category : String = ""
    var femaleNeeded : String = "false"
    var maleNeeded : String = "false"
    var photogNeeded : String = "false"
    var userUID : String = ""
    var collaborators = [Collaborator]()
    var refImage : String!
    
    init() {
        
    }
    
    enum RewardType {
        case cash
        case tradeforprint
    }
    
    enum Status {
        case new
        case ongoing
        case cancelled
        case completed
    }
    
    enum Category {
        case cat_cosplay
        case cat_wedding
        case cat_stock
        case cat_fashion
        case other
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        castID = snapshot.key
        
        if let dictUserUID = dict["userUID"] as? String {
            self.userUID = dictUserUID
        } else {
            self.userUID = ""
        }
        
        if let dictCastName = dict["castname"] as? String {
            self.castName = dictCastName
        } else {
            self.castName = ""
        }
        
        if let dictlocation = dict["location"] as? String {
            self.location = dictlocation
        } else {
            self.location = ""
        }
        
        if let dictDescription = dict["description"] as? String {
            self.description = dictDescription
        } else {
            self.description = ""
        }
        
        if let dictCategory = dict["category"] as? String {
            self.category = dictCategory
        } else {
            self.category = ""
        }
//        switch dictCategory {
//        case "Cosplay":
//            self.category = Category.cat_cosplay
//        case "Wedding":
//            self.category = Category.cat_wedding
//        case "Stock":
//            self.category = Category.cat_stock
//        case "Fashion":
//            self.category = Category.cat_fashion
//        default:
//            self.category = Category.other
        
        
        let dictStatus = dict["status"] as! String
        switch dictStatus {
        case "new":
            self.status = Status.new
        case "ongoing":
            self.status = Status.ongoing
        case "cancelled":
            self.status = Status.cancelled
        case "completed":
            self.status = Status.completed
        default:
            self.status = Status.new
        }
        
        if let dictEventDate = dict["event_date"] as? Double {
            self.eventDate = dictEventDate
        } else {
            self.eventDate = 0.0
        }
        
        let dictRewardType = dict["reward_type"] as! String
        //print("cash.swift \(dictRewardType)")
        switch dictRewardType {
        case "Cash":
            self.rewardType = RewardType.cash
        case "TradeForPrint":
            self.rewardType = RewardType.tradeforprint
        default:
            self.rewardType = RewardType.cash
        }
        
        if let dictFemaleNeeded = dict["female_needed"] as? String {
            self.femaleNeeded = dictFemaleNeeded
        }
        else {
            self.femaleNeeded = "false"
        }
        
        if let dictMaleNeeded = dict["male_needed"] as? String {
            self.maleNeeded = dictMaleNeeded
        }
        else {
            self.maleNeeded = "false"
        }
        
        if let dictPhtogNeeded = dict["photog_needed"] as? String {
            self.photogNeeded = dictPhtogNeeded
        }
        else {
            self.photogNeeded = "false"
        }
        if let dictRefImage = dict["ref_imageURL"] as? String {
            self.refImage = dictRefImage
        } else {
            self.refImage = ""
        }
    }
//    invite()
//    notify()
//    acceptRequest()
    
    
}
