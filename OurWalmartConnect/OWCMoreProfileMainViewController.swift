//
//  OWCMoreProfileMainViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit
import ParseUI

class OWCMoreProfileMainViewController: UIViewController {


    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var user:PFUser?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        if user == nil{
            user = PFUser.currentUser()
        }
        self.nameLabel.text = user!.objectForKey("Name") as? String
        self.profileImageView.layer.cornerRadius = self.profileImageView.layer.frame.height/2
        self.profileImageView.clipsToBounds = true
        
        if user?.objectForKey("profileImage") != nil{
            self.profileImageView.file = user?.objectForKey("profileImage") as? PFFile
            self.profileImageView.loadInBackground()
        }else{
            self.profileImageView.image = UIImage(named: "david.jpg")
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
