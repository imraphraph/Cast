//
//  ProfileEditViewController.swift
//  Cast
//
//  Created by Raphael Lim on 6/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class ProfileEditViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let profileSections : [String] = ["username", "gender", "title", "bio", "portfolio", "password reset"]
    let profileImages: [UIImage] = [UIImage(named: "users")!, UIImage(named:"gender")!, UIImage(named: "crown2")!, UIImage(named:"informationbutton")!, UIImage(named:"globe")!, UIImage(named:"mail")!]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return profileSections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! profileEditCell
        let categories = self.profileSections[(indexPath as NSIndexPath).row]
        cell.textLabel!.text = categories
        cell.cellImageView.image = profileImages[indexPath.row]
        return cell
    }

//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        <#code#>
//    }

}
