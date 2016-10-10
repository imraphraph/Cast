//
//  CollaboratorViewController.swift
//  Cast
//
//  Created by khong fong tze on 07/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class CollaboratorViewController: UIViewController {

    var allUsers = [String:User]()
//    var availableUsers = [String:User]()
//    var displayUsers = [String]()
    var draggableViewBackground: CollaboratorViewBackground!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Collaborators"
        loadUser()
        
        self.draggableViewBackground = CollaboratorViewBackground(frame:self.view.frame)
        self.view.addSubview(self.draggableViewBackground)
        
    }
    
    
    func loadUser() {
        
        DataService.userRef.observe(.childAdded, with: { (snapshot) in
            if let user1 = User.init(snapshot: snapshot){
                self.allUsers[user1.username] = user1
                if user1.userUID != Session.currentUserUid {
                self.draggableViewBackground.addToExampleCardLabels(user: user1)
//                    DataService.userRef.child(Session.currentUserUid).child("friends").observeSingleEvent(of: .value, with: { (snap2) in
//                
//                    if let myfren = User.init(snapshot: snap2){
//                        if self.allUsers[myfren.username] == nil && myfren.userUID != Session.currentUserUid {
//                            print("Not collaborator adding..")
//                            self.availableUsers[myfren.username] = myfren
//                            self.draggableViewBackground.addToExampleCardLabels(user: myfren)
//                        }
//                    }
//                })
                }
            }
        })
        
    }

    @IBAction func refresh(_ sender: UIButton) {
        if self.draggableViewBackground != nil && self.draggableViewBackground.exampleCardLabels != nil {
            self.draggableViewBackground.exampleCardLabels.removeAll()
        }
        
        loadUser()
        
        //self.draggableViewBackground = CollaboratorViewBackground(frame:self.view.frame)
        //self.view.addSubview(self.draggableViewBackground)
    }
    

}
