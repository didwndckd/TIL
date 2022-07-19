//
//  FirstCell.swift
//  DelegateExample_Table
//
//  Created by 양중창 on 2019/12/11.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class FirstCell: MyCell {
    
    let label = UILabel()
    let label2 = UILabel()

    override init() {
        super.init()
        super.frame.size = setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI () -> CGSize{
        
        let size = CGSize(width: 400, height: 50)
        
        
        label.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        label.backgroundColor = .red
        label.textAlignment = .center
        self.addSubview(label)
        
        
        label2.frame = CGRect(x: 200, y: 0, width: 200, height: 50)
        label2.textAlignment = .center
        label2.backgroundColor = .blue
        self.addSubview(label2)
        
        self.layer.borderWidth = 1
        
        return size
    }
    
    
}
