//
//  OWCChatTableViewCell.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit
import ParseUI

class OWCChatTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var profileImageView: PFImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(chatObject:PFObject){
        self.messageLabel.text = chatObject.objectForKey("lastMessage") as? String
        let users:[String] = (chatObject.objectForKey("users") as! [String])
        if users[0] == (PFUser.currentUser()?.objectForKey("Name") as! String){
            self.nameLabel.text = users[1]
        }else{
            self.nameLabel.text = users[0]

        }
    }
    
}
