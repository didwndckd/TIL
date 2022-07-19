//
//  Delegate.swift
//  Task_191210
//
//  Created by 양중창 on 2019/12/10.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit


protocol MyDelegate: class {
    func setLabel(_ label: UILabel)
    
}

protocol SecondDelegate: class {
    func setLabel(text: String)
}



