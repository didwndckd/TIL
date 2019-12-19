//
//  CustomCellTableViewCell.swift
//  TableViewPractice
//
//  Created by 양중창 on 2019/12/19.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

protocol CustomCellDelegate: class {
    func buttonAction(cell: CustomCell)
}

class CustomCell: UITableViewCell {
    
    let button = UIButton(type: .system)
    weak var delegate: CustomCellDelegate?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(button)
        button.setTitle("+1", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        setUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUI() {
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        button.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        
    }
    
    @objc func didTapButton() {
        delegate?.buttonAction(cell: self)
    }
    
    
    
}
