//
//  CollaboratorViewBackground.swift
//  Cast
//
//  Created by khong fong tze on 07/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit

class CollaboratorViewBackground: UIView, DraggableViewDelegate {
    
    var arrayCopy = [User]()
    var exampleCardLabels = [User]()
    var allCards = [DraggableView]()
    var cardsLoadedIndex = 0
    
    var loadedCards = [DraggableView]()
    var menuButton : UIButton!
    var messageButton : UIButton!
    var checkButton : UIButton!
    var xButton : UIButton!
   
    let MAX_BUFFER_SIZE = 2
    let CARD_HEIGHT: CGFloat = 350
    let CARD_WIDTH: CGFloat = 290
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        super.layoutSubviews()
        self.setupView()
        //        exampleCardLabels = ["first","second","third","fourth","last"]
        //        self.loadCards()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setupView() {
        
        //self.backgroundColor = UIColor(red:0.92,green:0.93,blue:0.95,alpha:1)
        
        menuButton = UIButton(frame:CGRect(x:17,y:34,width:22, height: 15))
        menuButton.setImage(UIImage(named:"menuButton")!,for: .normal)
        
        messageButton = UIButton(frame:CGRect(x:284,y:34,width:18, height: 18))
        messageButton.setImage(UIImage(named:"messageButton")!,for: .normal)
        
        xButton = UIButton(frame:CGRect(x:60,y:485,width:59, height: 59))
        xButton.setImage(UIImage(named:"xButton")!,for: .normal)
        xButton.addTarget(self,action:#selector(self.swipeLeft), for: .touchUpInside)
        
        checkButton = UIButton(frame:CGRect(x:200,y:485,width:59, height: 59))
        checkButton.setImage(UIImage(named:"checkButton")!,for: .normal)
        checkButton.addTarget(self,action:#selector(self.swipeRight), for: .touchUpInside)
        //self.addSubview(menuButton)
        //self.addSubview(messageButton)
        //self.addSubview(xButton)
        //self.addSubview(checkButton)
        
    }
    
    
    func createDraggableViewWithData(at index: Int) -> DraggableView{
        
        let draggableView = DraggableView(frame: CGRect(x: (self.frame.size.width - CARD_WIDTH) / 2, y: (self.frame.size.height - CARD_HEIGHT) / 2, width: CARD_WIDTH, height: CARD_HEIGHT))
        draggableView.layer.cornerRadius=100.0
        
        let fren = exampleCardLabels[index]
        draggableView.information.text = fren.weblinks
        draggableView.username.text = fren.username
        draggableView.castID = fren.userUID //use the castID placeholder
        
        draggableView.delegate = self
        return draggableView
    }
    
    func loadCards() {
        
        if exampleCardLabels.count > 0 {
            let numLoadedCardsCap = ((exampleCardLabels.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : exampleCardLabels.count)
            
            for i in 0..<exampleCardLabels.count {
                let newCard = self.createDraggableViewWithData(at: i)
                allCards.append(newCard)
                if i < numLoadedCardsCap {
                    loadedCards.append(newCard)
                }
            }
            
            for i in 0..<loadedCards.count {
                if i > 0 {
                    self.insertSubview(loadedCards[i], belowSubview: loadedCards[i-1])
                }
                else {
                    self.addSubview(loadedCards[i])
                }
                
                cardsLoadedIndex += 1
            }
            
        }
    }
    
    func addToExampleCardLabels(user: User){
        
        exampleCardLabels.append(user)
        let i = exampleCardLabels.count - 1
        let numLoadedCardsCap = ((exampleCardLabels.count > MAX_BUFFER_SIZE) ? MAX_BUFFER_SIZE : exampleCardLabels.count)
        
        let newCard = self.createDraggableViewWithData(at: i)
        allCards.append(newCard)
        
        if i == 0{
            print("topCard")
            loadedCards.append(newCard)
            self.addSubview(loadedCards[i])
            cardsLoadedIndex += 1
        }else if i < numLoadedCardsCap {
            print("bottomCard")
            loadedCards.append(newCard)
            self.insertSubview(newCard, belowSubview: loadedCards[i-1])
            cardsLoadedIndex += 1
        }
    }
    
    
    func cardSwipedLeft(_ card: UIView) {
        
        loadedCards.remove(at: 0)
        
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex += 1
            self.insertSubview(loadedCards[(MAX_BUFFER_SIZE - 1)], belowSubview: loadedCards[(MAX_BUFFER_SIZE - 2)] )
            
        }
        
    }
    
    func cardSwipedRight(_ card: UIView) {
        let frenView = loadedCards[0]
        
        self.response(responseType: "accept", friendID: frenView.castID)
        
        loadedCards.remove(at: 0)
        if cardsLoadedIndex < allCards.count {
            loadedCards.append(allCards[cardsLoadedIndex])
            cardsLoadedIndex += 1
            self.insertSubview(loadedCards[(MAX_BUFFER_SIZE - 1)], belowSubview: loadedCards[(MAX_BUFFER_SIZE - 2)] )
            
        }
    }
    
    func swipeRight() {
        if (loadedCards.count > 0){
            let dragView = loadedCards.first!
            dragView.overlayView.mode = GGOverlayViewMode.right
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                dragView.overlayView.alpha = 1
            })
            dragView.rightClickAction()
        }
    }
    
    func swipeLeft() {
        if (loadedCards.count > 0){
            let dragView = loadedCards.first!
            dragView.overlayView.mode = GGOverlayViewMode.left
            UIView.animate(withDuration: 0.2, animations: {() -> Void in
                dragView.overlayView.alpha = 1
            })
            dragView.leftClickAction()
        }
    }
    
    func response(responseType:String, friendID:String){
        
        let collaUpdateRef = DataService.userRef.child(Session.currentUserUid).child("friends")
        collaUpdateRef.updateChildValues([friendID:true])
        
    }
    
   
}
