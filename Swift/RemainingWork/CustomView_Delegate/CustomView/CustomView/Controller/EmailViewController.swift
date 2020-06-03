//
//  EmailViewController.swift
//  CustomView
//
//  Created by Lee on 2019/12/10.
//  Copyright © 2019 Kira. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    baseUI()
  }
  
  private func alertAction(tilte: String?, message: String?) {
    let alert = UIAlertController(title: tilte, message: message, preferredStyle: .alert)
    let cancel = UIAlertAction(title: "cancel", style: .cancel) { (action) in
      
    }
    alert.addAction(cancel)
    present(alert, animated: true)
  }
  
  private func baseUI() {
    view.backgroundColor = .white
    
    let customView = TextFieldType1(frame: view.frame)
    customView.delegate = self
    customView.configure()
    view.addSubview(customView)
  }
}

extension EmailViewController: TextFieldType1Delegate {
  func setTitleLabel() -> String { "이메일을 입력해주세요" }
  
  func setButtonTitle() -> String { "Next" }
  
  func buttonDidTap(text: String?) {
    guard let email = text else {
      alertAction(tilte: "에러", message: "입력값이 없습니다")
      return
    }
    
    SignUpData.shared.data["email"] = email
    
    let vc = NickNameViewController()
    present(vc, animated: true)
  }
}
