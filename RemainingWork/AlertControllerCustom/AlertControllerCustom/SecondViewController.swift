//
//  SecondViewController.swift
//  AlertControllerCustom
//
//  Created by 양중창 on 2019/12/04.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    let header = UILabel()
    let body = UILabel()
    let alertView = UIView()
    let textField = UITextField()
    let okBTN = UIButton(type: .system)
    let cancleBTN = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setUI()
    }
    
    
    func setUI() {
        
        alertView.frame.size = CGSize(width: 300, height: 300)
        alertView.center = view.center
        alertView.backgroundColor = .white
        view.addSubview(alertView)
        
        header.frame = CGRect(x: 15, y: 0, width: alertView.frame.size.width - 10, height: alertView.frame.size.height/4)
        
        header.text = "Title"
        header.textAlignment = .center
        alertView.addSubview(header)
        
        body.frame = CGRect(x: 15, y: alertView.frame.size.height/4, width: alertView.frame.size.width - 30, height: alertView.frame.size.height/4)
        body.text = "Message"
        body.textAlignment = .center
        alertView.addSubview(body)
        
        let textFieldView = UIView()
        
        textFieldView.frame = CGRect(x: 15, y: alertView.frame.size.height/4 * 2, width: alertView.frame.size.width - 30, height: alertView.frame.size.height/4)
        alertView.addSubview(textFieldView)
        
        
      textField.frame = CGRect(x:0 , y:0 , width: textFieldView.frame.size.width, height: textFieldView.frame.size.height/2)
//
//        textField.frame.size = CGSize(width: textFieldView.frame.size.width, height: textFieldView.frame.size.height/2)
//
//        textField.center = textFieldView.center  //왜 안되는지 모르겠슴 시발
        textField.borderStyle = .bezel
        
        print(textFieldView.center)
        print(textField.center)
        
        textFieldView.addSubview(textField)
//        textFieldView.backgroundColor = .red
        //textField.backgroundColor = .blue
        
        
        let buttonView = UIView()
        
        buttonView.frame = CGRect(x: 15, y: alertView.frame.size.height/4 * 3, width: alertView.frame.size.width - 30, height: alertView.frame.size.height/4)
        alertView.addSubview(buttonView)
        
        cancleBTN.frame = CGRect(x: 0 , y: buttonView.frame.size.height/2 ,width: buttonView.frame.size.width/2, height: buttonView.frame.size.height/2)
        okBTN.frame = CGRect(x: buttonView.frame.size.width/2 , y: buttonView.frame.size.height/2 ,width: buttonView.frame.size.width/2, height: buttonView.frame.size.height/2)
        
        cancleBTN.setTitle("Cancle", for: .normal)
        okBTN.setTitle("OK", for: .normal)
        okBTN.tag = 1
        cancleBTN.tag = 0
        
        buttonView.addSubview(cancleBTN)
        buttonView.addSubview(okBTN)
        
        okBTN.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
        cancleBTN.addTarget(self, action: #selector(didTap(_:)), for: .touchUpInside)
    }
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
   
    
    
    @objc private func didTap(_ sender: UIButton) {
        
        switch sender.tag {
        case 0:
            dismiss(animated: false)
        case 1:
            
            guard let firstVC = presentingViewController as? ViewController else{return}
            
            firstVC.label.text = textField.text
            
            dismiss(animated: false)
            
        default:
            return
        }
    }
    
     
    
    

   

}
