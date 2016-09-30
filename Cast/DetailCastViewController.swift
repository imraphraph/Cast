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
        
        let selectedCast = currentCast[0]
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func collaborateButtonPressed(_ sender: AnyObject) {
        requestSent.isHidden = false
        collaborateButton.isHidden = true
    }

}
