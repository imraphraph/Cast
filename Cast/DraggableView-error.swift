////
////  DraggableView.swift
////  Cast
////
////  Created by khong fong tze on 10/10/2016.
////  Copyright © 2016 com.cast. All rights reserved.
////
//
//import UIKit
//
//
//protocol DraggableViewDelegate {
//    func cardSwipedLeft (_ card: UIView)
//    func cardSwipedRight (_ card: UIView)
//}
//
//
//class DraggableView: UIView {
//
//    let ACTION_MARGIN = 120
//    let SCALE_STRENGTH = 4
//    let SCALE_MAX : Float = 0.93
//    let ROTATION_MAX  = 1
//    let ROTATION_STRENGTH = 320
//    let ROTATION_ANGLE  = M_PI/8
//    
//    var delegate: DraggableViewDelegate?
//    var panGestureRecognizer: UIPanGestureRecognizer!
//    var originalPoint = CGPoint.zero
//    var overlayView: OverlayView!
//    var information: UILabel!
//    
//    var username: UILabel!
//    var profilePhoto: UIImageView!
//    var castID = ""
//    var notifyID = ""
//    var queueID = ""
//    
//    var xFromCenter: CGFloat = 0.0
//    var yFromCenter: CGFloat = 0.0
//    
//    override init(frame: CGRect){
//        super.init(frame: frame)
//        
//        self.setupView()
//        
//        profilePhoto = UIImageView(frame: CGRect(x:80, y:60, width:100, height:100))
//        profilePhoto.image! = UIImage(named: "cowgirl")!
//        profilePhoto.clipsToBounds=true
//        profilePhoto.layer.cornerRadius=20.0
//        
//        username = UILabel(frame: CGRect(x:60,y:10,width:self.frame.size.width - 80, height:50))
//        username.text! = "no username given"
//        username.textAlignment = .left
//        username.textColor=UIColor.gray
//        
//        information = UILabel(frame: CGRect(x:0,y:180,width:self.frame.size.width,height:100))
//        information.text! = ""
//        information.textAlignment = .left
//        information.textColor=UIColor.blue
//        information.backgroundColor = UIColor.white
//        
//        panGestureRecognizer = UIPanGestureRecognizer(target:self,action:#selector(self.beingDragged))
//        
//        self.addGestureRecognizer(panGestureRecognizer)
//        self.addSubview(information)
//        self.addSubview(username)
//        self.addSubview(profilePhoto)
//        
//        overlayView = OverlayView(frame: CGRect(x:self.frame.size.width/2-100, y:0,width:100,height:100))
//        overlayView.alpha = 0
//        self.addSubview(overlayView)
//        
//        
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//     func beingDragged(_ gestureRecognizer: UIPanGestureRecognizer){
//        xFromCenter = gestureRecognizer.translation(in: self).x
//        yFromCenter = gestureRecognizer.translation(in: self).y
//        
//        switch gestureRecognizer.state{
//            case.began: self.originalPoint = self.center
//            
//        case .changed:
//            let rotationStrength: CGFloat = min(xFromCenter/CGFloat(ROTATION_STRENGTH), CGFloat(ROTATION_MAX))
//            let rotationAngel: CGFloat = CGFloat(CGFloat(ROTATION_ANGLE) * rotationStrength)
//            let scale: CGFloat = max(1 - (CGFloat(fabsf(Float(rotationStrength))) / CGFloat(SCALE_STRENGTH)), CGFloat(SCALE_MAX))
//            self.center = CGPoint(x: self.originalPoint.x + xFromCenter, y: self.originalPoint.y + yFromCenter)
//            let transform = CGAffineTransform(rotationAngle: rotationAngel)
//            let scaleTransform = transform.scaledBy(x: scale, y: scale)
//            self.transform = scaleTransform
//            self.updateOverlay(_distance: xFromCenter)
//            
//        case .ended: self.afterSwipeAction()
//        case .possible: break
//        case .cancelled: break
//        case .failed: break
//            
//        }
//    }
//    
//    
//    func setupView()
//    {
//    self.layer.cornerRadius = 4;
//    self.layer.shadowRadius = 3;
//    self.layer.shadowOpacity = 0.2;
//        self.layer.shadowOffset = CGSize(width:1, height:1);
//    }
//    
//    
//    func updateOverlay(_distance: CGFloat){
//        if _distance > 0 {
//            overlayView.mode = GGOverlayViewMode.right
//        } else {
//            overlayView.mode = GGOverlayViewMode.left
//        }
//        overlayView.alpha = CGFloat(min(fabsf(Float(_distance))/100, Float(0),Float(4)))
//    }
//    
//    func afterSwipeAction() {
//        if xFromCenter > CGFloat(ACTION_MARGIN) {
//            self.rightAction()
//        } else if xFromCenter < -CGFloat(ACTION_MARGIN) {
//            self.leftAction()
//        } else {
//            UIView.animate(withDuration: 0.3, animations: { 
//                self.center = self.originalPoint
//                self.transform = CGAffineTransform(rotationAngle: 0)
//                self.overlayView.alpha = 0
//            })
//        }
//    }
//    
//    func rightAction(){
//        let finishPoint = CGPoint(x:500,y:2*yFromCenter+self.originalPoint.y)
//        UIView.animate(withDuration: 0.3, animations: {
//            self.center = finishPoint
//            }, completion: {(complete:Bool) -> Void in
//                self.removeFromSuperview()
//        })
//        delegate?.cardSwipedRight(self)
//        print("YES")
//    }
//    
//    func leftAction(){
//        let finishPoint = CGPoint(x:-500,y:2*yFromCenter+self.originalPoint.y)
//        UIView.animate(withDuration: 0.3, animations: {
//            self.center = finishPoint
//            }, completion: {(complete:Bool) -> Void in
//                self.removeFromSuperview()
//        })
//        delegate?.cardSwipedLeft(self)
//        print("NO")
//    }
//    
//    func rightClickAction() {
//        let finishPoint = CGPoint(x:600,y:self.center.y)
//        UIView.animate(withDuration: 0.3, animations: {() -> Void in
//            self.center = finishPoint
//            self.transform = CGAffineTransform(rotationAngle: 1)
//            }, completion: {(complete:Bool) -> Void in
//                self.removeFromSuperview()
//        })
//        delegate?.cardSwipedRight(self)
//        print("YES")
//
//    }
//    
//    func leftClickAction() {
//        let finishPoint = CGPoint(x:-600,y:self.center.y)
//        UIView.animate(withDuration: 0.3, animations: {() -> Void in
//            self.center = finishPoint
//            self.transform = CGAffineTransform(rotationAngle: -1)
//            }, completion: {(complete:Bool) -> Void in
//                self.removeFromSuperview()
//        })
//        delegate?.cardSwipedLeft(self)
//        print("NO")
//
//    }
//    
//    
//
//}
