//
//  OWCPostFourmPage1ViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/31/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCPostFourmPage1ViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var mainBodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func nextButtonPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("toSecondPage", sender: self)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSecondPage"{
            let fourmPost = PFObject(className: "fourmTopic")
            fourmPost.setObject(self.mainBodyTextView.text, forKey: "messageBody")
            fourmPost.setObject(self.titleTextField.text!, forKey: "title")
            fourmPost.setObject((PFUser.currentUser()?.objectForKey("Name") as! String), forKey: "posterName")
            fourmPost.setObject((PFUser.currentUser()?.objectForKey("Name") as! String), forKey: "posterName")
            
//            let store = PFUser.currentUser()?.objectForKey("associatedStore") as? PFObject
//            store!.fetchIfNeededInBackgroundWithBlock {
//                (store: PFObject?, error: NSError?) -> Void in
//                if error == nil {
//                    let location = store?.objectForKey("City") as String)
//                    fourmPost.setObject((PFUser.currentUser()?.objectForKey("location") as! String), forKey: "location")
//
//                } else {
//                    print("error fetching")
//                }
//            }
            
            
            
        }
    }
    

}
