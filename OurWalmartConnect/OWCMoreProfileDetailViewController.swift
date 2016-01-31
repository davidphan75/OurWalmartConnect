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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let store = PFUser.currentUser()?.objectForKey("associatedStore") as! PFObject
        self.storeLabel.text = (store.objectForKey("City") as! String) + ", " + (store.objectForKey("State") as! String)
        
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
