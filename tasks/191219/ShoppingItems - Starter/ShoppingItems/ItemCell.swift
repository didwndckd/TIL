//
//  ItemCell.swift
//  ShoppingItems
//
//  Created by giftbot on 2019. 12. 17..
//  Copyright © 2019년 giftbot. All rights reserved.
//

import UIKit
protocol  ItemCellDelegate: class {
    
    func buttonAction(cell: ItemCell)
}


final class ItemCell: UITableViewCell {
    
    private let orderButton = UIButton()
    
    private let currentOrderAmount = UILabel()
    
    
    
    weak var delegate: ItemCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(orderButton)
        orderButton.setImage(UIImage(named: "add"), for: .normal)
        
        contentView.addSubview(currentOrderAmount)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUI() {
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        orderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        orderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        currentOrderAmount.translatesAutoresizingMaskIntoConstraints = false
        currentOrderAmount.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentOrderAmount.trailingAnchor.constraint(equalTo: orderButton.leadingAnchor, constant: -8).isActive = true
        
//        imageView?.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    
  
}
