//
//  ContactsViewController.swift
//  Cast
//
//  Created by khong fong tze on 10/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ContactsViewController: UITableViewController, ContactsCellDelegate {
    
    var contactList = [User]()
    var sender : User!
    var receiver : User!
    var selectedReceiver : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUser()
    }
    
    func loadUser() {
        
        DataService.userRef.observe(.childAdded, with: { (snapshot) in
            if let user1 = User.init(snapshot: snapshot){
                if user1.userUID != Session.currentUserUid {
                    self.contactList.append(user1)
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contactList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath) as? ContactsCell
        
        let user = self.contactList[indexPath.row]
        cell?.nameLabel.text = user.username
        cell?.roleLabel.text = "\(user.role!) (\(user.location!))"
        let imageUrl = NSURL(string:user.profilePhotoURL!)
        cell?.profileImage.sd_setImage(with: imageUrl as URL!)
        cell?.tag = indexPath.row
        cell?.delegate = self 
        
        return cell!
    }
    
    func goToChat (row:Int) {
        selectedReceiver = self.contactList[row]
        performSegue(withIdentifier: "chatSegue", sender: self)
        
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "profileSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        
        if segue.identifier == "profileSegue" {
            super.prepare(for: segue, sender: sender)
            let destination = segue.destination as! UserProfile
            if let selectedIndex = self.tableView.indexPathForSelectedRow{
                let user = contactList[selectedIndex.row]
                destination.userUID = user.userUID
            }
        }
        
        if segue.identifier=="chatSegue" {
            let chatVc = segue.destination as! ChatViewController // 1
                chatVc.senderId = Session.currentUserUid // 3
                chatVc.senderDisplayName = Session.currentUserUid // 4
                chatVc.receiver = selectedReceiver
        }
    }
    
}
