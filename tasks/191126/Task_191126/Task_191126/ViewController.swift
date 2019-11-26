//
//  ViewController.swift
//  Task_191126
//
//  Created by 양중창 on 2019/11/26.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
//    > 텍스트 필드에 어떤 값을 입력하면 별도의 Label 에 입력된 텍스트 표시.
//    > 텍스트 필드가 활성화 되어 있을 땐 Label 의 텍스트 색상이 파란색이고, Font 크기는 40
//    > 텍스트 필드가 비활성화되면 Label 텍스트 색상이 빨간색이고, Font 크기는 20

    
    let label = UILabel()
    let textField = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setUI()
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        print("터치 앤드")
        view.endEditing(true) //뷰를 터치하면 에디팅을 종료 한다
        
        //textField.resignFirstResponder() // 뷰를 터치한다는것은 입력을 멈춘다는 의미이기 때문에
                                            // 뷰의 모든 텍스트필드의 에디팅을 종료한다
    }
    
    func setUI() {
        label.frame.size = CGSize(width: view.frame.size.width - 50, height: 30)
        label.center.x = view.center.x
        label.center.y = view.center.y - 100
        view.addSubview(label)
        
        textField.frame.size = CGSize(width: view.frame.size.width - 100, height: 30)
        textField.center.x = view.center.x
        textField.center.y = view.center.y
        textField.borderStyle = .bezel
        textField.textAlignment = .center
        textField.clearButtonMode = .always
        textField.placeholder = "입력하세요"
        textField.addTarget(self, action: #selector(editChange(_:)), for: .editingChanged)
        textField.addTarget(self, action: #selector(editDidEnd(_:)), for: .editingDidEnd)
        textField.addTarget(self, action: #selector(primary(_:)) , for: .primaryActionTriggered)
        textField.addTarget(self, action: #selector(editBegin(_:)), for: .editingDidBegin)
        
        
        view.addSubview(textField)
    }

    
    @objc func editBegin(_ sender: UITextField) { //텍스트 필드에 포커스가 들어가면 폰트와 텍스트 컬러를
                                                  // 40, blue로 맞춰 준다
        label.textColor = .blue
        label.font = .systemFont(ofSize: 40)
    }
    @objc func editChange(_ sender: UITextField) {//텍스트 필드의 값이 바뀔때 마다 label의 text를
                                                  // 변경해 준다
        
        label.textAlignment = .center
        label.text = sender.text
    }
    
    @objc func editDidEnd(_ sender: UITextField) {// 에디팅이 끝나면 label의 텍스트컬러를 red로,
                                                // 폰트크기를 20 으로 바꿔준다
        label.textColor = .red
        label.font = .systemFont(ofSize: 20)
    }
    
    @objc func primary(_ sender: UITextField) {//return 버튼을 누르면 해당 텍스트필드의 에디팅을 종료
                                                // 종료 하게되면 자동으로 editingDidEnd가 호출되며
                                                // label의 폰트와 텍스트 색상을 다시 바꿔준다
        print("프라이머리")
        sender.resignFirstResponder()
    }
    
    

}

