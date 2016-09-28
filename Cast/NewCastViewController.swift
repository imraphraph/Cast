//
//  NewCastViewController.swift
//  Cast
//
//  Created by khong fong tze on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class NewCastViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var eventDateTxt: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        eventDateTxt.delegate=self
        
        
    }

    func showView() {
        
        self.view.addSubview(dateView)
        dateView.frame = CGRect(x: 0, y: -250, width: 320, height: 50)
        UIView.animate(withDuration: 1.0, animations: {() -> Void in
            self.dateView.frame = CGRect(x: 0, y: 152, width: 320, height: 260)
        })
        eventDateTxt.inputView=dateView
    }
    
    func hideView() {
//        UIView.animate(withDuration: 0.5, animations: {() -> Void in
//            self.dateView.frame = CGRect(x: 0, y: -250, width: 320, height: 50)
//            }, completion: {(finished: Bool) -> Void in
//                self.dateView.removeFromSuperview()
//        })
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == eventDateTxt {
            //self.showView()
            return false
            // preventing keyboard from showing
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == eventDateTxt {
            //self.hideView()
        }
    }
   

    @IBAction func onCalendarPressed(_ sender: UIButton) {
        
        
    }
}
