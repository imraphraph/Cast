//
//  DetailCastCollectionViewCell.swift
//  
//
//  Created by Keith Piong on 27/09/2016.
//
//

import UIKit

class DetailCastCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var rewardsImageView: UIImageView!
    @IBOutlet weak var collaboratorsImageView: UIImageView!
    
    @IBOutlet weak var maleCollab: UIImageView!
    @IBOutlet weak var femaleCollab: UIImageView!
    
    @IBOutlet weak var collaborateButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
}
