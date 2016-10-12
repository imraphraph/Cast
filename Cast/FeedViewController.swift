//
//  FeedViewController.swift
//  Cast
//
//  Created by Keith Piong on 27/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var widthSlidingView: NSLayoutConstraint!
    
    var modelImage: [UIImage] = [
        UIImage(named: "Fashion")!,
        UIImage(named: "Wedding")!,
        UIImage(named: "cosplay")!,
        UIImage(named: "STOCK")!,
        UIImage(named: "OTHERS")!
    ]
  
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewWidth = self.view.frame.size.width
        widthSlidingView.constant = viewWidth * 3
        
        configurePageControl()
        
        self.topScrollView.delegate = self
        self.topScrollView.isPagingEnabled = true
        
//        let selector = #selector(changePage(sender:)) // swift 3
        pageControl.addTarget(self, action: Selector("changePage:"), for: UIControlEvents.valueChanged)
    }

    func configurePageControl() {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = 3
        self.pageControl.currentPage = 0
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    func changePage(sender: AnyObject) {
        let x = CGFloat(pageControl.currentPage) * topScrollView.frame.size.width
        topScrollView.setContentOffset(CGPoint(x:x , y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destination = segue.destination as! CastersViewController
        if segue.identifier == "1stSegue"{
        destination.images = [image1.image!]
        destination.images += modelImage
            
        }
        else if segue.identifier == "2ndSegue"{
            destination.images = [image2.image!]
            destination.images += modelImage
        }
        else if segue.identifier == "3rdSegue"{
            destination.images = [image3.image!]
            destination.images += modelImage
        }
        else if segue.identifier == "4thSegue"{
            destination.images = [image4.image!]
            destination.images += modelImage
        }
        else if segue.identifier == "5thSegue"{
            destination.images = [image5.image!]
            destination.images += modelImage
        }
    }
}
