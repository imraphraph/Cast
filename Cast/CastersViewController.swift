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
    var sendingTheImage = [UIImage]()
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "LobsterTwo", size: 20)!]
        
        DataService.rootRef.child("casts").observe(.childAdded, with: { (snapshot) in
            
            if let allCast = Cast(snapshot: snapshot) {
                self.cast.append(allCast)
                self.collectionView.reloadData()
            }
        })
    }
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let currentCast = cast.reversed()[indexPath.row]
        
//        cell.imageView.image = images[indexPath.row]
        cell.nameLabel.text = currentCast.castName
        cell.locationLabel.text = currentCast.location
        
        let formattedDate = MyDateFormatter.displayDateTime(datetime: currentCast.eventDate)
        cell.dateLabel.text = formattedDate
        
        if currentCast.photogNeeded == "true"{
            cell.collaboratorsImageView.image = UIImage(named: "camera@16")
        } else {
            cell.collaboratorsImageView.image = UIImage(named: "")
        }
        
        if currentCast.femaleNeeded == "true"{
            cell.femaleCollab.image = UIImage(named: "female@16")
        } else {
            cell.femaleCollab.image = UIImage(named: "")
        }
        
        if currentCast.maleNeeded == "true"{
            cell.maleCollab.image = UIImage(named: "male@16")
        } else {
            cell.maleCollab.image = UIImage(named: "")
        }
        
        
        if currentCast.rewardType == .cash {
            cell.rewardsImageView.image = UIImage(named: "dollar")
    
        } else {
            cell.rewardsImageView.image = UIImage(named: "")
        }
        
        if currentCast.rewardType == .tradeforprint {
            cell.rewardsImageView.image = UIImage(named: "barter")
        } else {
            cell.rewardsImageView.image = UIImage(named: "")
        }
        
        let eventLocation = currentCast.location // convert to city area
        
        cell.locationLabel.text = eventLocation
        
        
        
        // Configure the cell
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! DetailCastCollectionViewCell
        
        let currentCast = cast.reversed()[indexPath.row]
        let image = cell.imageView.image
        self.sendingTheImage.append(image!)
        self.sendingTheCast = [currentCast]
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "detailSegue"{
            let destination = segue.destination as! DetailCastViewController
            destination.currentCast = self.sendingTheCast
            destination.selectedImage = self.sendingTheImage
        }
    }

}
