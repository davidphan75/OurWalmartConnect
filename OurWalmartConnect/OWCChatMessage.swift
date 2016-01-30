//
//  OWCChatMessage.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCChatMessage: NSObject,JSQMessageData {
    var text_: String
    var date_: NSDate
    var imageUrl_: String?
    var senderID: String?
    var senderDisName: String?
    var msgHash = UInt(random())
    
    init(text: String?, senderID: String?, senderDisplayName: String?, imageUrl: String?, dateSent:NSDate) {
        self.text_ = text!
        self.senderID = senderID
        self.senderDisName = senderDisplayName
        self.date_ = dateSent
        self.imageUrl_ = imageUrl
    }
    
    func text() -> String! {
        return text_
    }
    
    func senderDisplayName() -> String! {
        return senderDisName
    }
    
    func senderId() -> String! {
        return senderID
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func imageUrl() -> String? {
        return imageUrl_;
    }
    
    func isMediaMessage() -> Bool {
        return false
    }
    
    func messageHash() -> UInt {
        return msgHash
    }
    
    func media() -> JSQMessageMediaData! {
        return JSQPhotoMediaItem()
    }

}
