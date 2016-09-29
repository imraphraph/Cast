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
    
    @IBOutlet weak var rewardType: UITextField!
    @IBOutlet weak var categoryTxt: UITextField!
    
    var defaultDateHeight : CGFloat = 0
    
    @IBOutlet weak var photogphBtn: UIButton!
    
    @IBOutlet weak var femaleBtn: UIButton!
    
    @IBOutlet weak var maleBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultDateHeight = datePickerHeightConstraint.constant
        datePickerHeightConstraint.constant = 0
        
        eventDateTxt.delegate=self
        
        nameTxt.text = "my wedding"
        locationTxt.text = "klcc"
        rewardTxt.text = "1200"
        descriptionTxt.text = "wedding shooting"
        rewardType.text = "TFP"
        categoryTxt.text = "wedding"
        
        
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

        
        guard let castname = nameTxt.text else { return }
        guard let eventDate = eventDateTxt.text else { return }
        guard let location = locationTxt.text else { return }
        guard let rewardType = rewardType.text else { return }
        guard let description = descriptionTxt.text else { return }
        guard let category = categoryTxt.text else { return }
        
        var mmodelNeeded : String, photographerNeeded : String, fmodelNeeded : String
        if femaleBtn.isSelected {
            fmodelNeeded = "true"
        } else {
            fmodelNeeded = "false"
        }
        
        if maleBtn.isSelected {
            mmodelNeeded = "true"
        } else {
            mmodelNeeded = "false"
        }
        
        if photogphBtn.isSelected  {
            photographerNeeded = "true"
        } else {
            photographerNeeded = "false"
        }
        
        
        let castDict = ["created_at":NSDate().timeIntervalSince1970,"userUID":Session.currentUserUid, "castname":castname, "event_date": NSDate().timeIntervalSince1970, "location": location, "reward_type":rewardType, "description":description, "status":"new","category":category, "female_needed":fmodelNeeded,"male_needed":mmodelNeeded,"photog_needed":photographerNeeded ] as [String : Any]
        
        
        let castRef = DataService.rootRef.child("casts").childByAutoId()
        castRef.setValue(castDict)
        
        DataService.userRef.child(Session.currentUserUid).child("casts").updateChildValues([castRef.key:true])


        
    }
}
