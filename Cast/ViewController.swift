//
//  ViewController.swift
//  pageView
//
//  Created by Keith Piong on 01/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource{
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var pageViewController : UIPageViewController!
    let pages = ["firstVC", "secondVC", "thirdVC", "fourthVC"]
    
    var pageController = UIPageControl.appearance()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let lobsterFont = UIFont.init(name: "LobsterTwo", size: 15)

        
//        self.navigationController?.navigationBar.titleTextAttributes = [lobsterFont : UIFont]
        
        
        pageController.pageIndicatorTintColor = UIColor.lightGray
        pageController.currentPageIndicatorTintColor = UIColor.black
        pageController.backgroundColor = UIColor.white
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "PageViewController"){
            self.addChildViewController(vc)
            self.view.addSubview(vc.view)
            
            
            pageViewController = vc as! UIPageViewController
            pageViewController.dataSource  = self
            pageViewController.delegate = self
            
        }
        
        pageViewController.setViewControllers([viewControllerAtIndex(index: 0)!], direction: .forward, animated: true, completion: nil)
        pageViewController.didMove(toParentViewController: self)
        
    }
    
    
//////////Page View Controller Methods////
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if let index = pages.index(of: viewController.restorationIdentifier!) {
            if index > 0 {
                return viewControllerAtIndex(index: index - 1)
            }
        }
        
        return nil
    }
    @IBAction func pageControl(_ sender: AnyObject) {
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        
        if let index = pages.index(of: viewController.restorationIdentifier!){
            if index < pages.count - 1 {
                return viewControllerAtIndex(index: index + 1)
            }
        }
        return nil
    }
    
    func viewControllerAtIndex(index : Int) -> UIViewController? {
        let vc = storyboard?.instantiateViewController(withIdentifier: pages[index])
        return vc
        
    }
    
    
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}

