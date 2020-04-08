//
//  AppDelegate.swift
//  MusicTouch
//
//  Created by Pedro L. Diaz Montilla on 18/3/18.
//  Copyright © 2018 Pedro L. Diaz Montilla. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // Following app attributes are shared within the app
    var appPlayer            = PDMPlayer()
    var appStatus: AppStatus = .foreground

    lazy var dataStore: DataStoreProtocol = DataStore()


	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Disable screen block
        UIApplication.shared.isIdleTimerDisabled = true
        
        // Choose the cell style
        if CommandLine.arguments.contains("-stylelondon") {
            MTCellFactory.shared.style = .london
        }
        else if CommandLine.arguments.contains("-styleparis") {
            MTCellFactory.shared.style = .paris
        }
        else {
            MTCellFactory.shared.style = .paris
        }
        
        if CommandLine.arguments.contains("-test") {
            dataStore = DataStoreMock()
            (dataStore as! DataStoreMock).defaultInitialize()
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.

        self.appPlayer.pauseSong()
        self.appStatus = .background

    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        self.appPlayer.pauseSong()
        self.appStatus = .background
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        self.appStatus = .foreground
        
        if (self.appPlayer.isPlaying()) {
            self.appPlayer.playSong()
        }

    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        self.appStatus = .foreground
        
        if (self.appPlayer.isPlaying()) {
            self.appPlayer.playSong()
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        self.appStatus = .background
        self.appPlayer.pauseSong()
    }


}

