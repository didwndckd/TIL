//
//  ProfileCellCollectionViewCell.swift
//  AVKitExample
//
//  Created by 양중창 on 2020/03/20.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class ProfileCellCollectionViewCell: UICollectionViewCell {
    
    private let nameLabel = UILabel()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setUI() {
        
        backgroundColor = .black
        
        [imageView, nameLabel].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        nameLabel.textColor = .white
        
        imageView.contentMode = .scaleAspectFill
        
    }
    
    private func setConstraint() {
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    func configure(name: String, image: UIImage) {
        nameLabel.text = name
        imageView.image = image
    }
    
    
}
