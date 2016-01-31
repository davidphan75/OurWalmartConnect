//
//  OWCLoginViewController.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit

class OWCLoginViewController: UIViewController, MBProgressHUDDelegate, UITextFieldDelegate  {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var HUD: MBProgressHUD!
    var parentVC:OWCFirstLaunchViewController?

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //Initialize loading indicator
        HUD = MBProgressHUD(view: self.view)
        view.addSubview(self.HUD)
        HUD.mode = MBProgressHUDModeIndeterminate
        HUD.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButtonPressed(sender: AnyObject) {
        


        HUD.show(true)
        OWCParseLoginHandler.signIn(username: emailTextField.text!, password: passwordTextField.text!) { (success, error) -> Void in
            if success {
                //self.parentVC!.performSegueWithIdentifier("loggedIn", sender: nil)
                //self.performSegueWithIdentifier("loggedIn", sender: nil)
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("mainTabBar")
                self.presentViewController(viewController, animated: true, completion: nil)
                
            } else {
                switch error! {
                case .usernameOrPasswordIncorrect:
                    self.HUD.hide(true)
                    let alertController = UIAlertController(title: "Error!", message: "The username or password are incorrect. Please try again.", preferredStyle: UIAlertControllerStyle.Alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alertController, animated: true, completion: nil)
                                        
                case .usernameOrPasswordEmpty:
                    self.HUD?.hide(true)
                    let alertView = UIAlertView(title: "Oops!", message: "Make sure you enter the Username and Password!", delegate: nil, cancelButtonTitle: "OK")
                    alertView.show()
                }
            }
        }

        
        
        
    }
    @IBAction func tappedScreen(sender: AnyObject) {
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    @IBAction func backButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
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
