//
//  ViewController.swift
//  task_191122
//
//  Created by 양중창 on 2019/11/22.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var `switch`: UISwitch!
    
    @IBOutlet weak var seg: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        label.textColor = .red
        label.text = "ON"
        
        
        
        
        
    }

    @IBAction func changeSwitch(_ sender: Any) {
        if `switch`.isOn {
            label.text = "ON"
        }else {
            label.text = "OFF"
        }
    }
    
    
    @IBAction func changeSeg(_ sender: Any) {
        
        switch seg.selectedSegmentIndex {
        case 0:
            label.textColor = .red
        case 1:
            label.textColor = .blue
        case 2:
            label.textColor = .gray
        case 3:
            label.textColor = .black
        default:
            print("예외")
        }
        
    }
    

    

}

