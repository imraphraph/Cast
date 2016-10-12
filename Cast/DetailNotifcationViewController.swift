//
//  DetailNotifcationViewController.swift
//  Cast
//
//  Created by khong fong tze on 12/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

//
//  DetailCastViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import SDWebImage

class DetailNotificationViewController: UIViewController {
    
    
    @IBOutlet var firstView: UIView!
    var selectedNotification: CastNotification!
    var selectedCast:Cast!
    var username:String!
    let message = "Hey I am interested with this job"
    
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
    @IBOutlet weak var cameraIcon: UIImageView!
    @IBOutlet weak var maleIcon: UIImageView!
    @IBOutlet weak var femaleIcon: UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        if let sc = selectedCast, let sn=selectedNotification {
//            firstView.addSubview(firstView)
//            print("here")
//        } else {
        
        
        guard let sc = selectedCast, let sn=selectedNotification else { return }
        
        self.profilPicImage.layer.cornerRadius = 10
        
        self.profilPicImage.layer.borderWidth = 3.0
        self.profilPicImage.layer.borderColor = UIColor.white.cgColor
        
        requestSent.alpha = 0
        collaborateButton.alpha = 1
        
        //selectedCast = currentCast[0]
        
        self.titleLabel.text = selectedNotification.sender.role
        self.textView.text = message
        self.locationLabel.text = selectedCast.location
        
        let imageUrl = NSURL(string: selectedCast.refImage)
        self.refImageView.sd_setImage(with: imageUrl as URL!)
        
        self.categoryLabel.text = selectedCast.castName
        let interval = selectedCast.eventDate
        let date = NSDate(timeIntervalSince1970: interval)
        
        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "MMM dd YYYY"
        
        let dateString = dayTimePeriodFormatter.string(from: date as Date)
        self.dateLabel.text = dateString
        
        //go to Database to find username and profile pic///
//        let UID = selectedCast.userUID
//        DataService.userRef.child(UID).child("username").observe(.value, with: { (snapshot) in
//            
//            self.username = snapshot.value as! String
//            self.usernameLabel.text = self.username
//        })
        
        self.usernameLabel.text = self.selectedNotification.sender.username
        
        if let collaboratorImage = self.selectedNotification.sender.profilePhotoURL {
            let profileImageUrl = NSURL(string: collaboratorImage)
            self.profilPicImage.sd_setImage(with: profileImageUrl as URL!)
        }
            //else {
//            DataService.userRef.child(UID).child("profilePicture").observe(.value, with: { (snapshot) in
//              let profileImageUrl = NSURL(string:snapshot.value as! String)
//              self.profilPicImage.sd_setImage(with: profileImageUrl as URL!)
//            })
//        }
        
        if selectedCast.photogNeeded == "true" {
            self.cameraIcon.isHidden = false
        } else {
            self.cameraIcon.isHidden = true
        }
        if selectedCast.femaleNeeded == "true" {
            self.femaleIcon.isHidden = false
        } else {
            self.femaleIcon.isHidden = true
        }
        if selectedCast.maleNeeded == "true" {
            self.maleIcon.isHidden = false
        } else {
            self.maleIcon.isHidden = true
        }
            
        //}
    }
   
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    @IBAction func collaborateButtonPressed(_ sender: AnyObject) {
    
        
        if let role = selectedNotification.sender.role {
            var childnode = ""
            
            if role.lowercased().range(of: "model") != nil {
                childnode = "model"
            } else if role.lowercased().range(of: "grapher") != nil {
                childnode = "photographer"
            } else {
                childnode = "photographer"
            }
            
            let collaUpdateRef = DataService.rootRef.child("casts").child(selectedCast.castID).child(childnode)
            
            collaUpdateRef.updateChildValues(["UserUID":Session.currentUserUid])
        }
            //update the queue with status ACCEPT
            let queueUpdateDict = ["responsed_at":NSDate().timeIntervalSince1970,"status":"accept"] as [String : Any]
            
            let queueRef = DataService.rootRef.child("casts").child(selectedNotification.castID).child("queue").child(selectedNotification.queueID)
            queueRef.updateChildValues(queueUpdateDict)
            
            //update the notification with status RESPONSED
            let notifyUpdateDict = ["responsed_at":NSDate().timeIntervalSince1970,"status": "accept"] as [String : Any]
            
            let notifyUpdateRef = DataService.rootRef.child("notification").child(selectedNotification.notifyUID)
            notifyUpdateRef.updateChildValues(notifyUpdateDict)
            
    

        
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
    
    
    @IBOutlet weak var panView: UIView!
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        
        let translation = sender.translation(in: self.panView)
        if let view = sender.view {
            let newCenter = CGPoint(x:view.center.x, y:view.center.y + translation.y)
            print(newCenter)
            
            let maxTopPoint = view.bounds.size.height * 0.30
            let maxLowPoint = view.bounds.size.height * 0.5
            
            print("\(maxTopPoint) hehe")
            
            if (newCenter.y >= maxTopPoint && newCenter.y <= maxLowPoint) {
                view.center = newCenter
                if sender.state == UIGestureRecognizerState.ended{
                    if newCenter.y <= maxTopPoint * 1.15 {
                        UIView.animate(withDuration: 0.7, animations: {view.center.y = maxTopPoint}, completion: nil)
                        
                    }else if newCenter.y >= maxTopPoint * 1.15 {
                        UIView.animate(withDuration: 0.4, animations: {view.center.y = maxLowPoint}, completion: nil)
                    }
                }
                sender.setTranslation( CGPoint(x:0, y: 0), in: self.view)
            }
        }
    }
}
