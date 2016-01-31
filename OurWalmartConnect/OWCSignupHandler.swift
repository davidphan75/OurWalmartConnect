//
//  OWCSignupHandler.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

enum OWCSignUpError {
    case storeLocation
    case passwordInvalid
    case passwordNotMatching
    case emailInvalid
    case errorInSignUp
    case advisorCode
}

//Swift func that check the validity of an email
func isValidEmail(testStr:String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
}

class OWCSignUpHandler {
    class func signUp(storeLocation storeLocation: PFObject, password: String, email: String,advisorCode:String,isAdvisor:Bool,name:String,  completion: (success: Bool, error: OWCSignUpError?) -> Void) {
        let debugMode = true
        
        let query = PFQuery(className: "AdvisorCode")
        query.whereKey("code", equalTo: advisorCode)
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if (error == nil){
                if objects!.count == 0 && isAdvisor{
                    completion(success: false, error: .advisorCode)
                }else{
                    
                    
//                    if (let _test:PFObject = storeLocation) {
//                        completion(success: false, error: .storeLocation)
//                    }
                    if email.isEmpty || isValidEmail(email) != true {
                        completion(success: false, error: .emailInvalid)
                    }
                    else if password.isEmpty || password.characters.count < 8 {
                        completion(success: false, error: .passwordInvalid)
                    }
                    else {
                        let newUser = PFUser()
                        newUser.username = email
                        newUser.password = password
                        newUser.email = email
                        newUser.setObject(storeLocation, forKey: "associatedStore")
                        newUser.setObject(name, forKey: "Name")
                        newUser.setObject(isAdvisor, forKey: "isAdvisor")
                        
                        if objects?.count > 0{
                            objects!.first!.deleteInBackground()
                        }
                        newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                            
                            print("here")
                            // REMOVE BEFORE RELEASE
                            if debugMode && error == nil {
                                
                                //associate user with store
                                let relation = storeLocation.relationForKey("users")
                                relation.addObject(PFUser.currentUser()!)
                                storeLocation.saveInBackground()
                                
                                completion(success: true, error: nil)
                            } else if error != nil {
                                print("\(error)")
                                completion(success: false, error: .errorInSignUp)
                                
                            }
                            }
                        )}

                }
            }
        }
        
}
    
}