//
//  SecondViewController.swift
//  Task_191206
//
//  Created by 양중창 on 2019/12/06.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let label = UILabel()
    var tag = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
        // Do any additional setup after loading the view.
    }
    
    
    func setUI () {
        view.backgroundColor = .systemBackground
        
        label.frame = CGRect(x: 15, y: view.center.y - 200, width: view.frame.size.width, height: 30)
        label.textAlignment = .center
        view.addSubview(label)
        
        setlabel()
        
    }
    
    func setlabel() {
        if tag == 1 {
            label.text = UserDefaults.standard.string(forKey: "text")
            
        }else {
            label.text = MySingleTon.shared.text
        }
    }
    

}
