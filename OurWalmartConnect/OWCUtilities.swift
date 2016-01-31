//
//  OWCUtilities.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

func maskRoundedImage(image: UIImage, radius: Float, hasBorder:Bool) -> UIImage {
    let imageView: UIImageView = UIImageView(image: image)
    var layer: CALayer = CALayer()
    layer = imageView.layer
    
    layer.masksToBounds = true
    layer.cornerRadius = CGFloat(radius)
    if hasBorder{
        layer.borderWidth = 2
        layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    UIGraphicsBeginImageContext(imageView.bounds.size)
    layer.renderInContext(UIGraphicsGetCurrentContext()!)
    let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return roundedImage
}

func imageResize(imageObj:UIImage, sizeChange:CGSize)-> UIImage {
    
    let hasAlpha = false
    let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
    
    UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
    imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
    
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext() // !!!
    return scaledImage
}

func getUserProfilePicture(user: PFUser, completion: (success: Bool, userImage: UIImage?) -> Void) {
    
    let pictureQuery = PFUser.query()
    pictureQuery!.whereKey("username", equalTo: user.username!)
    
    pictureQuery!.getFirstObjectInBackgroundWithBlock {(object: PFObject?, error: NSError?) -> Void in
        if object != nil {
            
            let file = object?.objectForKey("profilePicture") as? PFFile
            file?.getDataInBackgroundWithBlock({ (imageData:NSData?, error: NSError?) -> Void in
                if error == nil || imageData != nil {
                    let image = UIImage(data:imageData!)
                    completion(success: true, userImage: image!)
                    //println("Successfully downloaded the profile picture")
                } else {
                    let image = UIImage(named: "defaultUserImage")
                    completion(success: false, userImage: image!)
                    //println("The profile picture from User request failed")
                }
            })
            
        } else {
            
            let image = UIImage(named: "defaultUserImage")
            completion(success: false, userImage: image!)
            //println("The profile picture from User request failed")
        }
    }
}

