//
//  TextFieldType1.swift
//  CustomView
//
//  Created by Lee on 2019/12/10.
//  Copyright © 2019 Kira. All rights reserved.
//

import UIKit

protocol TextFieldType1Delegate: class {
  func setTitleLabel() -> String
  func setButtonTitle() -> String
  func buttonDidTap(text: String?)
}

class TextFieldType1: UIView {
  
  weak var delegate: TextFieldType1Delegate?
  
  private let titleLabel = UILabel()
  private let textField = UITextField()
  private let guideLine = UIView()
  private let enterButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    baseUI()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configure() {
    titleLabel.text = delegate?.setTitleLabel()
    enterButton.setTitle(delegate?.setButtonTitle(), for: .normal)
  }
  
  private func baseUI() {
    titleLabel.font = .systemFont(ofSize: 30, weight: .heavy)
    titleLabel.frame = CGRect(
      x: Standard.xSpace,
      y: Standard.top,
      width: self.frame.width - ( Standard.xSpace * 2),
      height: Standard.itemHeight
    )
    self.addSubview(titleLabel)
    
    textField.frame = CGRect(
      x: Standard.xSpace,
      y: titleLabel.frame.maxY + Standard.ySpace,
      width: self.frame.width - ( Standard.xSpace * 2),
      height: Standard.itemHeight
    )
    self.addSubview(textField)
    
    guideLine.frame = CGRect(
      x: Standard.xSpace,
      y: textField.frame.maxY + 4,
      width: self.frame.width - ( Standard.xSpace * 2),
      height: 1
    )
    guideLine.backgroundColor = .black
    self.addSubview(guideLine)
    
    enterButton.frame = CGRect(
      x: Standard.xSpace,
      y: guideLine.frame.maxY + Standard.ySpace,
      width: self.frame.width - ( Standard.xSpace * 2),
      height: Standard.itemHeight
    )
    enterButton.setTitleColor(.white, for: .normal)
    enterButton.backgroundColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
    enterButton.layer.cornerRadius = 16
    enterButton.addTarget(self, action: #selector(enterButtonAction), for: .touchUpInside)
    self.addSubview(enterButton)
  }
  
  @objc private func enterButtonAction() {
    delegate?.buttonDidTap(text: textField.text)
  }
  
  private struct Standard {
    static let top: CGFloat = 80
    static let xSpace: CGFloat = 32
    static let ySpace: CGFloat = 24
    static let itemHeight: CGFloat = 48
  }
}
