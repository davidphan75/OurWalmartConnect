//
//  OWCChatViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit
import Foundation
import Parse

class OWCChatViewController: JSQMessagesViewController {

    var messages = [OWCChatMessage]()
    var users = [PFUser]()
    
    var aChatManager:OWCChatManager?
    
    //defualt profile image
    var senderAvatarImage:UIImage = UIImage(named: "david.jpg")!
    var recipientAvatarImage:UIImage = UIImage(named: "david.jpg")!
    
    //var timer:NSTimer!
    var outgoingBubbleImageView = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(OWCGreen)
    var incomingBubbleImageView = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
    
    
    private var detailsButton: UIBarButtonItem?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.senderDisplayName = PFUser.currentUser()!.username
        self.senderId = self.senderDisplayName
        
        loadUserAvatarImage()
        loadMessages()
        
        //chat left bar item, change to desired back button
//        let exitChatButton = UIImageView(image: UIImage(named: "david.jpg")!)
//        exitChatButton.frame = CGRectMake(0, 0, 26, 26)
//        exitChatButton.backgroundColor = UIColor(red: 249/255.0, green: 249/255.0, blue: 249/255.0, alpha: 1)
        
        //        let subviews = self.inputToolbar!.contentView?.leftBarButtonContainerView?.subviews
        //        for subview in subviews!{
        //            subview.layer.opacity = 0
        //        }
        //self.inputToolbar!.contentView?.leftBarButtonContainerView?.addSubview(exitChatButton)
        //self.inputToolbar?.contentView?.leftBarButtonItem?.imageView?.image = UIImage(named: "greenBackButton.png")
        
        registerPFUserForPushNotifications(PFUser.currentUser()!)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchIncomingMessages", name: "recievedMessage", object: nil)
        
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, didTapAvatarImageView avatarImageView: UIImageView!, atIndexPath indexPath: NSIndexPath!) {
        //code here to segue to user profile
        
        print(messages[indexPath.row].senderId())
        if(messages[indexPath.row].senderId() != PFUser.currentUser()!.username){
            self.performSegueWithIdentifier("showUserProfile", sender: self)
            
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        //timer.invalidate()
        deleteOldMessages()
        print("deleting old message")
        
    }
    
    
    //Update function if you intend to have user profile images
    func loadUserAvatarImage(){
        
        getUserProfilePicture(PFUser.currentUser()!, completion: { (success, userImage) -> Void in
            if success {
                self.senderAvatarImage = userImage!
                self.collectionView!.reloadData()
            }
        })
        
//        getUserProfilePicture((aChatManager?.userChattingWith)!, completion: { (success, userImage) -> Void in
//            if success {
//                self.senderAvatarImage = userImage!
//                self.collectionView!.reloadData()
//            }
//        })
//
//        self.senderAvatarImage = UIImage(named: "david.jpg")!
//        
//        
//        self.recipientAvatarImage = UIImage(named: "david.jpg")!

        
    }
    
    //Loads initial set of messages
    func loadMessages()
    {
        
        let activityMonitor = UIActivityIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.width/2))
        activityMonitor.center = CGPointMake(UIScreen.mainScreen().bounds.width/2, UIScreen.mainScreen().bounds.height/2)
        activityMonitor.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
        activityMonitor.startAnimating()
        activityMonitor.color = UIColor.greenColor()
        self.view.addSubview(activityMonitor)
        
        let last = messages.last
        
        let query = PFQuery(className: "Messages")
        query.whereKey("ChatID", equalTo: aChatManager!.ChatID)
        query.includeKey("ChatUser")
        query.limit = 100
        if last != nil
        {
            query.whereKey("createdAt", equalTo: last!.date()!)
        }
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for items in objects! {
                    self.addMessage(items )
                    self.aChatManager!.lastMessageLoaded = items as? PFObject
                }
                
                self.finishReceivingMessage()
                activityMonitor.stopAnimating()
            }
        }
    }
    
    //fetches incoming messages
    func fetchIncomingMessages(){
        
        let query = PFQuery(className: "Messages")
        query.whereKey("ChatID", equalTo: aChatManager!.ChatID)
        query.includeKey("ChatUser")
        query.limit = 100
        
        if(self.aChatManager!.lastMessageLoaded != nil && self.aChatManager!.lastMessageLoaded!.createdAt != nil){
            query.whereKey("createdAt", greaterThan: self.aChatManager!.lastMessageLoaded!.createdAt!)
        }
        
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                for item in objects! {
                    //println("added message")
                    self.addMessage(item )
                    self.aChatManager!.lastMessageLoaded = item as? PFObject
                    
                }
                self.finishReceivingMessage()
            }
        }
    }
    
    //send message to other user
    func sendMessage(text: String!, sender: String!)
    {
        
        let object = PFObject(className: "Messages")
        object["ChatUser"] = PFUser.currentUser()
        object["ChatID"] = self.aChatManager!.ChatID
        object["ChatText"] = text
        object.saveInBackground()
        self.aChatManager!.currentChat?.setObject("text", forKey: "lastMessage")
        self.aChatManager!.currentChat?.saveInBackground()
        
        self.finishSendingMessage()
    }
    
    //append messages to array of messages
    func addMessage(object:PFObject)
    {
        let user = object["ChatUser"] as! PFUser
        users.append(user as PFUser)
        var senderName = ""
        if let fbName = user.objectForKey("fbName") as? String {
            senderName = fbName
        } else {
            senderName = user.username!
        }
        let mes = OWCChatMessage(text: object["ChatText"] as? String, senderID: senderName, senderDisplayName: senderName, imageUrl: nil,dateSent:object.createdAt!)
        messages.append(mes)
    }
    
    // limits number of messages kept in chat to 50, change if you want more or unlimited
    func deleteOldMessages(){
        
        let query = PFQuery(className: "Messages")
        query.whereKey("ChatID", equalTo: aChatManager!.ChatID)
        query.includeKey("ChatUser")
        query.orderByAscending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                var NumberOfMessages:Int? = objects?.count
                print(NumberOfMessages)
                for items in objects! {
                    NumberOfMessages!--
                    if NumberOfMessages > 50 {
                        items.deleteInBackground()
                    }
                    
                }
                
            }
        }
        
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        //testPush()
        sendPushNotificationToUser(aChatManager!.SentTo, title: (PFUser.currentUser()?.username!)!, message: text,pushType: "message")
        let message = OWCChatMessage(text: text, senderID: senderId, senderDisplayName: senderDisplayName, imageUrl: nil, dateSent:NSDate())
        self.messages.append(message)
        self.sendMessage(text, sender: senderId)
        //JSQSystemSoundPlayer.jsq_playMessageSentSound()
    }
    
    override func didPressAccessoryButton(sender: UIButton!) {
        print("Accessory Button pressed!")
        //self.performSegueWithIdentifier("exitChat", sender: nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        
        if message.senderDisplayName() == self.senderDisplayName {
            return self.outgoingBubbleImageView
        }
        
        return self.incomingBubbleImageView
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
        if message.senderDisplayName() == self.senderDisplayName {
            cell.textView!.textColor = UIColor.whiteColor()
        } else {
            cell.textView!.textColor = UIColor(red: CGFloat(70/255.0), green: CGFloat(70/255.0), blue: CGFloat(70/255.0), alpha: 1)
        }
        
        let attributes = [NSForegroundColorAttributeName: cell.textView!.textColor!, NSUnderlineStyleAttributeName: 1]
        cell.textView!.linkTextAttributes = attributes
        
        return cell
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        
        let message = messages[indexPath.item]
        if message.senderDisplayName() == self.senderDisplayName {
            let avatarImage = maskRoundedImage(self.senderAvatarImage, radius: Float(self.senderAvatarImage.size.width/2),hasBorder: false)
            return JSQMessagesAvatarImage(placeholder: avatarImage)
            
        }else{
            let avatarImage = maskRoundedImage(self.recipientAvatarImage, radius: Float(self.recipientAvatarImage.size.width/2),hasBorder: false)
            return JSQMessagesAvatarImage(placeholder: avatarImage)
        }
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item]
        return NSAttributedString(string:message.senderDisplayName())
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        
        let message = messages[indexPath.item]
        let dateFormatter = NSDateFormatter()
        
        let intervalSinceSent = (message.date_).timeIntervalSinceNow
        //print(abs(Int(intervalSinceSent)))
        if(abs(Int(intervalSinceSent)) > (60 * 60 * 24 * 6)){
            dateFormatter.dateFormat = "EEE, MMM d, h:mm a"
        }else{
            dateFormatter.dateFormat = "EEEE h:mm a"
            
        }
        
        
        
        let dateString = dateFormatter.stringFromDate(message.date_)
        if(indexPath.row > 0){
            let previousDateString = dateFormatter.stringFromDate(messages[indexPath.row - 1].date_)
            if(dateString == previousDateString){
                return nil
            }
        }
        //print(dateString)
        return NSAttributedString(string:(dateString as String))
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        
        
        if(indexPath.row > 0){
            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "EEEE h a"
            let dateString = dateFormatter.stringFromDate(messages[indexPath.row].date_)
            let previousDateString = dateFormatter.stringFromDate(messages[indexPath.row - 1].date_)
            if(dateString == previousDateString){
                return(CGFloat(0.0))
            }
            
        }
        
        let message = messages[indexPath.item]
        if message.senderDisplayName() == senderDisplayName {
            return CGFloat(kJSQMessagesCollectionViewCellLabelHeightDefault * 2)
        }
        return CGFloat(kJSQMessagesCollectionViewCellLabelHeightDefault)
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        if message.senderDisplayName() == senderDisplayName {
            return CGFloat(0.0);
        }
        
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderDisplayName() == message.senderDisplayName() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
   
}
