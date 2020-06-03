//
//  ViewController.swift
//  191121
//
//  Created by 양중창 on 2019/11/21.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var add: UIButton!
    @IBOutlet weak var sub: UIButton!
    
    var num: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        
        
        
        
        
        
    }
    
   
    @IBAction func sub(_ sender: Any) {
        num -= 1
        
        myLabel.text = String(num)
        myLabel.textColor = .red
        
    }
    
    @IBAction func add(_ sender: Any) {
        
        num += 1
        
        myLabel.text = String(num)
        myLabel.textColor = .blue
        
    }
    
}

