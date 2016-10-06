//
//  CastersViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class CastersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var images = [UIImage]()
    var cast = [Cast]()
    var sendingTheCast = [Cast]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DataService.rootRef.child("casts").observe(.childAdded, with: { (snapshot) in
            
            if let allCast = Cast(snapshot: snapshot) {
                self.cast.append(allCast)
                self.collectionView.reloadData()
            }
            
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func backButton(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //2
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return self.cast.count
    }
    
    
    //3
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! DetailCastCollectionViewCell
        
        let currentCast = cast[indexPath.row]
        
        cell.imageView.image = images[indexPath.row]
        cell.nameLabel.text = currentCast.castName
        cell.locationLabel.text = currentCast.location
        
        let formattedDate = MyDateFormatter.displayDateTime(datetime: currentCast.eventDate)
        cell.dateLabel.text = formattedDate
        
        if currentCast.photogNeeded == "true"{
            cell.collaboratorsImageView.image = UIImage(named: "camera")
        } else {
            cell.collaboratorsImageView.image = UIImage(named: "")
        }
        
        print(currentCast.rewardType)
        
        if currentCast.rewardType == .cash {
            cell.rewardsImageView.image = UIImage(named: "dollar")
    
        } else {
            cell.rewardsImageView.image = UIImage(named: "")
        }
        
        if currentCast.rewardType == .tradeforprint {
            cell.rewardsImageView.image = UIImage(named: "")
        } else {
            cell.rewardsImageView.image = UIImage(named: "")
        }
        
        let eventLocation = currentCast.location // convert to city area
        
        cell.locationLabel.text = eventLocation
        
        self.sendingTheCast = [currentCast]
        
        // Configure the cell
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue"{
            let destination = segue.destination as! DetailCastViewController
            destination.currentCast = self.sendingTheCast
        }
    }

}
