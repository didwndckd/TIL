//
//  ViewController.swift
//  MyMemo
//
//  Created by 양중창 on 2019/12/03.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var messageBox: MessageBox?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageBox = MessageBox(frame: CGRect(origin: .zero, size: CGSize(width: 300, height: 200)))
        
        if let msg = messageBox {
            msg.frame.origin = CGPoint(x: (UIScreen.main.bounds.width - msg.bounds.width) * 0.5,
                                       y: (UIScreen.main.bounds.height - msg.bounds.height) * 0.5)
            
            msg.backgroundColor = .lightGray
            msg.delegate = self
            self.view.addSubview(msg)
        }
        
        
    }
    
    
    

}

extension MainViewController: MessageBoxDelegate{
    func touchButton() {
        print("touchButton")
    }
}

