//
//  PassWordViewController.swift
//  CustomView
//
//  Created by Lee on 2019/12/11.
//  Copyright © 2019 Kira. All rights reserved.
//

import UIKit

class PassWordViewController: UIViewController {
  
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
    
    let customView = TextFieldType2(frame: view.frame)
    customView.delegate = self
    customView.configure()
    view.addSubview(customView)
  }
}

extension PassWordViewController: TextFieldType2Delegate {
  func setTitleLabel() -> String { "비밀번호을 입력해주세요" }
  
  func setButtonTitle() -> String { "회 원 가 입" }
  
  func buttonDidTap() {
    let data = SignUpData.shared.data
    
    guard
      let email = data["email"] as? String,
      let nickName = data["nickName"] as? String
      else { return }
    
    alertAction(tilte: "회 원 가 입", message: """
이메일: \(email)
닉네임: \(nickName)
"""
    )
  }
}
