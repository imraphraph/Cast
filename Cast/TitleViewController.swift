//
//  TitleViewController.swift
//  Cast
//
//  Created by Keith Piong on 30/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import GooglePlaces

class TitleViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var ViewTable: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var widthSlidingView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var photogBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    var rewardTypeText : String!
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var tfpButton: UIButton!
    
    var placesClient: GMSPlacesClient?
    
    var categoryList = ["Cosplay","Wedding","Family","Fashion","Other"]
    var rewardTypeList = ["Cash","TradeForPrint"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        
        let viewWidth = self.view.frame.size.width
        widthSlidingView.constant = viewWidth * 3
        
        self.titleTextField.becomeFirstResponder()
        
        self.ViewTable.alpha = 0
        self.datePicker.alpha = 0
        dateTextField.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        placesClient = GMSPlacesClient.shared()
       
    }
    
    @IBAction func locationButtonPressed(_ sender: UIButton) {
       
        placesClient?.currentPlace(callback: {
            (placeLikelihoodList: GMSPlaceLikelihoodList?, error: NSError?) -> Void in
            
            if let error = error {
                print("Pick Place error: \(error.localizedDescription)")
                return
            }
            self.locationTextField.text = "No current place"
            
            if let placeLikelihoodList = placeLikelihoodList {
                let place = placeLikelihoodList.likelihoods.first?.place
                if let place = place {
                    self.locationTextField.text = place.name

                }
            }
        } as! GMSPlaceLikelihoodListCallback)
    }


    func displayEventDate() {
        //Use NSDateFormatter to write out the date in a friendly format
        let df = DateFormatter()
        df.dateStyle = .medium
        self.dateTextField.text = "\(df.string(from: self.datePicker.date))"
    }
    @IBOutlet weak var dateOK: UIButton!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == dateTextField {
            fadeIn(view: self.datePicker, delay: 0)
            fadeIn(view: self.dateOK, delay: 0)
            fadeOut(view: self.scrollView, delay: 0)
            self.datePicker.datePickerMode = .date;
            self.datePicker.addTarget(self, action: #selector(self.displayEventDate), for: .valueChanged)
        }
    }
    
    @IBAction func dateOK(_ sender: UIButton) {
        
        self.dateTextField.resignFirstResponder()
        self.datePicker.resignFirstResponder()
        fadeOut(view: datePicker, delay: 0)
        fadeOut(view: self.dateOK, delay: 0)
        fadeIn(view: scrollView, delay: 0)
    }
    
  
    @IBAction func catogoryTapped(_ sender: UITapGestureRecognizer) {
        
        fadeIn(view: self.ViewTable, delay: 0.0)
        fadeOut(view: self.scrollView, delay: 0.0)
        
        print("tapped")
    }
    
    @IBAction func onCollabBtnPressed(_ sender: UIButton) {
        
        print("sender value \(sender.isSelected)")
        if !sender.isSelected {
            sender.isSelected=true
            sender.setImage(UIImage(named: "add"), for:.normal)
        } else {
            sender.isSelected = false
            sender.setImage( UIImage(named:"accept-tick-icon-12"), for: .normal)
        }
    }
    
    @IBAction func cashButtonPressed(_ sender: UIButton) {
        
        rewardTypeText = "Cash"
        print(rewardTypeText)
    
        
    }
    
    @IBAction func tfpButtonPressed(_ sender: UIButton) {
        
        rewardTypeText = "TradeForPrint"
        print(rewardTypeText)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categoryList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        let category = categoryList[indexPath.row]
        
        cell.textLabel?.text = category
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let selectedCell = categoryList[indexPath.row]
        categoryLabel.text = selectedCell
        print(selectedCell)
        
        fadeOut(view: self.ViewTable, delay: 0)
        fadeIn(view: scrollView, delay: 0)
        
    }
 
    
    func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x , y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    
    @IBAction func castButton(_ sender: UIButton) {
        
        guard let castname = titleTextField.text else { return }
        guard let eventDate = dateTextField.text else { return }
        
        if !MyDateFormatter.isAValidFutureDate(dateString: eventDate) {
            print("ERROR: EVENT_DATE is not a valid future date")
            return
        }
        
        guard let location = locationTextField.text else { return }
        guard let rewardType = rewardTypeText else { return }
        guard let description = descriptionTextField.text else { return }
        guard let category = categoryLabel.text else { return }

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
        
        if photogBtn.isSelected  {
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
