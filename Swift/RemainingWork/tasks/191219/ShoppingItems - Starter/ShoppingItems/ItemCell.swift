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
    
    let currentOrderAmount = UILabel()
    
    let productImageView = UIImageView()
    
    let productName = UILabel()
    
    
    
    weak var delegate: ItemCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(orderButton)
        orderButton.setImage(UIImage(named: "add"), for: .normal)
        orderButton.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        productImageView.contentMode = .scaleAspectFit
        
        contentView.addSubview(currentOrderAmount)
        contentView.addSubview(productImageView)
        contentView.addSubview(productName)
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setUI() {
        
        
        productImageView.translatesAutoresizingMaskIntoConstraints = false
        productImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        productImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        productImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
        
        
        productName.translatesAutoresizingMaskIntoConstraints = false
        productName.leadingAnchor.constraint(equalTo: productImageView.trailingAnchor, constant: 8).isActive = true
        productName.trailingAnchor.constraint(equalTo: currentOrderAmount.leadingAnchor, constant: -8).isActive = true
        productName.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        productName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
//        productName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        orderButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8).isActive = true
        orderButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        currentOrderAmount.translatesAutoresizingMaskIntoConstraints = false
        currentOrderAmount.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        currentOrderAmount.trailingAnchor.constraint(equalTo: orderButton.leadingAnchor, constant: -8).isActive = true
        
        
        
//        imageView?.widthAnchor.constraint(equalTo: contentView.heightAnchor).isActive = true
    }
    
    @objc func didTapButton() {
        
        delegate?.buttonAction(cell: self)
    }
    
  
}
