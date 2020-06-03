//
//  AppDelegate.swift
//  DominoUpdate
//
//  Created by 양중창 on 2020/01/29.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        
        window?.rootViewController = MainTabBarViewController()
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        return true
    }

    

}

