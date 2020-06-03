//
//  SecondViewController.swift
//  Task_191210
//
//  Created by 양중창 on 2019/12/10.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet var myView: UIView!
    @IBOutlet weak var label: UILabel!
    
    weak var tempDelegate: MyDelegate?
    var text = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("세컨드 뷰 디드로드")
        
        label.text = text
        
        tempDelegate?.setLabel(label)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("세컨드 뷰 윌 어피어")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("세컨드 뷰 디드 어피어")
    }
    


}

extension SecondViewController: SecondDelegate {
    
    func setLabel(text: String) {
        self.text = text
    }
    
    
}


    

