//
//  CategoryTableViewCell.swift
//  DominoUpdate
//
//  Created by 양중창 on 2020/01/29.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {

    static let identifier = "CategoryTableViewCell"
    
    private let categoryImageView = UIImageView()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        categoryImageView.contentMode = .scaleToFill
        contentView.addSubview(categoryImageView)
        
        setupConstraint()
    }
    
    private func setupConstraint() {
        categoryImageView.translatesAutoresizingMaskIntoConstraints = false
        categoryImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        categoryImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        categoryImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        categoryImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    func configure(named: String) {
        let image = UIImage(named: named)
        categoryImageView.image = image
    }
    
}
