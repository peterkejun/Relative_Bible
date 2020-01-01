//
//  AppDelegate.swift
//  Bible
//
//  Created by Jun Ke on 7/31/19.
//  Copyright © 2019 Pierre Beasley. All rights reserved.
//

import UIKit
//import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

//    let FacebookURLScheme = "fb{2429419230665704}"
//    let WeChatURLScheme = "wx625eabfe9f7b878e"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//
//        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
//        WXApi.registerApp(self.WeChatURLScheme)
        
        BibleData.load()
        UserData.load()
        NetworkManager.load()
        
//        let navBarAppearance = UINavigationBar.appearance()
//        navBarAppearance.tintColor = UIColor.black
//        navBarAppearance.barTintColor = UIColor.barTintColor
//        let tabBarAppearance = UITabBar.appearance()
//        tabBarAppearance.tintColor = UIColor.black
//        tabBarAppearance.barTintColor = UIColor.barTintColor
//        let toolBarAppearance = UIToolbar.appearance()
//        toolBarAppearance.tintColor = UIColor.black
//        toolBarAppearance.barTintColor = UIColor.barTintColor
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            self.window?.tintColor = UIColor.systemIndigo
        } else {
            self.window?.tintColor = UIColor.init(red: 88/255, green: 86/255, blue: 214/255, alpha: 1.0)
        }
        self.window?.rootViewController = TabBarController.init()
        self.window?.makeKeyAndVisible()
        
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        if url.scheme == FacebookURLScheme {
//            return FBSDKApplicationDelegate.sharedInstance().application(app, open: url, options: options)
//        } else if url.scheme == WeChatURLScheme {
//            return WXApi.handleOpen(url, delegate: self)
//        }
        return false
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        //change
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

