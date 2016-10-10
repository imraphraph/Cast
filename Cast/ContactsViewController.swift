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

class ContactsViewController: UITableViewController {

    var contactList = [User]()
    var sender : User!
        
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
        }
        )}

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
        

        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier=="chatSegue" {
        super.prepare(for: segue, sender: sender)
        let chatVc = segue.destination as! ChatViewController // 1
        //_ = navVc.viewControllers.first as! ChatViewController // 2
        if let selectedRow = self.tableView.indexPathForSelectedRow?.row {
            chatVc.senderId = sender.userUID // 3
            chatVc.senderDisplayName = sender.username // 4
            chatVc.receiver = self.contactList[selectedRow]
            
        }
//            chatVc.senderId = self.contactList[selectedRow] // 3
//            chatVc.senderDisplayName = self.contactList[selectedRow] // 4
        }
    }
    
    

}
