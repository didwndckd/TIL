//
//  SecondViewcontroller.swift
//  StackViewTask_191216
//
//  Created by 양중창 on 2019/12/18.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    
    let secondView = SecondView(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setView()
        
    }
  
    func setView() {
        view.addSubview(secondView)
        
        secondView.translatesAutoresizingMaskIntoConstraints = false
        
        secondView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        secondView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        secondView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        secondView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }

}
