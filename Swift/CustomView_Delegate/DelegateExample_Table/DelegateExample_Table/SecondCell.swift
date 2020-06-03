//
//  SecondCell.swift
//  DelegateExample_Table
//
//  Created by 양중창 on 2019/12/11.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

protocol SecondCellDelegate: class {
    func didTapButton(position: Int)
}

class SecondCell: MyCell {
    
    private let position: Int
    
    
    
    let label = UILabel()
    let button = UIButton(type: .system)
    
    weak var delegate: SecondCellDelegate?

    
    init(position: Int) {
        
        self.position = position
        super.init()
        self.frame.size = setUI()
        
        
    }
    
//    override init() {
//        super.init()
//        self.frame.size = setUI()
//    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI () -> CGSize{
        
        let size = CGSize(width: 400, height: 100)
        
        
        label.frame = CGRect(x: 0, y: 0, width: 400, height: 50)
        label.backgroundColor = .blue
        label.textAlignment = .center
        self.addSubview(label)
        
        button.frame = CGRect(x: 0, y: 50, width: 400, height: 50)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        self.addSubview(button)
        
        self.layer.borderWidth = 1
        
        return size
    }
    
    
     @objc func didTapButton (_ sender: UIButton) {
        print("position: \(position)")
        print(delegate)
        delegate?.didTapButton(position: position)
    }
    
    
    
    
    
    
}
