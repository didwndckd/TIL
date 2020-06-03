//
//  AppDelegate.swift
//  ViewControllerExample
//
//  Created by 양중창 on 2019/11/25.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // 앱실행시 최초 호출되는 메서드 버전에 상관없이 호출하기 때문에 13이상버전에서는 둘다 사용하기 때문에
    // 따로 처리 해줘야함
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *){
            
            
            
        }else{
            
            window = UIWindow(frame: UIScreen.main.bounds)//스크린의 크기 만큼 프레임에게 값을 넘겨준다
            window?.backgroundColor = .white // 백그라운드는 화이트
            window?.rootViewController = ViewController() // 루트뷰 올려준다
            window?.makeKeyAndVisible() // 키...?
            
        }
        
        
        
        
        return true
    }

    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

