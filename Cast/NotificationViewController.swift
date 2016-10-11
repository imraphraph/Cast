//
//  NotificationViewController.swift
//  Cast
//
//  Created by khong fong tze on 30/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import FirebaseDatabase


class NotificationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet var emptyView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var mynotifications = [CastNotification]()  //being_notified
    var sentnotifications = [CastNotification]() //request to collaborate
    
    @IBOutlet weak var respondBtn: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource=self
    
        self.title = "Notifications"
        self.tableView.allowsMultipleSelection=true
        
        self.respondBtn.isEnabled=false
        
        loadNotification()
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
                            
                            let newNotification = self.mynotifications.filter({$0.status == "new"})
                            self.mynotifications = newNotification
                            self.tableView.reloadData()
                            
                            self.canResponse()
                        }
                        
                        }, withCancel: { (Error) in
                            
                    })
                    
                }
            })
        })
        
    }
    
    func canResponse() {
        if self.mynotifications.count==0{
            self.respondBtn.isEnabled=false
        } else {
            self.respondBtn.isEnabled=true
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.mynotifications.count == 0 {
            // Show Empty State View
            self.tableView.addSubview(self.emptyView)
            self.emptyView.addSubview(messageLbl)
            messageLbl.alpha=1.0
            messageLbl.isHidden=false
            self.emptyView.center = self.view.center
            self.emptyView.center.y = self.view.frame.height/2 // rough calculation here
            self.tableView.separatorColor = UIColor.clear
            //self.tableView.backgroundColor=UIColor.lightGray
        } else if self.emptyView.superview != nil {
            // Empty State View is currently visible, but shouldn't
            self.emptyView.removeFromSuperview()
            self.tableView.separatorColor = nil
            self.tableView.backgroundColor=UIColor.clear
        }
        
        return self.mynotifications.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "notifyCell") as? NotificationViewCell
        //if self.mynotifications.count > 0 {
        let notify = self.mynotifications[indexPath.row]
        
        
//        let imageURL = NSURL(string:notify)
//        print("\(imageURL) printing IMAGEREF casterView")
    
        
        cell?.profilePhoto.image = UIImage(named: "cowgirl")
        //cell?.profilePhoto.image.
        cell?.profilePhoto.clipsToBounds = true
        cell?.profilePhoto.layer.cornerRadius = 20.0
        cell?.tag = indexPath.row
        
        cell?.usernameTxt.text = notify.sender.username
        cell?.messageTxt.text = notify.message
        //}
        return cell!
        
    }
    
    
    
    @IBAction func onConfirmBtnPressed(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Accept", message: "Accept or reject  selected request(s) ?", preferredStyle: .alert)
        
        let acceptAction = UIAlertAction(title: "Accept", style: .default) { (UIAlertAction) in
            if let selectedRequests = self.tableView.indexPathsForSelectedRows {
                
                for i in 0..<selectedRequests.count {
                    
                    let IP = selectedRequests[i]
                    let notify = self.mynotifications[IP.row]
                    self.response(responseType: "ACCEPT",notify:notify)
                }
            }
        }
        
        
        let rejectAction = UIAlertAction(title: "Reject", style: .default) { (UIAlertAction) in
            if let selectedRequests = self.tableView.indexPathsForSelectedRows {
                
                for i in 0..<selectedRequests.count {
                    
                    let IP = selectedRequests[i]
                    let notify = self.mynotifications[IP.row]
                    self.response(responseType: "REJECT",notify:notify)
                }
            }
            
        }
        
        let dismissAction = UIAlertAction(title: "Dimiss", style: .default, handler: nil)
        
        alertController.addAction(rejectAction)
        alertController.addAction(acceptAction)
        alertController.addAction(dismissAction)
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    func response(responseType:String, notify:CastNotification){
        
        DataService.rootRef.child("casts").child(notify.castID).observeSingleEvent(of: .value, with: { (snap1) in
            
            //add to the photographer nodes -- to do: model node
            let collaUpdateRef = DataService.rootRef.child("casts").child(notify.castID).child("photographer")
            collaUpdateRef.updateChildValues(["UserUID":Session.currentUserUid])
            
            //update the queue with status ACCEPT
            let queueUpdateDict = ["responsed_at":NSDate().timeIntervalSince1970,"status":responseType.lowercased()] as [String : Any]
            
            let queueRef = DataService.rootRef.child("casts").child(notify.castID).child("queue").child(notify.queueID)
            queueRef.updateChildValues(queueUpdateDict)
            
            //update the notification with status RESPONSED
            let notifyUpdateDict = ["responsed_at":NSDate().timeIntervalSince1970,"status": responseType.lowercased()] as [String : Any]
            
            let notifyUpdateRef = DataService.rootRef.child("notification").child(notify.notifyUID)
            notifyUpdateRef.updateChildValues(notifyUpdateDict)
            
        })
        
        
    }
    
    
}
