//
//  ViewController.swift
//  AutolayoutExample
//
//  Created by 양중창 on 2019/12/12.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let leadingView = UIView()
    let trailingView = UIView()
    let grayView = UIView()
    let greenView = UIView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        leadingView.backgroundColor = .red
        trailingView.backgroundColor = .blue
        grayView.backgroundColor = .gray
        greenView.backgroundColor = .green
        
        view.addSubview(grayView)
        view.addSubview(greenView)
        view.addSubview(trailingView)
        view.addSubview(leadingView)
    }
    
    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        
        
//        frameSet()
//        autoLayout()
//        autoLayout2()
        autoLayout3()
        
        

       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear")
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        print("viewWillLayoutSubviews")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        print("viewDidLayoutSubview")
    }
    
    func autoLayout() {
        
        
        let margin: CGFloat = 20
        
        leadingView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        leadingView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: margin).isActive = true
        
        leadingView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: margin).isActive = true
        
        leadingView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -margin).isActive = true
        
//        leadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -safetiAreaRight-20).isActive = true
        
        
        trailingView.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        trailingView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: margin).isActive = true
        
        trailingView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -margin).isActive = true
        
        trailingView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -margin).isActive = true
        
        trailingView.leadingAnchor.constraint(
            equalTo: leadingView.trailingAnchor,
            constant: 10).isActive = true
        
        leadingView.widthAnchor.constraint(
        equalTo: trailingView.widthAnchor,
        multiplier: 1).isActive = true
        
        trailingView.widthAnchor.constraint(
        equalTo: leadingView.widthAnchor,
        multiplier: 1).isActive = true
        
        print(leadingView.bounds.size.width)
        
        
        
        
    }
    
    func autoLayout2() {
        
        leadingView.translatesAutoresizingMaskIntoConstraints = false
        
        leadingView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: 20).isActive = true
        
        leadingView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -20).isActive = true
        
        leadingView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: 20).isActive = true
        
        leadingView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: (-view.safeAreaLayoutGuide.layoutFrame.width/2)-5 ).isActive = true
        
        trailingView.translatesAutoresizingMaskIntoConstraints = false
        
        trailingView.heightAnchor.constraint(
            equalTo: leadingView.heightAnchor,
            multiplier: 1).isActive = true
        
        trailingView.topAnchor.constraint(
            equalTo: leadingView.topAnchor,
            constant: 0).isActive = true
        
        trailingView.widthAnchor.constraint(
            equalTo: leadingView.widthAnchor,
            multiplier: 1).isActive = true
        
        trailingView.leadingAnchor.constraint(
            equalTo: leadingView.trailingAnchor,
            constant: 10).isActive = true
        
        
        
        
    }
    
    func autoLayout3() {
        
        let margin: CGFloat = 30
        let between: CGFloat = 20
        
        leadingView.translatesAutoresizingMaskIntoConstraints = false
        trailingView.translatesAutoresizingMaskIntoConstraints = false
        grayView.translatesAutoresizingMaskIntoConstraints = false
        greenView.translatesAutoresizingMaskIntoConstraints = false
        
        leadingView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: margin).isActive = true
        
        leadingView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: margin).isActive = true
        
        
        trailingView.topAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.topAnchor,
            constant: margin).isActive = true
        
        trailingView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -margin).isActive = true
        
        grayView.leadingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.leadingAnchor,
            constant: margin).isActive = true
        
        grayView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -margin).isActive = true
        
        greenView.trailingAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.trailingAnchor,
            constant: -margin).isActive = true
        
        greenView.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: -margin).isActive = true
        
        trailingView.leadingAnchor.constraint(
            equalTo: leadingView.trailingAnchor,
            constant: between).isActive = true
        
        greenView.topAnchor.constraint(
            equalTo: trailingView.bottomAnchor,
            constant: between).isActive = true
        
        grayView.trailingAnchor.constraint(
            equalTo: greenView.leadingAnchor,
            constant: -between).isActive = true
        
        leadingView.bottomAnchor.constraint(
            equalTo: grayView.topAnchor,
            constant: -between).isActive = true
        
        trailingView.widthAnchor.constraint(
            equalTo: leadingView.widthAnchor,
            multiplier: 1).isActive = true
        
        greenView.heightAnchor.constraint(
            equalTo: trailingView.heightAnchor,
            multiplier: 1).isActive = true
        
        grayView.widthAnchor.constraint(
            equalTo: greenView.widthAnchor,
            multiplier: 1).isActive = true
        
        leadingView.heightAnchor.constraint(
            equalTo: grayView.heightAnchor,
            multiplier: 1).isActive = true
        
        
        
        
        
        
        
        
    }
    
    func frameSet() {
        print(view.safeAreaInsets)
               
               leadingView.frame = CGRect(x: view.safeAreaInsets.left + 20,
                                          y: view.safeAreaInsets.top + 20,
                                          width: (view.safeAreaLayoutGuide.layoutFrame.width-50)/2,
                                          height: view.safeAreaLayoutGuide.layoutFrame.height-40)
               leadingView.backgroundColor = . red
               
               
               trailingView.frame = CGRect(
                                           x: leadingView.frame.maxX + 10,
                                           y: view.safeAreaInsets.top+20,
                                           width: leadingView.frame.size.width,
                                           height: leadingView.frame.size.height)
               trailingView.backgroundColor = .blue
               
               
               print("leadingView: \(leadingView.frame)")
               print("trailingView: \(trailingView.frame)")
    }
    

}

