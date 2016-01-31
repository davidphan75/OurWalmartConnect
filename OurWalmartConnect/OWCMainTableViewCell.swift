//
//  OWCMainTableViewCell.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit
import ParseUI

class OWCMainTableViewCell: UITableViewCell {

    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var numberOfCommentLabel: UILabel!
    @IBOutlet weak var messageBodyLabel: UILabel!
    @IBOutlet weak var profileImageView: PFImageView!
    @IBOutlet weak var nameAndLocationLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var numberOfUpVoteLabel: UILabel!
    
    var fourmTopic:PFObject?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        profileImageView.layer.cornerRadius = profileImageView.layer.frame.height/2
        profileImageView.clipsToBounds = true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(fourmTopic:PFObject){
        self.titleLabel.text = fourmTopic.objectForKey("title") as? String
        self.numberOfCommentLabel.text = "\(fourmTopic.objectForKey("numberOfComments") as! Int)"
        self.messageBodyLabel.text = fourmTopic.objectForKey("messageBody") as? String
        self.nameAndLocationLabel.text = (fourmTopic.objectForKey("posterName") as! String) + ", " + (fourmTopic.objectForKey("location") as! String)
        self.profileImageView.file = fourmTopic.objectForKey("profileImage") as? PFFile
        self.categoryLabel.text! = fourmTopic.objectForKey("category") as! String
        self.numberOfUpVoteLabel.text = "\(fourmTopic.objectForKey("numberOfUpVotes") as! Int)"
        
        //time?
        //self.timeLabel.text = fourmTopic.objectForKey("createdAt") as! String
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d, h:mm a"
        self.timeLabel.text = dateFormatter.stringFromDate(NSDate())
        

        

        
       
       
        
        
    }
    
    
    @IBAction func upVoteButtonPressed(sender: AnyObject) {
        
    }
}
