//
//  AppDelegate.swift
//  OurWalmartConnect
//
//  Created by David Phan on 1/29/16.
//  Copyright © 2016 David. All rights reserved.
//

import UIKit
import Parse
import ParseFacebookUtilsV4

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // PARSE
        Parse.enableLocalDatastore()
        Parse.setApplicationId("ltIEatWKlMcKO7hsMPcSwkOW8zKRPHfLj66pNQ3E", clientKey:"TLewYWhiWIlrc9UULHZ8NSaJGGC3QHkHfRECuC4C")
        PFFacebookUtils.initializeFacebookWithApplicationLaunchOptions(launchOptions)
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

        // Configure Push Notification
        self.configurePushNotifications(application)
        
        //Keep User logged in until explicitly logging out
        if PFUser.currentUser() != nil {
            let vc = storyboard.instantiateViewControllerWithIdentifier("mainTabBar")
            self.window!.rootViewController = vc
        }
        
        //Set Up Navi and Tab Bar
        setupTabBarGlobal()
        setupNavigationBarGlobal()


        
        return true
    }
    
    //Facebook
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(application, openURL: url, sourceApplication: sourceApplication, annotation: annotation)
    }


    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        //Facebook
        FBSDKAppEvents.activateApp()
        
        //Location Manager, Request to use location
        OWCLocationManager.sharedInstance.startUpdatingLocation()

    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Tab Bar Set Up
    func setupTabBarGlobal() {
        
        UITabBar.appearance().tintColor = UIColor.whiteColor()
        //UITabBar.appearance().barTintColor = UIColor.blueColor()
        
    }
    
    // Naigation Bar Set Up
    func setupNavigationBarGlobal() {
        let titleDict: NSDictionary = [NSForegroundColorAttributeName : UIColor.whiteColor(), NSFontAttributeName : UIFont(name: "Apple SD Gothic Neo", size: 18)!]
        UINavigationBar.appearance().titleTextAttributes = titleDict as? [String : AnyObject]
        UIBarButtonItem.appearance().setTitleTextAttributes(titleDict as? [String : AnyObject], forState: UIControlState.Normal)
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = OWCGreen
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
    }
    
    
    // Configure Push Notifications
    func configurePushNotifications(application: UIApplication) {
        
        if application.respondsToSelector("registerUserNotificationSettings:") {
            // Configure for Alerts,Badge Updates, and Sound
            let userNotificationsTypes: UIUserNotificationType = ([UIUserNotificationType.Alert, UIUserNotificationType.Badge, UIUserNotificationType.Sound])
            let settings = UIUserNotificationSettings(forTypes: userNotificationsTypes, categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Failed to register for push notifications!\nError:\(error.localizedDescription)")
        print(error)
    }
    
    // MARK: - Push Notification Callback
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.setDeviceTokenFromData(deviceToken)
        currentInstallation.channels = ["global"]
        currentInstallation.saveInBackground()
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        print("didReceiveRemoteNotification bloop")
        print(userInfo["pushType"] as? String)
        
        // Handle push notifications when app is active
        if application.applicationState == .Active {
            
            PFPush.handlePush(userInfo)
            //Handle push notification when app is in background
        } else {
            PFPush.handlePush(userInfo)
            
        }
        
        
        NSNotificationCenter.defaultCenter().postNotificationName("recievedMessage", object: self)
        let installation = PFInstallation.currentInstallation()
        installation["user"] = PFUser.currentUser()
        installation.saveInBackground()
    }



}

