//
//  OWCMoreProfileDetailViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCMoreProfileDetailViewController: UIViewController {

    @IBOutlet weak var storeLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var bioTextView: UITextView!
    
    var user:PFUser?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if user == nil{
            user = PFUser.currentUser()
        }
        
        if (user!.objectForKey("isAdvisor")! as! Bool == true){
            self.nameLabel.text = "Advisor"
        }else{
             self.nameLabel.text = "Employee"
        }
        let store = user!.objectForKey("associatedStore") as? PFObject
        store!.fetchIfNeededInBackgroundWithBlock {
            (store: PFObject?, error: NSError?) -> Void in
            if error == nil {
               self.storeLabel.text = (store!.objectForKey("City") as! String) + ", " + (store!.objectForKey("State") as! String)
            } else {
                print("error fetching")
            }
        }

        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
