//
//  OWCConnectWalmartTableViewCell.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCConnectWalmartTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpCell(walmartObject:PFObject){
        self.cityLabel.text = walmartObject.objectForKey("City") as? String
        self.addressLabel.text = walmartObject.objectForKey("Address") as? String

    }
    
}
