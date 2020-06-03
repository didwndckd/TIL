//
//  CustomCell.swift
//  CollectionViewExample
//
//  Created by giftbot on 2020/01/24.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

final class CustomCell: UICollectionViewCell {
  static let identifier = "CustomCell"
    
    private let imageView = UIImageView()
    private let titleLabel = UILabel()
  
  // MARK: Init
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupViews()
    setupConstraints()
  }
  
  // MARK: Setup
  
  private func setupViews() {
    
    contentView.addSubview(imageView)
    contentView.addSubview(titleLabel)
    
    clipsToBounds = true
    layer.cornerRadius = 20
    
    titleLabel.textAlignment = .center
    titleLabel.textColor = .white
    titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
    
    
  }
  
  private func setupConstraints() {
    imageView.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
    imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
    imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
    imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//    imageView.bottomAnchor.constraint(equalTo: titleLabel.topAnchor),
     
    titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor),
    titleLabel.heightAnchor.constraint(equalToConstant: 20),
    titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
    titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
    titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
    
    titleLabel.setContentCompressionResistancePriority(.required, for: .vertical)
    // 자기자신의 높이만 지켜라
  }
  
  // MARK: Configure Cell
    
    
    func configure(image: UIImage?, title: String) {
        imageView.image = image
        titleLabel.text = title
    }
  
}
