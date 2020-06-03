//
//  ViewController.swift
//  SafeAreaExample
//
//  Created by 양중창 on 2019/12/26.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let myView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(myView)
        
        myView.backgroundColor = .green
        
        myView.translatesAutoresizingMaskIntoConstraints = false
        
//        myView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top).isActive = true
//        myView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom).isActive = true
//        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.safeAreaInsets.left).isActive = true
//        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.safeAreaInsets.right).isActive = true
        
        
        
        print("---------------------viewDidLoad---------------------")
        print("safeAreaInsets:", view.safeAreaInsets)
        print("safeAreaLayoutGide", view.safeAreaLayoutGuide)
        print()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print()
        print("---------------------viewDidAppear---------------------")
        print("safeAreaInsets:", view.safeAreaInsets)
        print("safeAreaLayoutGide", view.safeAreaLayoutGuide)
        
        myView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.safeAreaInsets.top).isActive = true
        myView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -view.safeAreaInsets.bottom).isActive = true
        myView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: view.safeAreaInsets.left).isActive = true
        myView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -view.safeAreaInsets.right).isActive = true
        
    }


}

