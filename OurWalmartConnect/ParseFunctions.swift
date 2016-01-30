//
//  ParseFunctions.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

func clearRelation(user: PFUser, relationName: String) {
    let relation = user.relationForKey(relationName)
    let query = relation.query()
    
    query.findObjectsInBackgroundWithBlock({(objects, error) -> Void in
        if error == nil {
            for item in objects! {
                relation.removeObject(item )
            }
            
            user.saveInBackground()
        }
    })
}

func registerPFUserForPushNotifications(user:PFUser){
    let installation = PFInstallation.currentInstallation()
    installation["user"] = user
    installation.saveInBackground()
    
}

func subscribeUserToPushNotificationChannel(channelName:String){
    let currentInstallation = PFInstallation.currentInstallation()
    currentInstallation.removeObject(channelName, forKey: "channels")
    currentInstallation.saveInBackground()
}

func sendPushNotificationToUser(recipientId:String, title:String, message:String, pushType:String){
    
    let data = [ "alert": ["title" : title, "body" : message],
        "pushType" : pushType,
        "title" : title]
    
    let userQuery: PFQuery = PFUser.query()!
    userQuery.whereKey("username", equalTo: recipientId)
    
    let query: PFQuery = PFInstallation.query()!
    query.whereKey("user", matchesQuery: userQuery)
    
    let push: PFPush = PFPush()
    push.setQuery(query)
    push.setData(data as [NSObject : AnyObject])
    push.sendPushInBackground()
}

func sendPushNotificationToChannel(channelName:String, message:String){
    let push = PFPush()
    push.setChannel(channelName)
    push.setMessage(message)
    push.sendPushInBackground()
}

func getPFUser(username:String, completion:(foundUser:PFUser) -> Void){
    let usernameQuery = PFQuery(className: "_User")
    usernameQuery.whereKey("username", equalTo: username)
    
    let fbNameQuery = PFQuery(className: "_User")
    fbNameQuery.whereKey("fbName", equalTo: username)
    
    var foundPFUser:PFUser?
    
    let query = PFQuery.orQueryWithSubqueries([fbNameQuery, usernameQuery])
    query.findObjectsInBackgroundWithBlock({(object, error) -> Void in
        if error == nil && object?.count == 1{
            for item in object! {
                foundPFUser = item as? PFUser
            }
        }
        completion(foundUser: foundPFUser!)
    })
    
}
