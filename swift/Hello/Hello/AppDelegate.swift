//
//  AppDelegate.swift
//  Hello
//
//  Created by 양중창 on 2019/11/21.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit



@UIApplicationMain // 메인함수를 대신함
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        print("didFinishLaunchingWithOptions")
        // Override point for customization after application launch.
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }
    func applicationWillTerminate(_ application: UIApplication) {
        print("WillTerminate")
    }
    
}
