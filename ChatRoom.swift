//
//  ChatRoom.swift
//  Cast
//
//  Created by khong fong tze on 10/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ChatRoom {
    
    var sender : String
    var receiver : String
    var chatRoomId : String
    var messageText: String
    
    init() {
        messageText = ""
        chatRoomId = ""
        receiver = ""
        sender = ""
    }
    
    init?(snapshot: FIRDataSnapshot){
        guard let dict = snapshot.value as? [String:AnyObject] else { return nil}
        
        
        chatRoomId = snapshot.key
        
        
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
        
        if let dictMsg = dict["messageText"] as? String {
            self.messageText = dictMsg
        } else {
            self.messageText = ""
        }
        
        
        
        
    }
    
//    func retrieveUser() {
//        
//        DataService.userRef.child(self.user.userUID).observeSingleEvent(of: .value, with: {(snapshot) in
//            if let aUser = User.init(snapshot: snapshot){
//                self.user = aUser
//                //print("photurl \(self.user.photoURL)")
//            }
//        })
//    }
    
}
