//
//  FirstCell.swift
//  DelegateExample_Table
//
//  Created by 양중창 on 2019/12/11.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class MyCell: UIView {
    
    
    
    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
