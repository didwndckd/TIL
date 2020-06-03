//
//  ViewController.swift
//  AppLifeCycleTest
//
//  Created by 양중창 on 2019/11/28.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
   
    let firstView = FirstView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("viewDidLoad")
    
        
        firstView.setUI(superView: view)
        firstView.btn.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
       
    }
    
    
   @objc func didTapButton(_ sender: UIButton) {
        let secondVC = SecondViewController()
        present(secondVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("윌 어피어")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("디드 어피어")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print("윌 디스어피어")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("디드 디스어피어")
    }
    deinit {
        print("디 인잇")
    }

}

