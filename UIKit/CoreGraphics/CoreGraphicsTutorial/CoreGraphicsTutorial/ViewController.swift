//
//  ViewController.swift
//  CoreGraphicsTutorial
//
//  Created by 양중창 on 2020/07/12.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  private let plusButton = PlusButton()
  private let minusButton = SymbolButton(style: .minus)
  

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  private func setupUI() {
    [plusButton, minusButton].forEach({
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    setupConstraint()
  }
  
  private func setupConstraint() {
    let guide = view.safeAreaLayoutGuide
    
    let yMargin: CGFloat = -24
    
    [
      minusButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      minusButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: yMargin),
      minusButton.widthAnchor.constraint(equalToConstant: 100),
      minusButton.heightAnchor.constraint(equalToConstant: 100),
      
      plusButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      plusButton.bottomAnchor.constraint(equalTo: minusButton.topAnchor, constant: yMargin),
      plusButton.widthAnchor.constraint(equalToConstant: 100),
      plusButton.heightAnchor.constraint(equalToConstant: 100)
      
      ].forEach({ $0.isActive = true })
  }


}

