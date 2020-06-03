//
//  ViewController.swift
//  UITextField
//
//  Created by 양중창 on 2019/11/26.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var idText: UITextField!
    
    //@IBOutlet weak var btn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        idText.font = .systemFont(ofSize: 30)
        idText.keyboardType = .URL
        //btn.addTarget(self, action: #selector(goNextView(_:)), for: .touchUpInside)
    }
    
//    @objc func goNextView(_ sender: UIButton) {
//        let secondVC = SecondViewController()
//        present(secondVC, animated: true)
//    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        idText.becomeFirstResponder()
        // 창 열리자마자 idText에 포커스
    }

    @IBAction func textFieldDidAndExit(_ sender: Any) {//엔터키 치면 키보드 내려감
        print("디드앤드 엑시트")
    }
    
    @IBAction func textFieldEditingChanged(_ sender: Any) {
        print("에딧팅 체인지")
        guard let text = sender as? UITextField else{return}
        print(text.text ?? "" )
        
        if text.text!.count > 6 {
           // text.resignFirstResponder()
        }//6글자 이상 타이핑 하면 키보드가 내려감
        
//        view.endEditing(true)
        //뷰가 가진 모든 아이에게 적용
        
    }
    @IBAction func textEditingDidBegin(_ sender: UITextField) {
        print("에디팅 디드 비긴")
        if sender.tag == 0 {
            print("아이디")
        }else if sender.tag == 1 {
            print("비번")
        }else if sender.tag == 2{
            print("비번확인")
        }
    }
    
    
    @IBAction func textEditingDidEnd(_ sender: Any) {
        print("에디팅 디드 엔드")
    }
    @IBAction func textFieldPrimaryAction(_ sender: UITextField) {
        print("프라이머리 액션")
        
        print(sender)
        
    }// 엔터키 쳤을때 처리
    
    
    
    
}

