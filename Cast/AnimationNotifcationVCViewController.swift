//
//  AnimationNotifcationVCViewController.swift
//  Cast
//
//  Created by khong fong tze on 05/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import FirebaseDatabase

class AnimationNotifcationVCViewController: UIViewController {

    var mynotifications = [CastNotification]()
    var displayNotifications = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNotification()
        
        sleep(60)
        
        var draggableViewBackground = DraggableViewBackground(frame:self.view.frame)
        draggableViewBackground.exampleCardLabels = self.displayNotifications
        self.view.addSubview(draggableViewBackground)
        
    }

   
    func loadNotification() {
        
        DataService.userRef.child(Session.currentUserUid).child("being_notified").observe(.childAdded, with: { (snapshot) in
            
            DataService.rootRef.child("notification").child(snapshot.key).observeSingleEvent(of: .value, with: { (snap2) in
                
                if let notify = CastNotification.init(snapshot: snap2){
                    self.mynotifications.append(notify)  //& message
                    
                    //retrieve the sender's info - photo & username
                    DataService.userRef.child(notify.senderUID).observeSingleEvent(of: .value, with: { (snap3) in
                        if let sender = User.init(snapshot: snap3) {
                            notify.sender = sender
                            
                            let newNotification = self.mynotifications.filter({$0.status != "new"})
                            self.mynotifications = newNotification
                            self.displayNotifications.append("\(sender.username)  \(notify.message)")
                        }
                        
                        }, withCancel: { (Error) in
                            
                    })
                    
                }
            })
        })
        
    }
    
}
