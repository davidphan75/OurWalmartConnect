//
//  OWCChatManager.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCChatManager: NSObject {
    var currentChat:PFObject!
    var messages = [OWCChatMessage]()
    var users = [PFUser]()
    var SentTo:String! = ""
    var ChatID:String! = ""
    var recipientId:String! = ""
    var lastMessageLoaded:PFObject?
    var userChattingWith:PFUser?
    
    func setUpChatWith(otherUser:String){
        self.SentTo = otherUser
        getPFUser(otherUser, completion: {(foundUser) -> Void in
            self.userChattingWith = foundUser
        })
        fetchChatWith(otherUser)
        self.ChatID = getChatIDWith(otherUser)
    }
    
    func fetchChatWith(otherUser:String){
        let user = PFUser.currentUser()
        let query = PFQuery(className: "Chats")
        let ChatID = getChatIDWith(otherUser)
        query.whereKey("user", equalTo: user!)
        query.whereKey("ChatID", equalTo: ChatID)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil){
                if objects!.count == 0{
                    self.createNewChatWith(otherUser)
                }else{
                    self.currentChat = (objects as [PFObject]!)[0]
                }
            }
        }
    }
    
    func createNewChatWith(otherUser:String){
        
        let user = PFUser.currentUser()
        let ChatID = self.getChatIDWith(otherUser)
        //        if(user?.username > otherUser){
        //            ChatID = "\(user?.username)+\(otherUser)"
        //        }else{
        //            ChatID = "\(otherUser)+\(user?.username)"
        //        }
        
        let chat = PFObject(className: "Chats")
        chat["recipientId"] = user!.objectId
        print(user!.objectId)
        chat["user"] = user
        chat["ChatID"] = ChatID
        //chat["Description"] = description
        chat["lastUser"] = PFUser.currentUser()
        
        
       
        getPFUser(otherUser, completion: {(foundUser) -> Void in
            
            let currentUserName = PFUser.currentUser()?.objectForKey("Name") as? String
            let otherUserName = foundUser.objectForKey("Name") as? String
            
            chat["users"] = [currentUserName!,otherUserName!] as [String]
//            (chat["users"] as! PFObject).setObject([currentUserName!,otherUserName!] as [String], forKey: "users")
            chat["lastMessage"] = ""
            chat["counter"] = 0
            
            chat["updatedAction"] = NSDate()
            //chat["url"] = Image
            chat.saveInBackground()
            self.currentChat = chat
        })
    
       
        
    }
    
    func getChatIDWith(otherUser:String)->String{
        
        let user = PFUser.currentUser()
        let currentUserName = user?.username!
        var ChatID:String?
        if(currentUserName! > otherUser){
            ChatID = "\(currentUserName!)+\(otherUser)"
        }else{
            ChatID = "\(otherUser)+\(currentUserName!)"
        }
        
        print("chat id is: \(ChatID!)")
        return ChatID!
    }

}
