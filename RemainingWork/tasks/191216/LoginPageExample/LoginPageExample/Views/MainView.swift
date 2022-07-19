//
//  MainView.swift
//  LoginPageExample
//
//  Created by 양중창 on 2019/12/18.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

protocol MainViewDelegate {
    func buttonAction()
}

class MainView: UIView {
    
    private let label = UILabel()
    private let logOutButton = UIButton(type: .system)
    
    var delegate: MainViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUI() {
        
        addSubview(label)
        addSubview(logOutButton)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        label.topAnchor.constraint(equalTo: topAnchor, constant: 100).isActive = true
        label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        label.text = UserDefaults.standard.string(forKey: "ID")
        
        
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        logOutButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        logOutButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
    }
    
    
    @objc func didTapButton() {
        
        delegate?.buttonAction()
        
    }
    
    
    
}
