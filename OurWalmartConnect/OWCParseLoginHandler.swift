//
//  OWCParseLoginHandler.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/30/16.
//  Copyright © 2016 David. All rights reserved.
//

import Foundation

enum OWCLoginError {
    case usernameOrPasswordIncorrect
    case usernameOrPasswordEmpty
}

class OWCParseLoginHandler {
    class func signIn(username username: String, password: String, completion: (success: Bool, error: OWCLoginError?) -> Void) {
        let debugMode = true
        
        if username.isEmpty || password.isEmpty {
            completion(success: false, error: .usernameOrPasswordEmpty)
        } else {
            PFUser.logInWithUsernameInBackground(username, password: password, block: { (user: PFUser?, error: NSError?) -> Void in
                // REMOVE BEFORE RELEASE
                if debugMode && error == nil {
                    completion(success: true, error: nil)
                    
                } else if error != nil {
                    completion(success: false, error: .usernameOrPasswordIncorrect)
                    
                }
                }
            )}
    }
    
}