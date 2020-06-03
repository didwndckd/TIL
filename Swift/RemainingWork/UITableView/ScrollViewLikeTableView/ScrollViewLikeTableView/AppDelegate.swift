//
//  AppDelegate.swift
//  ScrollViewLikeTableView
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
        
        let tabBarVC = UITabBarController()
        let tableVC = TableViewController()
        let scrollVC = ScrollViewController()
        tableVC.tabBarItem = UITabBarItem(title: "Table", image: nil, tag: 0)
        scrollVC.tabBarItem = UITabBarItem(title: "Scroll", image: nil, tag: 0)
        
        
        tabBarVC.viewControllers = [tableVC, scrollVC]
        
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        
        return true
    }

   


}

