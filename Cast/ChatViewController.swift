//
//  ChatViewController.swift
//  Cast
//
//  Created by khong fong tze on 10/10/2016.
//  Copyright © 2016 com.cast. All rights reserved.
//

import UIKit
import JSQMessagesViewController

class ChatViewController: JSQMessagesViewController {

    var messages = [JSQMessage]()
    var outgoingBubbleImageView: JSQMessagesBubbleImage!
    var incomingBubbleImageView: JSQMessagesBubbleImage!
    var receiver:User!
    var chatRoomId:String!
    var defaultChatRoomId:String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        defaultChatRoomId = Session.currentUserUid + "@" + receiver.userUID
        
        setupBubbles()
        
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        setupChat()
        //observeMessages()
        //addMessage(id: receiver.userUID, text: "Hey I am interested in the Photoshoot, how can we proceed?!")
        // messages sent from local sender
        //addMessage(id: senderId, text: "Hey!")
        //addMessage(id: senderId, text: "Nice to meet you!")
        // animates the receiving of a new message on the view
        //finishReceivingMessage()
    }

    func observeMessages() {
        
        let messagesQuery = DataService.rootRef.child("chatroom").child(chatRoomId).child("messages").queryLimited(toLast: 25)
        
        messagesQuery.observe(.childAdded, with: { (snapshot) in
            
            if let chat = ChatMessage.init(snapshot: snapshot){
                //chat.chatRoomId = self.chatRoomId
                //chat.sender = self.senderId
                //chat.receiver = self.receiver.userUID
                self.addMessage(id: chat.sender, text:chat.messageText)
                self.finishReceivingMessage()
            }
        })
    }
    
    
    override func textViewDidChange(_ textView: UITextView) {
        super.textViewDidChange(textView)
        // If the text is not empty, the user is typing
        print(textView.text != "")
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupBubbles() {
        let factory = JSQMessagesBubbleImageFactory()
        outgoingBubbleImageView = factory?.outgoingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleBlue())
        incomingBubbleImageView = factory?.incomingMessagesBubbleImage(
            with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }

    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    func addMessage(id: String, text: String) {
        let message = JSQMessage(senderId: id, displayName: "", text: text)
        messages.append(message!)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath)
            as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView!.textColor = UIColor.white
        } else {
            cell.textView!.textColor = UIColor.black
        }
        
        return cell
    }
    
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
    
        //print(messages.count)
        //chatroom + message
        //userchats
    
        let chatRoomDict = ["text":text,"sender":senderId, "created_at":NSDate().timeIntervalSince1970] as [String : Any]
        
        let chatRoomRef = DataService.rootRef.child("chatroom").child(chatRoomId).child("messages").childByAutoId()
        chatRoomRef.updateChildValues(chatRoomDict)
        
        let userChatSenderDict = [receiver.userUID:chatRoomId] as [String : Any]
        let userChatsRef = DataService.rootRef.child("userchats").child(Session.currentUserUid)
        userChatsRef.setValue(userChatSenderDict)

        let userChatReceiverDict = [Session.currentUserUid:chatRoomId] as [String : Any]
        let userChatReceiverRef = DataService.rootRef.child("userchats").child(receiver.userUID)
        userChatReceiverRef.setValue(userChatReceiverDict)
        
        // 4
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        //addMessage(id: senderId, text: text)
        
        // 5
        finishSendingMessage()
        
        //print(messages.count)
    }
    
    func setupChat() {
        
        DataService.rootRef.child("userchats").child(Session.currentUserUid).child(receiver.userUID).observeSingleEvent(of: .value, with: { (snapshot) in
            //print(snapshot.value)
            if let chatRoomUID = snapshot.value as? String {
                self.chatRoomId = chatRoomUID
                print(self.chatRoomId)
                self.observeMessages()
            
            }
        })
        
        if let _ = self.chatRoomId  {
            
        } else {
            self.chatRoomId = defaultChatRoomId
        }
      
    }
    
    override func didPressAccessoryButton(_ sender: UIButton!) {
        print("Attachment not supported")
    }
}
