
//
//  PageViewController.swift
//  Cast
//
//  Created by Keith Piong on 30/09/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class PageViewController: UIPageViewController, UIPageViewControllerDataSource {

    override func viewDidLoad() {
        super.viewDidLoad()

         dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    private(set) var orderedViewControllers: [UIViewController] = {
        return [self.titleViewController("TitleVC"),
                self.descriptionViewController("DescriptionVC"),
                self.imagePickerViewController("ImagePickerVC")]
    }()


//    extension PageViewController: UIPageViewControllerDataSource {
//        
//        func pageViewController(pageViewController: UIPageViewController,
//                                viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
//            return nil
//        }
//        
//        func pageViewController(pageViewController: UIPageViewController,
//                                viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
//            return nil
//        }
//        
        private(set) lazy var orderedViewControllers: [UIViewController] = {
            return [self.titleViewController("TitleVC"),
                    self.descriptionViewController("DescriptionVC"),
                    self.imagePickerViewController("ImagePickerVC")]
        }()
//
        private func newColoredViewController(color: String) -> UIViewController {
            return UIStoryboard(name: "Cast", bundle: nil) .
                instantiateViewControllerWithIdentifier("\(color)ViewController")
        }
    

}
