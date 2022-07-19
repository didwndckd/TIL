//
//  SecondViewController.swift
//  task_191122
//
//  Created by 양중창 on 2019/11/22.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var textFild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    

    @IBAction func getValue(_ sender: Any) {
        guard let getText = textFild.text else {
            print("값 없음")
            return
        }
        
        var value : Int = 0
        
        for num in getText {
            
            if let j = Int(String(num)) {
                value += j
            }
            
        }
        
        label.text = getText+"->"+String(value)
        textFild.text = ""
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
