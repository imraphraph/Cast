//
//  DetailCastViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class DetailCastViewController: UIViewController {
    
    
    var  currentCast = [Cast]()
    var selectedCast:Cast!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collaborateButton: UIButton!
    @IBOutlet weak var requestSent: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestSent.isHidden = true
        collaborateButton.isHidden = false
        
        selectedCast = currentCast[0]
        let UID = selectedCast.castID
        
        
      ////Get the UserName
        
//        DataService.userRef.observe(.value, with: { (snapshot) in
//            
//            
//            
//            for userID in snapshot.children {
//                
//                
//                if userID == UID {
//                    DataService.userRef.child("").observe(.value, with: {(snapshot) in
//                    })
//                
//                }
//            }
//            
//        })
        
        self.usernameLabel.text = "Gene"
        self.titleLabel.text = selectedCast.castName
        self.textView.text = selectedCast.description
        self.locationLabel.text = selectedCast.location
        
        let interval = selectedCast.eventDate
        let date = NSDate(timeIntervalSince1970: interval)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        self.dateLabel.text = dateString
        
        
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func collaborateButtonPressed(_ sender: AnyObject) {

        print(Collaborator.Role.Photographer)
        
        //create queue under the cast node
        let collaborateDict = ["created_at":NSDate().timeIntervalSince1970, "userUID":Session.currentUserUid, "role": "photographer" ] as [String : Any]
        let queueRef = DataService.rootRef.child("casts").child(selectedCast.castID).child("queue").childByAutoId()
        queueRef.updateChildValues(collaborateDict)
        
        //create notification node
        let notifyDict = ["created_at":NSDate().timeIntervalSince1970, "From":Session.currentUserUid, "To":selectedCast.userUID, "castID": selectedCast.castID, "message": "I would like to collaborate in this job.", "status":"new" ] as [String : Any]
        let notifyRef = DataService.rootRef.child("notification").childByAutoId()
        notifyRef.updateChildValues(notifyDict)
        
        //add the notification to the Receiver User
    DataService.userRef.child(selectedCast.userUID).child("being_notified").updateChildValues([notifyRef.key:true])
        
        
        requestSent.isHidden = false
        collaborateButton.isHidden = true
    }

}
