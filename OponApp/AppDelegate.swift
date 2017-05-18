//
//  AppDelegate.swift
//  OponApp
//
//  Created by Fekete András Demeter on 2016. 08. 13..
//  Copyright © 2016. Fekete András Demeter. All rights reserved.
//

import UIKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var startTime: CFAbsoluteTime?
    var pushTimer: Timer? = nil
    var centerContainer: MMDrawerController?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let notificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        
        _ = self.window!.rootViewController
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let centerViewController = mainStoryboard.instantiateViewController(withIdentifier: "ViewController") as! ViewController
        let leftViewController = mainStoryboard.instantiateViewController(withIdentifier: "LeftSideViewController") as! LeftSideViewController
        let leftSideNav = UINavigationController(rootViewController: leftViewController)
        let centerNav = UINavigationController(rootViewController: centerViewController)
        centerContainer = MMDrawerController(center: centerNav, leftDrawerViewController: leftSideNav) //,rightDrawerViewController:rightNav
        centerContainer!.openDrawerGestureModeMask = MMOpenDrawerGestureMode.panningCenterView;
        centerContainer!.closeDrawerGestureModeMask = MMCloseDrawerGestureMode.panningCenterView;
        window!.rootViewController = centerContainer
        window!.makeKeyAndVisible()

       return true

    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
      //  pushTimer?.invalidate()

        let request = URLRequest(url: URL(string: "http://hostdomain.intra")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let prefs:UserDefaults = UserDefaults.standard
            if (response != nil) {
                let results = (response as! HTTPURLResponse).statusCode
                prefs.set(results, forKey: "INTRANET")
            }else{prefs.set(0, forKey: "INTRANET")}})
        task.resume()

    }
    
    func scheduleLocal() {
        let notification = UILocalNotification()
        notification.fireDate = Date(timeIntervalSinceNow: 10)
        notification.alertBody = "Application was securely logged out!"
        notification.alertAction = "a visszalépéshez."
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    
        let request = URLRequest(url: URL(string: "http://hostdomain.intra")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let prefs:UserDefaults = UserDefaults.standard
            if (response != nil) {
                let results = (response as! HTTPURLResponse).statusCode
                prefs.set(results, forKey: "INTRANET")
            }else{prefs.set(0, forKey: "INTRANET")}})
        task.resume()
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        let appDomain = Bundle.main.bundleIdentifier
        UserDefaults.standard.removePersistentDomain(forName: appDomain!)
        scheduleLocal()

        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

