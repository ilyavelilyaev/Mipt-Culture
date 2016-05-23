///
//  AppDelegate.swift
//  Mipt Culture
//
//  Created by Ilya Velilyaev on 19.05.16.
//  Copyright © 2016 Ilya Velilyaev. All rights reserved.
//

import UIKit
import Parse
import AVReachability

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var viewController: ViewController?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        viewController = ViewController()
        window!.rootViewController = viewController
        window?.backgroundColor = .whiteColor()
        window!.makeKeyAndVisible()
        
        Parse.setApplicationId("7sxbl8WBmrjAEqrswgv7D56Nzwc11zRv77kFrJkD", clientKey: "Riu2E8kgUnNSknpzTGEDbk7oOl9aCHmXjmhI6PPz")
        PFAnonymousUtils.logInWithBlock { (user: PFUser?, error: NSError?) in
            if error != nil || user == nil {
                print("Anonymous login failed.")
            } else {
                print("Anonymous user logged in.")
            }
        }
        
        if !Reachability.isConnectedToNetwork() {
            NSNotificationCenter.defaultCenter().postNotificationName("connectionFailed", object: nil)
        }
        
        return true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        //Fetcher.updateSavedData()
    }
}

