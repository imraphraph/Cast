//
//  DetailCastViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class DetailCastViewController: UIViewController {
    
    
    var currentCast = [Cast]()
    var selectedCast:Cast!
    var selectedImage = [UIImage]()
    var username:String!
    
    @IBOutlet weak var refImageView: UIImageView!
    @IBOutlet weak var profilPicImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collaborateButton: UIButton!
    @IBOutlet weak var requestSent: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestSent.alpha = 0
        collaborateButton.alpha = 1
        
        selectedCast = currentCast[0]
        let UID = selectedCast.userUID
        
        self.titleLabel.text = selectedCast.castName
        self.textView.text = selectedCast.description
        self.locationLabel.text = selectedCast.location
        self.refImageView.image = selectedImage[0]
//        self.categoryLabel.text = selectedCast.category
        
        let interval = selectedCast.eventDate
        let date = NSDate(timeIntervalSince1970: interval)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        self.dateLabel.text = dateString
        
        DataService.userRef.child(UID).child("username").observe(.value, with: { (snapshot) in
            
            self.username = snapshot.value as! String
            print(UID)
            print(snapshot.value as! String)
            
            self.usernameLabel.text = self.username
            
        })
        
        
    }

        
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func collaborateButtonPressed(_ sender: AnyObject) {

        //print(Collaborator.Role.Photographer)
    
        //create queue under the cast node
        let collaborateDict = ["created_at":NSDate().timeIntervalSince1970, "userUID":Session.currentUserUid, "role": "photographer" ] as [String : Any]
        let queueRef = DataService.rootRef.child("casts").child(selectedCast.castID).child("queue").childByAutoId()
        queueRef.updateChildValues(collaborateDict)
        
        //create notification node
        let notifyDict = ["created_at":NSDate().timeIntervalSince1970, "From":Session.currentUserUid, "To":selectedCast.userUID, "castID": selectedCast.castID, "message": "To collaborate in job [\(selectedCast.castName)]", "status":"new", "queueID":queueRef.key] as [String : Any]
        let notifyRef = DataService.rootRef.child("notification").childByAutoId()
        notifyRef.updateChildValues(notifyDict)
        
        //add the notification to the Receiver User
    DataService.userRef.child(selectedCast.userUID).child("being_notified").updateChildValues([notifyRef.key:true])
        
        //add the cast id to the Requestor -- to keep track what he has requested
        DataService.userRef.child(Session.currentUserUid).child("request_collaboration").updateChildValues([selectedCast.castID:true])
        
        //keep track the notifcation id sent from the Requetor
    DataService.userRef.child(Session.currentUserUid).child("send_notification").updateChildValues([notifyRef.key:true])
        
        fadeIn(view: requestSent, delay: 0)
        collaborateButton.isHidden = true
    }
    
    func fadeIn(view : UIView , delay: TimeInterval)  {
        UIView.animate(withDuration: 0.3, delay: delay, options: [], animations: {
            
            view.alpha = 1
            }, completion: nil)
    }
    
    func fadeOut(view : UIView , delay: TimeInterval)  {
        UIView.animate(withDuration: 0.3, delay: delay, options: [], animations: {
            
            view.alpha = 0
            }, completion: nil)
    }

}
