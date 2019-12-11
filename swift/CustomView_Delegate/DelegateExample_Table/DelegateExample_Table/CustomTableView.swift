//
//  CustomTableView.swift
//  DelegateExample_Table
//
//  Created by 양중창 on 2019/12/11.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class CustomTableView: UIView {
    
    weak var delegate: TableDelegate?
    
    var arr: [Any]
    
    init(_ frame: CGRect, _ superView: UIView, _ arr: [Any]) {
        self.arr = arr
        super.init(frame: frame)
        superView.addSubview(self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func modify(arr: [Any]) {
        
        setTable(arr: arr)
        
    }
    
    
    func setTable(arr: [Any]) {
        
        guard let count = delegate?.count() else {
            return
        }
        
        for i in 0 ..< count {
            if let cell = delegate?.cell(position: i) {
                
                    cell.center.x = self.center.x
                    cell.center.y = (cell.frame.size.height) * CGFloat(i + 1)
                    self.addSubview(cell)
            }
            
        }
        
        
    }
    

}

