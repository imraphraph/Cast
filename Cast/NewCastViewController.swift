//
//  NewCastViewController.swift
//  Cast
//
//  Created by khong fong tze on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class NewCastViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var eventDateTxt: UITextField!
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var locationTxt: UITextField!
    @IBOutlet weak var rewardTxt: UITextField!
    
    @IBOutlet weak var categoryView: UIPickerView!
    @IBOutlet weak var datePickerHeightConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var descriptionTxt: UITextView!
    @IBOutlet weak var rewardType: UITextField!
    @IBOutlet weak var categoryTxt: UITextField!
    
    @IBOutlet weak var rewardTypePickerView: UIPickerView!
    var defaultDateHeight : CGFloat = 0
    
    @IBOutlet weak var photogphBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    
    var categoryList = ["Cosplay","Wedding","Family","Fashion","Other"]
    var rewardTypeList = ["Cash","TradeForPrint"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultDateHeight = datePickerHeightConstraint.constant
        datePickerHeightConstraint.constant = 0
        
        eventDateTxt.delegate=self
        
        nameTxt.text = "my wedding"
        locationTxt.text = "klcc"
        rewardTxt.text = "1200"
        descriptionTxt.text = "wedding shooting"
        rewardType.text = ""
        categoryTxt.text = ""
        categoryView.isHidden = true
        rewardTypePickerView.isHidden = true
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
    
    func hideView() {
        UIView.animate(withDuration: 5, delay: 0, options: .curveEaseOut, animations: {
            self.datePickerHeightConstraint.constant = 0
            }, completion: nil)
    }
    
    func displayEventDate() {
        //Use NSDateFormatter to write out the date in a friendly format
        let df = DateFormatter()
        df.dateStyle = .medium
        self.eventDateTxt.text = "\(df.string(from: self.datePicker.date))"
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.categoryTxt {
            self.categoryView.isHidden=false
            self.rewardTypePickerView.isHidden=true
            //textField.endEditing(true)
        } else if textField == self.eventDateTxt {
            self.showView()
        } else if textField == self.rewardType {
            self.rewardTypePickerView.isHidden=false
            self.categoryView.isHidden=true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.categoryTxt {
            self.categoryView.isHidden=true
        } else if textField == self.eventDateTxt {
            self.eventDateTxt.resignFirstResponder()
            self.datePicker.resignFirstResponder()
            self.hideView()
        } else if textField == self.rewardType {
            self.rewardTypePickerView.isHidden=true
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(pickerView)
        if pickerView == self.categoryView {
            self.categoryTxt.text = self.categoryList[row]
            self.categoryView.isHidden=true
        } else if pickerView == self.rewardTypePickerView{
            self.rewardType.text = self.rewardTypeList[row]
            self.rewardTypePickerView.isHidden=true
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.categoryView {
            return self.categoryList.count
        } else if pickerView == self.rewardTypePickerView {
            return self.rewardTypeList.count
        }
        
        return 0
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == self.categoryView {
            self.view.endEditing(true)
            return self.categoryList[row]
        } else if pickerView == self.rewardTypePickerView {
            self.view.endEditing(true)
            return self.rewardTypeList[row]
        }
        
        return nil
    }
    
    @IBAction func onDoneBtnPressed(_ sender: AnyObject) {
        
        
        guard let castname = nameTxt.text else { return }
        guard let eventDate = eventDateTxt.text else { return }
        
        if !MyDateFormatter.isAValidFutureDate(dateString: eventDate) {
            print("ERROR: EVENT_DATE is not a valid future date")
            return
        }
        
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
        
        let evtdateTime = MyDateFormatter.displayTimestamp(datetime: eventDate)
        let evtdatetimeInterval = evtdateTime.timeIntervalSince1970
        
        let castDict = ["created_at":NSDate().timeIntervalSince1970,"userUID":Session.currentUserUid, "castname":castname, "event_date": evtdatetimeInterval, "location": location, "reward_type":rewardType, "description":description, "status":"new","category":category, "female_needed":fmodelNeeded,"male_needed":mmodelNeeded,"photog_needed":photographerNeeded ] as [String : Any]
        
        
        let castRef = DataService.rootRef.child("casts").childByAutoId()
        castRef.setValue(castDict)
        
        DataService.userRef.child(Session.currentUserUid).child("casts").updateChildValues([castRef.key:true])
        
        let storyboard = UIStoryboard(name: "AppOverview", bundle: Bundle.main)
        let ChatListViewController = storyboard.instantiateViewController(withIdentifier: "AppOverviewID")
        self.present(ChatListViewController, animated: true, completion: nil)
    }
    
    
    
}
