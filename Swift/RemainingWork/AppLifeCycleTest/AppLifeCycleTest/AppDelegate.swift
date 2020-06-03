//
//  AppDelegate.swift
//  AppLifeCycleTest
//
//  Created by 양중창 on 2019/11/28.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let tag = "AppDelegate : "

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print(tag+"윌 피니쉬 런칭 위드 옵션스 - 앱의 실행 준비가 끝나기 직전 호출")
        return true
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        print(tag+"디드 피니쉬 런칭 위드 옵션스 - 앱의 실행 준비가 끝난후 사용자에게 화면이 보여지기 직전")
        
        window = UIWindow(frame: UIScreen.main.bounds) // 기기의 화면에 프레임을 맞추는듯
        window?.backgroundColor = .white  // 윈도우의 백그라운드를 흰색으로 한다
        window?.rootViewController = ViewController() // 루트뷰를 뷰 컨트롤러 객체로 한다
        window?.makeKeyAndVisible() //메인 윈도우를 얘로 쓰겠다
        
        return true
    }

    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        print(tag+"디드 비컴 액티브 - 앱이 Active상태로 진입하고난 직후 호출")
//        App이 active 상태로 진입하고 난 직후 호출됩니다. 주로 App이 실제로 사용되기 전에 마지막으로 준비할 수 있는 코드를 작성합니다.
//        App State : In-Active -> Active
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        print(tag+"윌 리싸인 액티브 - Active -> in-Active 상태로 진입하기 직전 호출")
//        App이 Active에서 In-Active 상태로 진입하기 직전에 호출됩니다. 주로 App이 quiescent(조용한) 상태로 변환될 때의 작업을 진행합니다.
//        App State : Active -> In-Active
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        print(tag+"디드 앤터 백그라운드 - 앱이 백그라운드 상태에 진입한 직후 호출 ")
//        App이 background 상태에 진입한 직후 호출됩니다.
//        App이 Suspended 상태로 진입하기 전에 중요한 데이터를 저장하거나 점유하고 있는 공유 자원을 해제하는 등
//        종료되기 전에 필요한 준비 작업을 진행합니다. 특별한 처리가 없으면 background 상태에서 suspended 상태로 전환됩니다.
//        App이 종료된 이후 다시 실행될 때 직전 상태를 복구할 수 있는 정보를 저장할 수 있습니다.
//        App State : In-Active -> Background
    }
    func applicationWillEnterForeground(_ application: UIApplication) {
        print(tag+"윌 엔터 포그라운드 - 앱이 백그라운드상태에서 포그라운드 상태로 돌아오기 직전 호출")
//        App이 Background에서 Foreground로 돌아오기 직전 호출됩니다.
//        App State : Background -> In-Active
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        print(tag+"윌 터미네이티드 - 앱이 종료되기 직전에 호출한다")
//        메모리 확보를 위해 Suspended 상태에 있는 app을 종료시킬 때
//        사용자가 multitasking UI를 통해 종료할 때
//        오류로 인해 app이 종료될 때
//        Deivce를 재부팅할 때
    }
    
    
    
    
    
    
    


}

