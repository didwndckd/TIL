//
//  ViewController.swift
//  AlertControllerCustom
//
//  Created by 양중창 on 2019/12/04.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let label = UILabel()
    let button = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    
    func setUI() {
        
        label.frame.size = CGSize(width: view.frame.size.width - 20, height: 50)
        label.center.x = view.center.x
        label.center.y = view.center.y - 200
        label.backgroundColor = .black
        label.textAlignment = .center
        label.textColor = .white
        view.addSubview(label)
        
        button.frame.size = CGSize(width: 80, height: 40)
        button.center = view.center
        button.setTitle("start alert", for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        let secondVC = SecondViewController()
        
        secondVC.modalPresentationStyle = .overFullScreen
        present(secondVC, animated: false)
        
        
    }


}

