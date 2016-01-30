//
//  OWCSignupHandler.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

enum OWCSignUpError {
    case usernameInvalid
    case passwordInvalid
    case passwordNotMatching
    case emailInvalid
    case errorInSignUp
}

//Swift func that check the validity of an email
func isValidEmail(testStr:String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
}

class OWCSignUpHandler {
    class func signUp(username username: String, password: String, confirmPassword: String, email: String, completion: (success: Bool, error: OWCSignUpError?) -> Void) {
        let debugMode = true
        
        if username.isEmpty || username.characters.count < 5 {
            completion(success: false, error: .usernameInvalid)
        }
        else if email.isEmpty || isValidEmail(email) != true {
            completion(success: false, error: .emailInvalid)
        }
        else if password.isEmpty || password.characters.count < 8 {
            completion(success: false, error: .passwordInvalid)
        }
        else if confirmPassword.isEmpty || confirmPassword != password {
            completion(success: false, error: .passwordNotMatching)
        }
        else {
            let newUser = PFUser()
            newUser.username = username
            newUser.password = password
            newUser.email = email
            
            newUser.signUpInBackgroundWithBlock({ (succeed, error) -> Void in
                
                print("here")
                // REMOVE BEFORE RELEASE
                if debugMode && error == nil {
                    completion(success: true, error: nil)
                } else if error != nil {
                    print("\(error)")
                    completion(success: false, error: .errorInSignUp)
                    
                }
                }
            )}
    }
    
}