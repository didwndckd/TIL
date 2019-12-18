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
    
    var keyboardState = false
    var originY: CGFloat?

    let loginView = LoginView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.string(forKey: "ID") != nil {
            setWindow()
        }
        
        print("LoginViewController: viewDidLoad")
        setLoginView()
        loginView.idTextField.delegate = self
        loginView.pwTextField.delegate = self
        loginView.delegate = self
        view.backgroundColor = .black
        
//        testView.layer.cornerRadius = testView.frame.size.width/2
        // width == height 일때 한 변의 길이/2 를 cornerRadius값으로 주면 원이 된다
        
        
       
        
    }
    
    
    
    
        
    
   
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        
        
    }
    
    

    
    

    
    
    func setLoginView() {
        view.addSubview(loginView)
        loginView.translatesAutoresizingMaskIntoConstraints = false
        loginView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        loginView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        loginView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        loginView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
                
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("touchesEnded()")
        loginView.endEditing(true)
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
       // print("viewWillLayoutSubviews")
         //loginView.setUI()
        
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

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        //print("aaa")
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard var text = textField.text else {return false}
        
        if text.count > 16 {
            
            text.remove(at: text.index(before: text.endIndex))
            textField.text = text
            
            return false
        }else {
            return true
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.tag == 0 {
            loginView.pwTextField.becomeFirstResponder()
            return true
        }else {
            loginView.pwTextField.endEditing(true)
            return true
        }
    }
    
    
}

extension LoginViewController: LoginViewDelegate {
    func buttonAction() {
        if let id = loginView.idTextField.text, let pw = loginView.pwTextField.text {
            if id == pw {
                UserDefaults.standard.set(id, forKey: "ID")
                setWindow()
                
            }else {
                loginView.idTextField.backgroundColor = UIColor.withAlphaComponent(.red)(0.5)
                loginView.pwTextField.backgroundColor = UIColor.withAlphaComponent(.red)(0.5)
                UIView.animate(withDuration: 0.5) {
                    self.loginView.idTextField.backgroundColor = .white
                    self.loginView.pwTextField.backgroundColor = .white
                }
            }
        }
    }
    
    
    
    
    
}

