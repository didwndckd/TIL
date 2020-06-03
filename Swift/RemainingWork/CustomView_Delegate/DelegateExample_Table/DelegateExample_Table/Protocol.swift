//
//  File.swift
//  DelegateExample_Table
//
//  Created by 양중창 on 2019/12/11.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit


protocol TableDelegate: class {
    
    func cell(position: Int) -> MyCell
    
    func count() -> Int
    

    
}
