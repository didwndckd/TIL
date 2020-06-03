//
//  ViewController.swift
//  Task_191206
//
//  Created by 양중창 on 2019/12/06.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let singleTonButton = UIButton(type: .system)
    let userDefaultsButton = UIButton(type: .system)
    let textField = UITextField()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    func setUI() {
        
        singleTonButton.frame.size = CGSize(width: 100, height: 40)
        userDefaultsButton.frame.size = CGSize(width: 100, height: 40)
        
        singleTonButton.center.x = view.center.x - 60
        singleTonButton.center.y = view.center.y + 100
        singleTonButton.setTitle("싱글톤", for: .normal)
        singleTonButton.titleLabel?.font = .systemFont(ofSize: 20)
        singleTonButton.tag = 0
        singleTonButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.addSubview(singleTonButton)
        
        userDefaultsButton.center.x = view.center.x + 60
        userDefaultsButton.center.y = view.center.y + 100
        userDefaultsButton.setTitle("유저디폴트", for: .normal)
        userDefaultsButton.titleLabel?.font = .systemFont(ofSize: 20)
        userDefaultsButton.tag = 1
        userDefaultsButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.addSubview(userDefaultsButton)
        
        
        textField.frame.size = CGSize(width: view.frame.size.width-50, height: 40)
        textField.center.x = view.center.x
        textField.center.y = view.center.y - 70
        textField.borderStyle = .bezel
        view.addSubview(textField)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        
        if sender.tag == 1 {
            print("유저디폴트")
            
            guard let text = textField.text else{return}
            
            UserDefaults.standard.set(text, forKey: "text")
            let seconVC = SecondViewController()
            seconVC.tag = sender.tag
            present(seconVC, animated: true)
            
            
        }else {
            print("싱글톤")
            
            guard let text = textField.text else {return}
            MySingleTon.shared.text = text
            let seconVC = SecondViewController()
            seconVC.tag = sender.tag
            present(seconVC, animated: true)
            
        }
        
        
    }


}

