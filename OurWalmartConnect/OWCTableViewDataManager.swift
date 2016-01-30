//
//  OWCTableViewDataManager.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation


class OWCTableViewDataManager: NSObject, MBProgressHUDDelegate {
    
    var currentViewController: UITableViewController?
    var tableViewObjects = [AnyObject]()
    var HUD: MBProgressHUD!
    var query:PFQuery?
    
    init(currentViewController: UITableViewController, query:PFQuery) {
        super.init()
        self.currentViewController = currentViewController
        self.query = query
        self.setUpHUD()
        self.loadDataFromQuery()
        
    }
    
    func setUpHUD(){
        HUD = MBProgressHUD(view: self.currentViewController!.view)
        self.currentViewController!.view.addSubview(HUD)
        HUD.delegate = self
        
    }
    
    func loadDataFromQuery(){
        HUD.show(true)
        self.query!.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                self.tableViewObjects = objects!
                print(objects?.count)
            }
            self.HUD.hide(true)
            self.currentViewController?.tableView.reloadData()
        }
        
    }
    

}