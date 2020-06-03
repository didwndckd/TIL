//
//  FirstView.swift
//  AppLifeCycleTest
//
//  Created by 양중창 on 2019/11/28.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class FirstView: UIView {

    
   private let label = UILabel()
    let btn = UIButton(type: .system)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI(superView: self)
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    func setUI(superView: UIView) {
        
        
        label.frame.size = CGSize(width: 300, height: 50)
        label.center = self.center
        label.text = "First View"
        label.backgroundColor = .black
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        self.addSubview(label)
        
        self.backgroundColor = .red
        
        
        btn.frame.size = CGSize(width: 100, height: 50)
        btn.center.y = self.center.y + 200
        btn.center.x = self.center.x
        btn.setTitle("NextView", for: .normal)
        self.addSubview(btn)
        
        superView.addSubview(self)
        print("setUI")
        
    }
    
    
    
}
