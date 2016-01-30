//
//  OWCChatListTableViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCChatListTableViewController: UITableViewController {

    var chatDataManager:OWCTableViewDataManager?
    var indexSelected:NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set Up Data Manager
        let query = PFUser.query()
        self.chatDataManager = OWCTableViewDataManager(currentViewController: self, query: query!)
        
        //TableView SetuUp
        tableView.separatorColor = UIColor.whiteColor()
        tableView.registerNib(UINib(nibName: "OWCChatTableViewCell", bundle: nil), forCellReuseIdentifier: "chatCell")

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (self.chatDataManager?.tableViewObjects.count)!
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> OWCChatTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("chatCell", forIndexPath: indexPath) as! OWCChatTableViewCell

        // Configure the cell...
        cell.textLabel?.text = (self.chatDataManager?.tableViewObjects[indexPath.row] as! PFUser).username

        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //Set indexPath and preform segue
        self.indexSelected = indexPath
        self.performSegueWithIdentifier("startChat", sender: nil)
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == "startChat"){
            
            print((self.chatDataManager?.tableViewObjects[(self.indexSelected?.row)!] as! PFUser).username!)
            
            print("index = \(self.indexSelected?.row)")
            let vc = segue.destinationViewController as! OWCChatViewController
            vc.aChatManager = OWCChatManager()
            vc.aChatManager?.setUpChatWith( (self.chatDataManager?.tableViewObjects[(self.indexSelected?.row)!] as! PFUser).username!)
        }
        
    }


}
