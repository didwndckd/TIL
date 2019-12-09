//
//  MyDelegate.swift
//  MyMemo
//
//  Created by 양중창 on 2019/12/06.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit


protocol MessageBoxDelegate: class {
    func touchButton()
}

class MessageBox: UIView {
    
    weak var delegate: MessageBoxDelegate?
    var button: UIButton?
    
    public override init(frame: CGRect){
        super.init(frame: frame)
        
        
    }
    
   public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    
    }
    
    func configure() {
        
        button = UIButton(type: .system)
        
        if let btn = button {
            btn.setTitle("SEND", for: .normal)
            btn.sizeToFit()// 텍스트에 맞게 크기 조정
            btn.frame.origin = CGPoint(x: (self.bounds.width - btn.bounds.width) * 0.5,
                                       y: (self.bounds.height - btn.bounds.height) * 0.5 )
            btn.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
            self.addSubview(btn)
        }
        
        
    }
    
    @objc func tapButton() {
        delegate?.touchButton()
    }
    
    
}
