//
//  Cast.swift
//  CastPlayground
//
//  Created by khong fong tze on 26/09/2016.
//  Copyright © 2016 NextAcademy. All rights reserved.
//

import Foundation

class Cast {
    
    var castID : String = ""
    var createdAt : Double = 0//created in the system
    var castName : String = ""
    var eventDate : Double = 0
    var location : String = ""
    var rewardAmount : RewardType = .monetary
    var description : String = ""
    var status : Status = .new
    var category : Category = .other
    
    var collaborators = [Collaborator]()

    init() {
        
    }
    
    enum RewardType {
        case monetary
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
        case cat_family
        case cat_fashion
        case other
    }
    
//    invite()
//    notify()
//    acceptRequest()
    
    
}
