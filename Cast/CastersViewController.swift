//
//  CastersViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import SDWebImage
import UIActivityIndicator_for_SDWebImage

class CastersViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images = [UIImage]()
    var cast = [Cast]()
    var sendingTheCast = [Cast]()
    var sendingTheImage : UIImage!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    let refresher = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView!.alwaysBounceVertical = true
        refresher.tintColor = UIColor.red
        refresher.addTarget(self, action: #selector(loadData), for: .valueChanged)
        collectionView!.addSubview(refresher)
        
        self.navigationBar.barTintColor = UIColor.white
        self.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "LobsterTwo", size: 20)!]
        
        DataService.rootRef.child("casts").observe(.childAdded, with: { (snapshot) in
            
            if let allCast = Cast(snapshot: snapshot) {
                self.cast.append(allCast)
                self.collectionView.reloadData()
            }
        })
    }
    
    func loadData() {
        self.collectionView.reloadData()
        self.collectionView!.performBatchUpdates({() -> Void in
            }, completion: {(finished: Bool) -> Void in
                /// collection-view finished reload
                self.refresher.endRefreshing()
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
    
    func setImageWith(_ url: URL, usingActivityIndicatorStyle activityStyle: UIActivityIndicatorViewStyle) {
        
        
    }

    //3
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! DetailCastCollectionViewCell
        
        let currentCast = cast.reversed()[indexPath.row]
        
        let imageURL = NSURL(string:currentCast.refImage)
        print("\(imageURL) printing IMAGEREF casterView")
        
        cell.imageView!.sd_setImage(with: imageURL as URL!)
        
        cell.imageView.setIndicatorStyle(.gray)
        
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
        
        return cell
    }
    
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let currentCast = cast.reversed()[indexPath.row]
        self.sendingTheCast = [currentCast]
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        
        if segue.identifier == "detailSegue"{
            let destination = segue.destination as! DetailCastViewController
            destination.currentCast = self.sendingTheCast
        }
    }

}
