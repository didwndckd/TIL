//
//  CustomCollectionViewCell.swift
//  CollectionViewPractice
//
//  Created by 양중창 on 2020/01/28.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    private let selectedView = UIView()
    private let checkView = UIImageView(image: UIImage(systemName: "checkmark.circle"))
    override var isSelected: Bool {
        didSet {
            selectedView.isHidden = !isSelected
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        clipsToBounds = true
        layer.cornerRadius = 20
        
        contentView.addSubview(imageView)
        contentView.addSubview(selectedView)
        selectedView.addSubview(checkView)
        selectedView.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.4)
        
        
        setupAutoLayout()
        
    }
    
    private func setupAutoLayout() {
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        selectedView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        selectedView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        selectedView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        selectedView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        
        checkView.translatesAutoresizingMaskIntoConstraints = false
        checkView.leadingAnchor.constraint(equalTo: selectedView.leadingAnchor, constant: 8).isActive = true
        checkView.bottomAnchor.constraint(equalTo: selectedView.bottomAnchor, constant: -8).isActive = true
        
        
    }
    
    func configure(selected: Bool, image: UIImage?) {
        selectedView.isHidden = !selected
        imageView.image = image
    }
    
//    func setSelectedView(selected: Bool) {
//        selectedView.isHidden = !selected
//    }
    
    
}
