//
//  OWCFirstLaunchViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCFirstLaunchViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

 
    @IBAction func SignUpButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toSignUp", sender: self)
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
