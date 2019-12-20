//
//  CustomButton.swift
//  CalculatorExample
//
//  Created by 양중창 on 2019/12/20.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

class CustomButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
//        fatalError("init(coder:) has not been implemented")
        
        layer.cornerRadius = 45
        
    }
    
}
