//
//  LoginView.swift
//  LoginPageExample
//
//  Created by 양중창 on 2019/12/13.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

protocol LoginViewDelegate {
    func buttonAction()
}

class LoginView: UIView {

    let logo = UIImageView()
    let quadrangle = UIView()
    let quadrangle1 = UIView()
    let quadrangle2 = UIView()
    let quadrangleStackView = UIView()
    
    let loginStackView = UIView()
    let idTextField = LoginTextField()
    let idUnderLine = UIView()
    let pwTextField = LoginTextField()
    let pwUnderLine = UIView()
    let signUpButton = UIButton(type: .system)
    let idimage = UIImageView()
    let pwimage = UIImageView()
    
    var delegate: LoginViewDelegate?

    var loginStackViewYConstraint: NSLayoutConstraint?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("LoginView: init")
        backgroundColor = .white
        addSubview(logo)
        
        addSubview(quadrangleStackView)
        quadrangleStackView.addSubview(quadrangle)
        quadrangleStackView.addSubview(quadrangle1)
        quadrangleStackView.addSubview(quadrangle2)
        quadrangle.backgroundColor = .red
        quadrangle1.backgroundColor = .red
        quadrangle2.backgroundColor = .red
        
        addSubview(loginStackView)
        loginStackView.addSubview(idTextField)
        loginStackView.addSubview(idUnderLine)
        loginStackView.addSubview(pwTextField)
        loginStackView.addSubview(pwUnderLine)
        idUnderLine.backgroundColor = .black
        pwUnderLine.backgroundColor = .black
        
        addSubview(signUpButton)
        signUpButton.backgroundColor = .darkGray
        signUpButton.layer.cornerRadius = 7
        signUpButton.tintColor = .white
        signUpButton.setTitle("Sign In", for: .normal)
        signUpButton.titleLabel?.font = .systemFont(ofSize: 23)
        signUpButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        setUI()
        
        
            NotificationCenter.default.addObserver(self,
            selector: #selector(keyboardWillShowHandle(keyboardShowNotification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowHandle(keyboardShowNotification:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
               
        
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        delegate?.buttonAction()
    }
    
    @objc func keyboardWillShowHandle(keyboardShowNotification notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let keyboardRectangle = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            
            if notification.name == UIResponder.keyboardWillShowNotification {
                loginStackViewYConstraint?.isActive = false

                            loginStackViewYConstraint = loginStackView.bottomAnchor.constraint(
                                equalTo: superview?.bottomAnchor ?? bottomAnchor,
                                constant: -keyboardRectangle.height - 10)
                            
                            UIView.animate(withDuration: 0.5, animations: {
                                self.loginStackViewYConstraint?.isActive = true
                                
                                self.layoutIfNeeded()
                                print("animate")
               
                            })
            }else {
                loginStackViewYConstraint?.isActive = false
                loginStackViewYConstraint = loginStackView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -10)
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.loginStackViewYConstraint?.isActive = true
                    self.layoutIfNeeded()
                })
                
            }
            
            
            
            
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
     func setUI() {
        
        
       
        
          logo.image = UIImage(named: "fastcampus_logo")
              let logoMargin:CGFloat = 60
              logo.contentMode = .scaleAspectFill // 이미지 오토레이아웃 사이즈에 맞게 조정
              
              //logo AutoLayout
              logo.translatesAutoresizingMaskIntoConstraints = false
              logo.topAnchor.constraint(equalTo: topAnchor, constant: logoMargin).isActive = true
              logo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: logoMargin).isActive = true
              logo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -logoMargin).isActive = true

        
        // quadrangle AutoLayout
        let quadrangleTopMargin: CGFloat = 30
        
        
        quadrangleStackView.translatesAutoresizingMaskIntoConstraints = false
        quadrangle.translatesAutoresizingMaskIntoConstraints = false
        quadrangle1.translatesAutoresizingMaskIntoConstraints = false
        quadrangle2.translatesAutoresizingMaskIntoConstraints = false
        
        quadrangleStackView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: quadrangleTopMargin).isActive = true
        
        quadrangleStackView.widthAnchor.constraint(equalTo: logo.widthAnchor, multiplier: 0.4).isActive = true
       
        quadrangleStackView.heightAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 0.7).isActive = true
        
        quadrangleStackView.centerXAnchor.constraint(equalTo: logo.centerXAnchor).isActive = true
        
        
        
        let radius: CGFloat = 7
        
        quadrangle.leadingAnchor.constraint(equalTo: quadrangleStackView.leadingAnchor, constant: 0).isActive = true
        quadrangle.topAnchor.constraint(equalTo: quadrangleStackView.topAnchor).isActive = true
        quadrangle.widthAnchor.constraint(equalTo: quadrangleStackView.heightAnchor).isActive = true
        quadrangle.heightAnchor.constraint(equalTo: quadrangleStackView.heightAnchor).isActive = true
        quadrangle.layer.cornerRadius = radius
        
        quadrangle1.topAnchor.constraint(equalTo: quadrangleStackView.topAnchor).isActive = true
        quadrangle1.centerXAnchor.constraint(equalTo: quadrangleStackView.centerXAnchor).isActive = true
        quadrangle1.widthAnchor.constraint(equalTo: quadrangleStackView.heightAnchor).isActive = true
        quadrangle1.heightAnchor.constraint(equalTo: quadrangleStackView.heightAnchor).isActive = true
        quadrangle1.layer.cornerRadius = radius
        
        quadrangle2.topAnchor.constraint(equalTo: quadrangleStackView.topAnchor).isActive = true
        quadrangle2.trailingAnchor.constraint(equalTo: quadrangleStackView.trailingAnchor, constant: 0).isActive = true
        quadrangle2.widthAnchor.constraint(equalTo: quadrangleStackView.heightAnchor).isActive = true
        quadrangle2.heightAnchor.constraint(equalTo: quadrangleStackView.heightAnchor).isActive = true
        quadrangle2.layer.cornerRadius = radius
        
        //print(quadrangleStackView.frame)
        
        //quadrangle AutoLayout
        
        
        
        //signupButton AutoLayout
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        let signupButtonMargin: CGFloat = 20
        
        
        
        signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: signupButtonMargin).isActive = true
        
        signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -signupButtonMargin).isActive = true
        
        signUpButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -logoMargin * 2 + 10).isActive = true
        
        let signUpbuttonTitleMargin: CGFloat = 13
        signUpButton.titleLabel?.topAnchor.constraint(equalTo: signUpButton.topAnchor, constant: signUpbuttonTitleMargin).isActive = true
        signUpButton.titleLabel?.bottomAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: -signUpbuttonTitleMargin).isActive = true
        
        
        
        
        
        //signupButton AutoLayout
        
        
        //Login Field
        let loginMargin: CGFloat = 10
        
        loginStackView.translatesAutoresizingMaskIntoConstraints = false
        idTextField.translatesAutoresizingMaskIntoConstraints = false
        idUnderLine.translatesAutoresizingMaskIntoConstraints = false
        pwTextField.translatesAutoresizingMaskIntoConstraints = false
        pwUnderLine.translatesAutoresizingMaskIntoConstraints = false
        
        loginStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: loginMargin).isActive = true
        loginStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -loginMargin).isActive = true
        
        
        loginStackViewYConstraint = loginStackView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -10)
        loginStackViewYConstraint?.isActive = true
        
        
        
//        loginStackView.backgroundColor = .red
        
         
        
        idTextField.topAnchor.constraint(equalTo: loginStackView.topAnchor, constant: 0).isActive = true
        idTextField.leadingAnchor.constraint(equalTo: loginStackView.leadingAnchor, constant: 0).isActive = true
        idTextField.trailingAnchor.constraint(equalTo: loginStackView.trailingAnchor, constant: 0).isActive = true
        
        idTextField.keyboardType = .emailAddress
        idTextField.placeholder = "이메일을 입력하세요"
        idTextField.font = .systemFont(ofSize: 25)
        idimage.image = UIImage(named: "email")
        idTextField.leftView = idimage
        idTextField.leftViewMode = .always
        idTextField.tag = 0
        
        
        idUnderLine.translatesAutoresizingMaskIntoConstraints = false
        idUnderLine.topAnchor.constraint(equalTo: idTextField.bottomAnchor, constant: 6).isActive = true
        idUnderLine.trailingAnchor.constraint(equalTo: idTextField.trailingAnchor, constant: -10).isActive = true
        idUnderLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        idUnderLine.leadingAnchor.constraint(equalTo: idTextField.leadingAnchor, constant: 10 + (idTextField.leftView?.intrinsicContentSize.width ?? 0)).isActive = true
        
        
        
        pwTextField.translatesAutoresizingMaskIntoConstraints = false
        pwTextField.topAnchor.constraint(equalTo: idUnderLine.bottomAnchor, constant: 20).isActive = true
        pwTextField.leadingAnchor.constraint(equalTo: loginStackView.leadingAnchor).isActive = true
        pwTextField.trailingAnchor.constraint(equalTo: loginStackView.trailingAnchor).isActive = true
        
        
        pwTextField.keyboardType = .default
        pwTextField.placeholder = "비밀번호를 입력하세요"
        pwTextField.font = .systemFont(ofSize: 25)
        pwimage.image = UIImage(named: "password")
        pwTextField.leftView = pwimage
        pwTextField.leftViewMode = .always
        pwTextField.isSecureTextEntry = true
        pwTextField.tag = 1
        
        pwUnderLine.topAnchor.constraint(equalTo: pwTextField.bottomAnchor, constant: 6).isActive = true
        pwUnderLine.trailingAnchor.constraint(equalTo: pwTextField.trailingAnchor, constant: -10).isActive = true
        
        pwUnderLine.leadingAnchor.constraint(equalTo: pwTextField.leadingAnchor, constant: 10 + (pwTextField.leftView?.intrinsicContentSize.width ?? 0)).isActive = true
        
        pwUnderLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        pwUnderLine.bottomAnchor.constraint(equalTo: loginStackView.bottomAnchor).isActive = true
        
//        loginStackView.backgroundColor = .red
        
                
    }
    
    
    

    
    
    
    
    
}
