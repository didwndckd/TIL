//
//  ViewController.swift
//  LoginPageExample
//
//  Created by 양중창 on 2019/12/13.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit


//로그인 페이지
// 로그인 상태 -> 메인 로그인 상태 아니면 -> 로그인 페이지

class LoginViewController: UIViewController {

    
    
     let loginView = LoginView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("LoginViewController: viewDidLoad")
        setLoginView()
        
        
        
//        testView.layer.cornerRadius = testView.frame.size.width/2
        // width == height 일때 한 변의 길이/2 를 cornerRadius값으로 주면 원이 된다
        
        
        
    }
    
    
    func setLoginView() {
        view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        
        loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        loginView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        loginView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        testView.alpha = 0
//        testView.isHidden = true
//        testView.backgroundColor = .black
        
        
//        UIView.animate(withDuration: 3) {
//            self.testView.isHidden = false
//            self.testView.frame.origin.x += 100
//            self.testView.alpha = 1
//            self.testView.backgroundColor = .gray
        }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        loginView.setUI()
    }
        
    

    
    
    func setWindow() {
        
        if #available(iOS 13.0, *){
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = MainViewController()
            
            let sceneDelegate = windowScene.delegate as? SceneDelegate
            sceneDelegate?.window = window
            window.makeKeyAndVisible()
        }
        }else{
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = MainViewController()
            window.makeKeyAndVisible()
            appDelegate.window = window
            
        }
        
    }

}

