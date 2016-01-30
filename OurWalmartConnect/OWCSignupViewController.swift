//
//  OWCSignupViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCSignupViewController: UIViewController,UITextFieldDelegate,userDidSelectWalmart {

    @IBOutlet weak var storeLocationTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activeField:UITextField?
    
    
    var selectedWalmart:PFObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.


        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.storeLocationTextField {
            activeField?.resignFirstResponder()
            let vc = storyboard!.instantiateViewControllerWithIdentifier("OWCSelectStoreViewController") as! OWCSelectStoreViewController
            vc.del = self
            vc.modalPresentationStyle = UIModalPresentationStyle.Custom
            
            if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                vc.preferredContentSize = CGSizeMake(500, 550)
                let popover = UIPopoverController(contentViewController: vc)
                popover.presentPopoverFromRect(self.view.frame, inView: self.view, permittedArrowDirections: [], animated: true)
                
            } else {
                self.presentViewController(vc, animated: true, completion: nil)
            }
            
            return false
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.activeField = textField
//
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.dismissLabel.alpha = 1.0
//        })
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
//        activeField = nil
//        
//        UIView.animateWithDuration(0.5, animations: { () -> Void in
//            self.dismissLabel.alpha = 0.0
//        })
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func userDidSelectWalmart(walmart: PFObject) {
        selectedWalmart = walmart
        self.storeLocationTextField.text = (selectedWalmart?.objectForKey("Address") as! String)
    }
    
    
    @IBAction func signUpBUttonPressed(sender: AnyObject) {
        
        
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
