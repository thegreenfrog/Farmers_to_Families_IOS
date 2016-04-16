//
//  AppDelegate.swift
//  LocalFarming
//
//  Created by Chris Lu on 11/7/15.
//  Copyright © 2015 Bowdoin College. All rights reserved.
//

import UIKit
import Parse
import Bolts

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func getMajorSystemVersion() -> Int {
        return Int(String(Array(arrayLiteral: UIDevice.currentDevice().systemVersion)[0]))!
    }

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // [Optional] Power your app with Local Datastore. For more info, go to
        // https://parse.com/docs/ios_guide#localdatastore/iOS
        Parse.enableLocalDatastore()
        
        // Initialize Parse.
        Parse.setApplicationId("MZRifgaerJuRH5JCWEHQbTsf580wEdYw4LlJr0cR",
            clientKey: "Ep8y9ALEsMN1GhPtidpcpimuVQ36Jh2wgFo9UISm")
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)

//        UIApplication.sharedApplication().registerForRemoteNotifications()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
//        if NSUserDefaults.standardUserDefaults().boolForKey("hasLoginKey") {
//            let tabBarVC = ConsumerTabBarController()
//            self.window?.rootViewController = tabBarVC
//        } else {
            let registerVC = WelcomePageViewController(transitionStyle: .Scroll, navigationOrientation: .Horizontal, options: nil)
            self.window?.rootViewController = registerVC
//        }
        
        /*init some hardcoded farms*/
        //        let rockyClass = PFObject(className: "FarmClass")
        //        rockyClass.setValue("Rocky Ridge Farm", forKey: "farm")
        //        rockyClass.setValue("Bowdoin, Maine", forKey: "location")
        //        let rockyQuery = PFQuery(className: "AvailableProduce")
        //        rockyQuery.whereKey("farm", equalTo: "Rocky Ridge Farm")
        //        let rockyProduceRelation = rockyClass.relationForKey("produce")
        //        rockyQuery.findObjectsInBackgroundWithBlock({ (objects, err) -> Void in
        //            if let produce = objects {
        //                for one in produce {
        //                    rockyProduceRelation.addObject(one)
        //                }
        //            }
        //            rockyClass.saveInBackground()
        //        })
        //
        //        let milkweedClass = PFObject(className: "FarmClass")
        //        milkweedClass.setValue("Milkweed Farms", forKey: "farm")
        //        milkweedClass.setValue("Brunswick, Maine", forKey: "location")
        //        let milkweedQuery = PFQuery(className: "AvailableProduce")
        //        milkweedQuery.whereKey("farm", equalTo: "Milkweed Farms")
        //        let milkweedProduceRelation = milkweedClass.relationForKey("produce")
        //        milkweedQuery.findObjectsInBackgroundWithBlock({ (objects, err) -> Void in
        //            if let produce = objects {
        //                for one in produce {
        //                    milkweedProduceRelation.addObject(one)
        //                }
        //            }
        //            milkweedClass.saveInBackground()
        //        })

        
        return true
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        print("Got token data! \(deviceToken)")
        let trimEnds = {
            deviceToken.description.stringByTrimmingCharactersInSet(
                NSCharacterSet(charactersInString: "<>"))
        }
        let cleanToken = {
            trimEnds().stringByReplacingOccurrencesOfString(" ", withString: "")
        }
        let user = PFUser.currentUser()
        user?.setObject(cleanToken(), forKey: "mobileToken")
        user?.saveInBackground()
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        print("Couldn't register: \(error)")
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
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

