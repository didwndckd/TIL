//
//  LoginTextField.swift
//  LoginPageExample
//
//  Created by 양중창 on 2019/12/16.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class LoginTextField: UITextField {

//    override var delegate: UITextFieldDelegate? {
//        get {
//            super.delegate
//        }
//        set {
//            super.delegate = newValue
//        }
//    }
    
    // 텍스트필드에 내부 텍스트나 플레이스 홀더 에디팅 간 내부 패딩을 주는 방법
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftView = super.leftView else { return CGRect(x: 0, y: 0, width: 0, height: 0) }
        return bounds.inset(by: UIEdgeInsets(top: 3,
                                             left: leftView.bounds.size.width + 10,
                                             bottom: 3,
                                             right: 10))
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftView = super.leftView else { return CGRect(x: 0, y: 0, width: 0, height: 0) }
        return bounds.inset(by: UIEdgeInsets(top: 3,
                                             left: leftView.bounds.size.width + 10,
                                             bottom: 3,
                                             right: 10))
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        guard let leftView = super.leftView else { return CGRect(x: 0, y: 0, width: 0, height: 0) }
        //print("editingRect")
        return bounds.inset(by: UIEdgeInsets(top: 3,
                                             left: leftView.bounds.size.width + 10,
                                             bottom: 3,
                                             right: 10))
    }

}
