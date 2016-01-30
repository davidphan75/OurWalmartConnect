//
//  OWCFirstLaunchViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCFirstLaunchViewController: UIViewController {


    var skipNumber = 50 * 16

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print("Skip number: \(skipNumber)")
        self.loadGeoLocations(skipNumber)
        skipNumber += 50

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    @IBAction func SignUpButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toSignUp", sender: self)
    }
    
    func loadGeoLocations(skipNumber:Int){
        
        let query = PFQuery(className: "walmartLocations")
        query.limit = 50
        query.skip = skipNumber
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            print("number of items \(objects?.count)")
            if error == nil {
                
                for items in objects! {
                    
                    let geocoder = CLGeocoder()
                    geocoder.geocodeAddressString((objects![0].objectForKey("Address") as! String)+","+(objects![0].objectForKey("State") as! String), completionHandler: {(placemarks, error) -> Void in
                        print((items.objectForKey("Address") as! String))
                        if((error) != nil){
                            print("Error", error)
                        }
                        if let placemark = placemarks?.first {
                            let coordinates:CLLocation = placemark.location!
                            let location = PFGeoPoint(location: coordinates)
                            items.setValue(location, forKey: "Location")
                            items.saveInBackground()
                            print(coordinates)
                        }else{
                            print("error getting coordinates")
                        }
                    })
                    
                    
                }
                
            }
        }
    }

    
    @IBAction func loginButtonPressed(sender: AnyObject) {
//        let user = PFUser()
//        user.username = "test"
//        user.password = "1"
//        
//        user.signUpInBackgroundWithBlock({ (success, error) -> Void in
//            UIApplication.sharedApplication().endIgnoringInteractionEvents()
//            
//            if error == nil {
//                NSUserDefaults.standardUserDefaults().setBool(true, forKey: "signedUp")
//                NSUserDefaults.standardUserDefaults().setValue(PFUser.currentUser()?.username, forKey: "username")
//              
//            } else {
//
//            }
//        })
    
    
    
    
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
