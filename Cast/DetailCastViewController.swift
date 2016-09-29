//
//  DetailCastViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class DetailCastViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collaborateButton: UIButton!
    @IBOutlet weak var requestSent: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        requestSent.isHidden = true
        collaborateButton.isHidden = false
        
        // Do any additional setup after loading the view.
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
