//
//  ViewController.swift
//  DinamicAutoLayoutExample
//
//  Created by 양중창 on 2019/12/16.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var centerXConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var myView: UIView!
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        

//        1. constant, multiplier 변경
//        centerXConstraint.constant = -100
        
//        2. 우선순위 변경
//        centerXConstraint.priority = .defaultHigh
        
//        3. isActive
        
        
//        centerXConstraint.isActive = false
//
//        centerXConstraint.isActive = true
        
        print(myView.constraints)
//        print(view.constraints)
        
        
    }
    
    
    
    override func updateViewConstraints() {
        // constraint 바뀔때 호춣
    }
    
    override func viewWillLayoutSubviews() {
        // frame 바뀔때 호출
    }
    
    
    
    var togle = false
    @IBAction func didTapButton(_ sender: Any) {
        
//        self.view.setNeedsLayout()  // 시스템이 런루프를 돌다가 true일 경우에만 layout을 해준다
                                        // 조건을 true로 바꿔주는 메서드
        
        
        
        
        
        if togle {
//            centerXConstraint.priority = .required // 우선순위
//            centerXConstraint.isActive = true  // 오토레이아웃 적용
            UIView.animate(withDuration: 1, animations: {
                self.centerXConstraint.constant = 100 // 암시적으로  view.setNeedsLayout() 호출
                self.view.layoutIfNeeded() // 명시적으로 이 시점에 레이아웃을 해줘라
            })
            
        }else{
//            centerXConstraint.priority = .defaultHigh // 우선순위
//            centerXConstraint.isActive = false  // 오토레이아웃 해제
            UIView.animate(withDuration: 1, animations: {
                self.centerXConstraint.constant = -100
                self.view.layoutIfNeeded()
            })
        }
        togle.toggle()
    }
    

}

