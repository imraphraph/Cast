//
//  ContactsCell.swift
//  Cast
//
//  Created by Raphael Lim on 10/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

protocol ContactsCellDelegate {

    func goToChat(row:Int)
    
}

class ContactsCell: UITableViewCell {

    @IBOutlet weak var roleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!

    var delegate : ContactsCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        profileImage.layer.borderWidth = 1
        profileImage.layer.masksToBounds = false
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        profileImage.clipsToBounds = true
//        profileImage.layer.masksToBounds = true
        
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let height = self.frame.height / 2
        profileImage.layer.cornerRadius = height
        
    }
    
    
    
    
    @IBAction func chatButton(_ sender: AnyObject) {
        
        delegate?.goToChat(row: self.tag)
        
    }

   

}
