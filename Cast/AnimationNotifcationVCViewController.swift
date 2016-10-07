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
    var draggableViewBackground: MyDraggableViewBackground!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Notifications"
        loadNotification()
        
        
        self.draggableViewBackground = MyDraggableViewBackground(frame:self.view.frame)
        self.view.addSubview(self.draggableViewBackground)
        
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
                            
                            //let newNotification = self.mynotifications.filter({$0.status == "new"})
                            //self.mynotifications = newNotification
                            //if notify.status == "new"{
                                self.draggableViewBackground.addToExampleCardLabels(notify: notify)
                            //}
                        }
                        
                        }, withCancel: { (Error) in
                            
                    })
                    
                }
            })
        })
        
    }
    
    
    
}
