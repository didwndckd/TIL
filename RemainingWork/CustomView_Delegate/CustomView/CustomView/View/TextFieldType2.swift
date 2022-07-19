//
//  TextFieldType2.swift
//  CustomView
//
//  Created by Lee on 2019/12/11.
//  Copyright © 2019 Kira. All rights reserved.
//

import UIKit

protocol TextFieldType2Delegate: class {
  func setTitleLabel() -> String
  func setButtonTitle() -> String
  func buttonDidTap()
}

class TextFieldType2: UIView {
  
  weak var delegate: TextFieldType2Delegate?
  
  private let titleLabel = UILabel()
  private let textField1 = UITextField()
  private let guideLine1 = UIView()
  private let textField2 = UITextField()
  private let guideLine2 = UIView()
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
    
    textField1.frame = CGRect(
      x: Standard.xSpace,
      y: titleLabel.frame.maxY + Standard.ySpace,
      width: self.frame.width - ( Standard.xSpace * 2),
      height: Standard.itemHeight
    )
    self.addSubview(textField1)
    
    guideLine1.frame = CGRect(
      x: Standard.xSpace,
      y: textField1.frame.maxY + 4,
      width: self.frame.width - ( Standard.xSpace * 2),
      height: 1
    )
    guideLine1.backgroundColor = .black
    self.addSubview(guideLine1)
    
    textField2.frame = CGRect(
      x: Standard.xSpace,
      y: textField1.frame.maxY + Standard.ySpace,
      width: self.frame.width - ( Standard.xSpace * 2),
      height: Standard.itemHeight
    )
    self.addSubview(textField2)
    
    guideLine2.frame = CGRect(
      x: Standard.xSpace,
      y: textField2.frame.maxY + 4,
      width: self.frame.width - ( Standard.xSpace * 2),
      height: 1
    )
    guideLine2.backgroundColor = .black
    self.addSubview(guideLine2)
    
    enterButton.frame = CGRect(
      x: Standard.xSpace,
      y: guideLine2.frame.maxY + Standard.ySpace,
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
    delegate?.buttonDidTap()
  }
  
  private struct Standard {
    static let top: CGFloat = 80
    static let xSpace: CGFloat = 32
    static let ySpace: CGFloat = 24
    static let itemHeight: CGFloat = 48
  }
}
