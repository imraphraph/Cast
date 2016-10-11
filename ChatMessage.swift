//
//  Message.swift
//  Cast
//
//  Created by khong fong tze on 11/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatMessage {
    
    var sender : String
    var messageText: String
    var createdAt: Double
    var messageKey : String
    
    init() {
        messageKey = ""
        messageText = ""
        createdAt = 0
        sender = ""
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        messageKey = snapshot.key
        
        if let dictMsg = dict["text"] as? String {
            self.messageText = dictMsg
        } else {
            self.messageText = ""
        }
        
        if let createdAt = dict["created_at"] as? Double {
            self.createdAt = createdAt
        } else {
            self.createdAt = 0.0
        }
        
        if let dictSender = dict["sender"] as? String {
            self.sender = dictSender
        } else {
            self.sender = ""
        }
        
    }
        
}
