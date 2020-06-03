//
//  ViewController.swift
//  task_191125
//
//  Created by 양중창 on 2019/11/25.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let label = UILabel()
    var count = 1
    let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .orange
        setButton()
        setLabel()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        label.text = "First View : \(count)"
    }
    
    func setLabel() {
        label.frame.size = CGSize(width: view.frame.size.width, height: 50)
        label.center.y = view.center.y - 200
        label.center.x = view.center.x
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        
        view.addSubview(label)
    }
    
    
    
    func setButton() {
        
        button.frame.size = CGSize(width: 100, height: 50)
        button.center.x = view.center.x
        button.center.y = view.center.y + 100
        button.setTitle("NextView", for: .normal)
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    @objc func tapButton(_ sender: UIButton) {
        let nextView = NextViewController()
        nextView.count = count + 1
        nextView.modalPresentationStyle = .fullScreen
        present(nextView, animated: true)
        
    }


}

