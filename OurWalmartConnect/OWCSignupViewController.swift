//
//  OWCSignupViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCSignupViewController: UIViewController,UITextFieldDelegate,userDidSelectWalmart,MBProgressHUDDelegate {

    @IBOutlet weak var storeLocationTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var isAdvisor:Bool?
    var advisorCode:String?
    
    var activeField:UITextField?
    var selectedWalmart:PFObject?
    var HUD: MBProgressHUD!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        // Do any additional setup after loading the view.
        
        //Initial varible
        self.isAdvisor = false
        
        //Initialize loading indicator
        HUD = MBProgressHUD(view: self.view)
        view.addSubview(self.HUD)
        HUD.mode = MBProgressHUDModeIndeterminate
        HUD.delegate = self
        
        //Set textfield delegates
        storeLocationTextField.delegate = self
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self


        
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
        HUD.show(true)
        OWCSignUpHandler.signUp(storeLocation: self.selectedWalmart!, password: passwordTextField.text!, email: emailTextField.text!, advisorCode:self.advisorCode!, isAdvisor: self.isAdvisor!, name: self.nameTextField.text!) { (success, error) -> Void in
            if success {
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                    let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("DSCustomTabBarController")
                    self.performSegueWithIdentifier("signedUp", sender: self)
                })
            } else {
                switch error! {
                case .storeLocation:
                    self.HUD.hide(true)
                    let alertController = UIAlertController(title: "Error!", message: "Please select a store location. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                case .emailInvalid:
                    self.HUD?.hide(true)
                    let alertController = UIAlertController(title: "Error!", message: "The email address is invalid. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                case .passwordInvalid:
                    self.HUD?.hide(true)
                    let alertController = UIAlertController(title: "Error!", message: "The password needs to be more than 8 characters. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                case .passwordNotMatching:
                    self.HUD?.hide(true)
                    let alertController = UIAlertController(title: "Error!", message: "The passwords do not match. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                    
                case .advisorCode:
                    self.HUD?.hide(true)
                    let alertView = UIAlertView(title: "Error!", message: "Invalid Advisor Code.", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()

                case .errorInSignUp:
                    self.HUD?.hide(true)
                    let alertView = UIAlertView(title: "Oops!", message: "Something went wrong! Please try again.", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                    
                    
                }
            }
        }

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
