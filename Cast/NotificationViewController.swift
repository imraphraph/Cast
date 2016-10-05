//
//  NotificationViewController.swift
//  Cast
//
//  Created by khong fong tze on 30/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import FirebaseDatabase


class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var mynotifications = [CastNotification]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource=self
        self.tableView.delegate=self
        
        
    }
    
    func loadNotification() {
        
        /*
         DataService.userRef.child(User.currentUserUid).child("following").observeEventType(.ChildAdded, withBlock: {(snapshot) in
         //print("snapshotkey \(snapshot.key)")
         
         DataService.userRef.child(snapshot.key).observeSingleEventOfType(.Value, withBlock: {(snap1) in
         
         //print("snap1key \(snap1.key)")
         
         if let username = InstallkgramUser.init(snapshot: snap1){
         self.usernameForFeed.append(username)
         self.retrieveFeed(username)
         }
         
         })
         })
         */
        
        DataService.userRef.child(Session.currentUserUid).child("being_notified").observe(.childAdded, with: { (snapshot) in
        
            DataService.rootRef.child("notification").child(snapshot.key).observe(.value, with: {(snap2) in
        
                    if let notify = CastNotification.init(snapshot: snap2){
                        self.mynotifications.append(notify)  //& message
                        
                        //retrieve the sender's info - photo & username
                        DataService.userRef.child(notify.senderUID).observeSingleEvent(of: .childAdded, with: { (snap3) in
                            if let sender = User.init(snapshot: snap3) {
                               notify.sender = sender
                            }
                        }, withCancel: { (Error) in
                            
                        })
                    }
                })
            })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifyCell") as? NotificationViewCell
        
        let notify = self.mynotifications[indexPath.row]
        cell?.profilePhoto.image = UIImage(named: "cowgirl")
        //cell?.profilePhoto.image.
        cell?.profilePhoto.clipsToBounds = true
        cell?.profilePhoto.layer.cornerRadius = 10.0
        cell?.tag = indexPath.row
        
        cell?.usernameTxt.text = notify.sender.username
        cell?.messageTxt.text = notify.message
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    
    
}
