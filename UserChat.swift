//
//  ChatRoom.swift
//  Cast
//
//  Created by khong fong tze on 10/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import Foundation
import FirebaseDatabase

class UserChat {
    
    var sender : String
    var receiver : String
    var chatRoomId : String
    
    init() {
        chatRoomId = ""
        sender = ""
        receiver = ""
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        chatRoomId=""
        sender = snapshot.key
    
        if let dictReceiver = dict["receiver"] as? String {
            self.receiver = dictReceiver
        } else {
            self.receiver = ""
        }
        
        if let dictSender = dict["sender"] as? String {
            self.sender = dictSender
        } else {
            self.sender = ""
        }
        
        
        
    }
    

    
}
