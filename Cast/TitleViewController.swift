//
//  TitleViewController.swift
//  Cast
//
//  Created by Keith Piong on 30/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import GooglePlaces
import FirebaseStorage
import FirebaseDatabase

class TitleViewController: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    
    let imagePicker = UIImagePickerController()

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var slidingView: UIView!
    @IBOutlet weak var widthSlidingView: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var categorySelected : String! = ""
    
    @IBOutlet weak var imagePickerView: UIImageView!
    var imagePickerUrl = [String!]()
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var dateTextField: UITextField!
    
    @IBOutlet weak var photogBtn: UIButton!
    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    
    @IBOutlet weak var dateOK: UIButton!
    var rewardTypeText : String!
    @IBOutlet weak var cashButton: UIButton!
    @IBOutlet weak var tfpButton: UIButton!
    
    var placesClient: GMSPlacesClient?
    
    var categoryList = ["Cosplay","Wedding","Stock","Fashion","Other"]
    var rewardTypeList = ["Cash","TradeForPrint"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        
        self.scrollView.delegate = self
        self.scrollView.isPagingEnabled = true
        
        
        let viewWidth = self.view.frame.size.width
        widthSlidingView.constant = viewWidth * 4
        
        self.titleTextField.becomeFirstResponder()
        
        self.datePicker.alpha = 0
        dateTextField.delegate = self
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        placesClient = GMSPlacesClient.shared()
       
    }
    
    ////Page Scrollings///
    @IBOutlet weak var nextButton: UIButton!
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        moveToNextPage()
        pageControl.currentPage += 1

    }
    
    
    func moveToNextPage (){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        let slideToX = contentOffset + pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            self.nextButton.isHidden = true
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }
    
        func moveToPage (page : Int){
        
        let pageWidth:CGFloat = self.scrollView.frame.width
        let maxWidth:CGFloat = pageWidth * 4
        let contentOffset:CGFloat = self.scrollView.contentOffset.x
        
        var slideToX = contentOffset - pageWidth
        
        if  contentOffset + pageWidth == maxWidth
        {
            slideToX = CGFloat(page)
        }
        self.scrollView.scrollRectToVisible(CGRect(x:slideToX, y:0, width:pageWidth, height:self.scrollView.frame.height), animated: true)
    }


    
    func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x:x , y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    ////Image Picker////

    @IBAction func openImagePicker(_ sender: UITapGestureRecognizer) {
        
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        imagePickerView.image = selectedImageFromPicker
        
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func useDefaultPicture(_ sender: UIButton) {
        
        if self.categorySelected == "Fashion" {
            imagePickerView.image = UIImage(named: "Fashion")
        }else if self.categorySelected == "Wedding" {
            imagePickerView.image = UIImage(named: "Wedding")
        }else if self.categorySelected == "Cosplay" {
            imagePickerView.image = UIImage(named: "Cosplay")
        }else if self.categorySelected == "Stock" {
            imagePickerView.image = UIImage(named: "Stock")
        }else if self.categorySelected == "Others" {
            imagePickerView.image = UIImage(named: "Others")
        }else if self.categorySelected == "" {
            
            let alertView = UIAlertController(title: "Please Select A Category", message: "", preferredStyle: UIAlertControllerStyle.alert)
            
            let dismissAction = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            
            alertView.addAction(dismissAction)
            self.present(alertView, animated: true, completion: { _ in })
            moveToPage(page: 2)
        }
    }
    
    // Present the Autocomplete view controller when the button is pressed.
    
    @IBAction func autocompleteTapped(_ sender: AnyObject) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        self.present(autocompleteController, animated: true, completion: nil)
        print("tapped")
    }

    func displayEventDate() {
        //Use NSDateFormatter to write out the date in a friendly format
        let df = DateFormatter()
        df.dateStyle = .medium
        self.dateTextField.text = "\(df.string(from: self.datePicker.date))"
    }
    
   
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
         if textField == dateTextField {
            fadeIn(view: self.datePicker, delay: 0)
            fadeIn(view: self.dateOK, delay: 0)
            fadeOut(view: self.scrollView, delay: 0)
            self.datePicker.datePickerMode = .date;
            self.datePicker.addTarget(self, action: #selector(self.displayEventDate), for: .valueChanged)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @IBAction func dateOK(_ sender: UIButton) {
        
        self.dateTextField.resignFirstResponder()
        self.datePicker.resignFirstResponder()
        fadeOut(view: datePicker, delay: 0)
        fadeOut(view: self.dateOK, delay: 0)
        fadeIn(view: scrollView, delay: 0)
    }
    
    
    @IBAction func onCollabBtnPressed(_ sender: UIButton) {
        
       
        if !sender.isSelected {
            sender.isSelected=true
             print("sender value \(sender.isSelected)")
            sender.setImage(UIImage(named: "accept-tick-icon-12"), for:.normal)
        } else {
            sender.isSelected = false
             print("sender value \(sender.isSelected)")
            sender.setImage( UIImage(named:"add"), for: .normal)
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
        self.categorySelected = selectedCell
        print(selectedCell)
        
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
        guard let category = self.categorySelected else { return }

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
        
        let castRef = DataService.rootRef.child("casts").childByAutoId()
        let storageRef = FIRStorage.storage().reference()
        let castImageRef = storageRef.child("refImage").child(castRef.key)
        print(castRef.key)
        
        
        let castDict = ["created_at":NSDate().timeIntervalSince1970,"userUID":Session.currentUserUid, "castname":castname, "event_date": evtdatetimeInterval, "location": location, "reward_type":rewardType, "description":description, "status":"new","category":category, "female_needed":fmodelNeeded,"male_needed":mmodelNeeded,"photog_needed":photographerNeeded, "ref_imageURL" : ""] as [String : Any]
        
      
        castRef.setValue(castDict)
        
        if let uploadData = UIImageJPEGRepresentation(imagePickerView.image!, 0.7) {
            castImageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                
                if error != nil{
                    print(error)
                    return
                } else {
                    
                    if let imageURL = metadata?.downloadURLs?.first{
                        castRef.child("ref_imageURL").setValue(imageURL.absoluteString)
                    }
                }
            })
        }
        
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


extension TitleViewController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: ", place.name)
        print("Place address: ", place.formattedAddress)
        print("Place attributions: ", place.attributions)
        self.dismiss(animated: true, completion: nil)
        self.locationTextField.text = place.formattedAddress
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
