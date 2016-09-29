//
//  NewCastViewController.swift
//  Cast
//
//  Created by khong fong tze on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class NewCastViewController: UIViewController, UITextFieldDelegate {

  
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var eventDateTxt: UITextField!
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var rewardTxt: UITextField!
    
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var descriptionTxt: UITextView!
    
    var defaultDateHeight : CGFloat = 0
    
    @IBOutlet weak var photogphBtn: UIButton!
    
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var maleBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultDateHeight = datePickerHeightConstraint.constant
        datePickerHeightConstraint.constant = 0
        
        eventDateTxt.delegate=self
        
    }

    @IBAction func onCollabBtnPressed(_ sender: UIButton) {
        
        print("sender value \(sender.isSelected)")
        if !sender.isSelected {
            sender.isSelected=true
            sender.setImage(UIImage(named: "stop"), for:.normal)
        } else {
            sender.isSelected = false
            sender.setImage( UIImage(named:"check-box-empty"), for: .normal)
        }
        
    }
 
    
    func showView() {
        self.datePicker.datePickerMode = .date;
        self.datePicker.addTarget(self, action: #selector(self.displayEventDate), for: .valueChanged)
        
        UIView.animate(withDuration: 5, delay: 0, options: .curveEaseOut, animations: {
            self.datePickerHeightConstraint.constant = self.defaultDateHeight
//                self.datePicker.setNeedsUpdateConstraints()
            }, completion: nil)
    }
    
    func displayEventDate() {
        //Use NSDateFormatter to write out the date in a friendly format
        let df = DateFormatter()
        df.dateStyle = .medium
        self.eventDateTxt.text = "\(df.string(from: self.datePicker.date))"
  
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.showView()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.eventDateTxt.resignFirstResponder()
        self.datePicker.resignFirstResponder()
        self.hideView()
    }
   
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        self.eventDateTxt.resignFirstResponder()
        self.datePicker.resignFirstResponder()
        self.hideView()
        return true
    }
    
    func hideView() {
        UIView.animate(withDuration: 5, delay: 0, options: .curveEaseOut, animations: {

        self.datePickerHeightConstraint.constant = 0
            
        }, completion: nil)
    }
    
    

    
    
    
    @IBAction func onDoneBtnPressed(_ sender: AnyObject) {

        var newCast = Cast()
        if femaleBtn.isSelected {
            var model = Collaborator()
            model.gender = .Female
            model.role = .Model
            var collList = newCast.collaborators
            if collList != nil {
                collList.append(model)
            } else {
                newCast.collaborators = [Collaborator]()
                newCast.collaborators.append(model)
            }
        }
        
        if maleBtn.isSelected {
            var model = Collaborator()
            model.gender = .Male
            model.role = .Model
            var collList = newCast.collaborators
            if collList != nil {
                collList.append(model)
            } else {
                newCast.collaborators = [Collaborator]()
                newCast.collaborators.append(model)
            }
        }
        
        if photogphBtn.isSelected {
            var model = Collaborator()
            model.role = .Photographer
            var collList = newCast.collaborators
            if collList != nil {
                collList.append(model)
            } else {
                newCast.collaborators = [Collaborator]()
                newCast.collaborators.append(model)
            }
        }
        
    
            
        //let castDict = ["created_at":NSDate().timeIntervalSince1970,"userUID":"fz", "castname":nameTxt.text, "event_date": NSDate().timeIntervalSince1970, "location": locationTxt.text, "reward_type":"TTP", "description":descriptionTxt.text, "status":"new","category":"Fashion"] as [String : Any]
        
        let castDict = ["created_at":NSDate().timeIntervalSince1970]
        
        let castRef = DataService.rootRef.child("casts").childByAutoId()
        castRef.setValue(castDict)
        
//        for c in newCast.collaborators {
//            DataService.rootRef.child("casts").child(castRef.key).child("model")
//            DataService.rootRef.child("casts").child(castRef.key).child("photographer")
//        }
//        DataService.userRef.child("fz").child("casts").updateChildValues([castRef.key:true])


        
    }
}
