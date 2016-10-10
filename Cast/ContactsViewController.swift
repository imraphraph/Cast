//
//  ContactsViewController.swift
//  Cast
//
//  Created by khong fong tze on 10/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class ContactsViewController: UITableViewController {

    var contactList = [User]()
    var sender : User!
        
    override func viewDidLoad() {
        super.viewDidLoad()

         }

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.contactList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)

        cell.textLabel?.text = self.contactList[indexPath.row]

        return cell
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
        }
    }
    
    

}
