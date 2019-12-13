//
//  LoginView.swift
//  LoginPageExample
//
//  Created by 양중창 on 2019/12/13.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class LoginView: UIView {

    let logo = UIImageView()
    let quadrangle = UIView()
    let quadrangle1 = UIView()
    let quadrangle2 = UIView()
    let quadrangleStackView = UIView()
    
    let loginStackView = UIView()
    let idTextField = UITextField()
    let idUnderLine = UIView()
    let pwTextField = UITextField()
    let pwUnderLine = UIView()
    let signUpButton = UIButton(type: .system)
    let idimage = UIImageView()

    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("LoginView: init")
        
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
        
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
     func setUI() {
        
        addSubview(logo)
        logo.image = UIImage(named: "fastcampus_logo")
        let logoMargin:CGFloat = 60
        logo.contentMode = .scaleAspectFill // 이미지 오토레이아웃 사이즈에 맞게 조정
        
        //logo AutoLayout
        logo.translatesAutoresizingMaskIntoConstraints = false
        logo.topAnchor.constraint(equalTo: topAnchor, constant: logoMargin).isActive = true
        logo.leadingAnchor.constraint(equalTo: leadingAnchor, constant: logoMargin).isActive = true
        logo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -logoMargin).isActive = true
        
        if let image = logo.image {
        logo.bounds.size.height = image.size.height
        
        }else{
            logo.bounds.size.height = 0
        }
        
        
        
        
        
        
        // quadrangle AutoLayout
        let quadrangleTopMargin: CGFloat = 30
        
        
        quadrangleStackView.translatesAutoresizingMaskIntoConstraints = false
        quadrangle.translatesAutoresizingMaskIntoConstraints = false
        quadrangle1.translatesAutoresizingMaskIntoConstraints = false
        quadrangle2.translatesAutoresizingMaskIntoConstraints = false
        
        quadrangleStackView.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: quadrangleTopMargin).isActive = true
        
        quadrangleStackView.widthAnchor.constraint(equalTo: logo.widthAnchor, multiplier: 0.4).isActive = true
       
        quadrangleStackView.heightAnchor.constraint(equalTo: logo.heightAnchor, multiplier: 0.7).isActive = true
        
        quadrangleStackView.centerXAnchor.constraint(equalToSystemSpacingAfter: logo.centerXAnchor, multiplier: 1).isActive = true
        
        let radius: CGFloat = 7
        
        quadrangle.leadingAnchor.constraint(equalTo: quadrangleStackView.leadingAnchor, constant: 0).isActive = true
        quadrangle.widthAnchor.constraint(equalTo: quadrangleStackView.heightAnchor, multiplier: 1).isActive = true
        quadrangle.heightAnchor.constraint(equalTo: quadrangleStackView.heightAnchor, multiplier: 1).isActive = true
        quadrangle.layer.cornerRadius = radius
        
        quadrangle1.centerXAnchor.constraint(equalToSystemSpacingAfter: quadrangleStackView.centerXAnchor, multiplier: 1).isActive = true
        quadrangle1.widthAnchor.constraint(equalTo: quadrangleStackView.heightAnchor, multiplier: 1).isActive = true
        quadrangle1.heightAnchor.constraint(equalTo: quadrangleStackView.heightAnchor, multiplier: 1).isActive = true
        quadrangle1.layer.cornerRadius = radius
        
        quadrangle2.trailingAnchor.constraint(equalTo: quadrangleStackView.trailingAnchor, constant: 0).isActive = true
        quadrangle2.widthAnchor.constraint(equalTo: quadrangleStackView.heightAnchor, multiplier: 1).isActive = true
        quadrangle2.heightAnchor.constraint(equalTo: quadrangleStackView.heightAnchor, multiplier: 1).isActive = true
        quadrangle2.layer.cornerRadius = radius
        
        print(quadrangleStackView.frame)
        
        //quadrangle AutoLayout
        
        
        
        //signupButton AutoLayout
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        let signupButtonMargin: CGFloat = 20
        
        
        
        signUpButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: signupButtonMargin).isActive = true
        
        signUpButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -signupButtonMargin).isActive = true
        
        signUpButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -logoMargin*2+10).isActive = true
        
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
        loginStackView.topAnchor.constraint(equalTo: centerYAnchor, constant: loginMargin).isActive = true
        
        loginStackView.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: 0).isActive = true
        
//        loginStackView.backgroundColor = .red
        
        
        idimage.image = UIImage(named: "email")
        
        
        
        idTextField.topAnchor.constraint(equalTo: loginStackView.topAnchor, constant: 0).isActive = true
        idTextField.leadingAnchor.constraint(equalTo: loginStackView.leadingAnchor, constant: 0).isActive = true
        idTextField.trailingAnchor.constraint(equalTo: loginStackView.trailingAnchor, constant: 0).isActive = true
        
        
        idTextField.placeholder = "이메일을 입력하세요"
        idTextField.font = .systemFont(ofSize: 20)
        idTextField.leftViewMode = .always
        idTextField.leftView = idimage
        idTextField.borderStyle = .bezel
        
    }
    
    
    

    
    
    
    
    
}
