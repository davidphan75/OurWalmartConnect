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