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
    var rewardAmount : Double = 0
    var description : String = ""
    var status : Status = .new
    
    var collaborators = [Collaborator]()

    init() {
        
    }
    
    
    enum Status {
        case new
        case cancelled
        case completed
    }
    
//    invite()
//    notify()
//    acceptRequest()
    
    
}
