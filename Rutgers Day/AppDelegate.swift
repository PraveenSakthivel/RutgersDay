//
//  AppDelegate.swift
//  Rutgers Day
//
//  Created by Praveen Sakthivel on 12/23/17.
//  Copyright © 2017 TBLE Technologies. All rights reserved.
//

import UIKit
import UserNotifications
import Alamofire
import MapKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate{

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if launchedBefore  {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "mainController")
        }
        else {
            self.window?.rootViewController = storyboard.instantiateViewController(withIdentifier: "start_screen") 
        }
        self.window?.makeKeyAndVisible()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        let locationManager = CLLocationManager()
        var loc = CLLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        if(locationManager.location != nil){
            loc = locationManager.location!
        }
        let code = UserDefaults.standard.integer(forKey: "UID")
        let headers: HTTPHeaders = ["REDACTED"]
        Alamofire.request("https://api.rutgersday.rutgers.edu/analytics?long=\(loc.coordinate.longitude)&lat=\(loc.coordinate.latitude)&UID=IOS-\(code)",headers: headers).responseJSON {
            response in
        }
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

}

