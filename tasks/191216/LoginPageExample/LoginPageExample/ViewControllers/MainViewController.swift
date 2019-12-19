//
//  SecondViewController.swift
//  LoginPageExample
//
//  Created by 양중창 on 2019/12/13.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    let mainView = MainView(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView)
        
        mainView.delegate = self
        setMainView()
    }
    
    func setWindow() {
        if #available(iOS 13.0, *){
            
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = LoginViewController()
                let sceneDelegate = windowScene.delegate as? SceneDelegate
                sceneDelegate?.window = window
                window.makeKeyAndVisible()
            }
            
        }else {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let window = UIWindow(frame: UIScreen.main.bounds)
            window.rootViewController = LoginViewController()
            window.makeKeyAndVisible()
            appDelegate.window = window
        }
        
    }
    
    
    func setMainView() {
        mainView.translatesAutoresizingMaskIntoConstraints = false
        
        mainView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mainView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mainView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        mainView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }

}


extension MainViewController: MainViewDelegate {
    func buttonAction() {
        UserDefaults.standard.set(nil, forKey: "ID")
        setWindow()
    }
    
    
}
