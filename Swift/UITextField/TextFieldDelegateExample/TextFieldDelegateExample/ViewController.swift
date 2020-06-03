//
//  ViewController.swift
//  TextFieldDelegateExample
//
//  Created by 양중창 on 2019/12/10.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var myView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textField.delegate = self
        
    }


}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("엔터 클릭")
         textField.resignFirstResponder()
        guard let text = textField.text else {
            textField.resignFirstResponder()
            return true
        }
        
        if text == "red" {
            myView.backgroundColor = .red
           
        }else if text == "blue" {
            myView.backgroundColor = .blue
            textField.resignFirstResponder()
        }else if text == "black" {
            myView.backgroundColor = .black
            textField.resignFirstResponder()
        }else{
            myView.backgroundColor = .gray
            textField.resignFirstResponder()
        }
        
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        print(textField.text)
        guard let text = textField.text else {
            return false
        }
        
        
        print(string)
        return text.count < 10
        // 눌렀을 때 return true 이면 텍스트 필드에 입력됨, return false 이면 입력 안됨
    }
    
}
