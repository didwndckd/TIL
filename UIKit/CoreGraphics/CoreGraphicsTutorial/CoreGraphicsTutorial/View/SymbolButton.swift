//
//  PlussButton.swift
//  CoreGraphicsTutorial
//
//  Created by 양중창 on 2020/07/12.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class SymbolButton: UIButton {

  enum ButtonStyle {
    case plus
    case minus
  }
  
  private let symbolLabel = UILabel()
  
  init(style: ButtonStyle) {
    super.init(frame: .zero)
    setupUI(style)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI(_ style: ButtonStyle) {
    addSubview(symbolLabel)
    
    let titleName = style == ButtonStyle.plus ? "+": "-"
    backgroundColor = style == ButtonStyle.plus ? UIColor.blue: UIColor.red
    
    symbolLabel.textColor = .white
    symbolLabel.text = titleName
    symbolLabel.textAlignment = .center
    
    symbolLabel.translatesAutoresizingMaskIntoConstraints = false
    symbolLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
    symbolLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    symbolLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    symbolLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    guard frame != .zero else { return }
    let size = frame.width > frame.height ? frame.height: frame.width
    layer.cornerRadius = size / 2
    
    symbolLabel.font = .systemFont(ofSize: symbolLabel.bounds.height)
    
  }
  
}
