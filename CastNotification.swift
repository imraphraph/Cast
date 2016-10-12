//
//  Notification.swift
//  Cast
//
//  Created by khong fong tze on 01/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import Foundation
import FirebaseDatabase

class CastNotification {
    
    var notifyUID : String
    var senderUID : String
    var receiverUID : String
    var castID : String
    var queueID : String
    var status = "new"
    var message = ""
    var sender = User()
    var receiver = User()
    var castObj : Cast?
    
    init() {
        notifyUID=""
        senderUID=""
        receiverUID=""
        castID=""
        queueID=""
        message = ""
        sender = User()
        receiver = User()
    }
    
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        notifyUID = snapshot.key
        
        if let dictfromUser = dict["From"] as? String {
            self.senderUID = dictfromUser
        } else {
            self.senderUID = ""
        }
        
        if let dictToUser = dict["To"] as? String {
            self.receiverUID = dictToUser
        } else {
            self.receiverUID = ""
        }

        
        if let dictCastID = dict["castID"] as? String {
            self.castID = dictCastID
        } else {
            self.castID = ""
        }
        
        if let dictQID = dict["queueID"] as? String {
            self.queueID = dictQID
        } else {
            self.queueID = ""
        }
        
        if let dictStatus = dict["status"] as? String {
            self.status = dictStatus
        } else {
            self.status = "new"
        }

        if let dictMessage = dict["message"] as? String {
            self.message = dictMessage
        } else {
            self.message = ""
        }
        
        
    }
}
