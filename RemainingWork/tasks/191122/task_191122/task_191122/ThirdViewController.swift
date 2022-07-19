//
//  ThirdViewController.swift
//  task_191122
//
//  Created by 양중창 on 2019/11/22.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    
    
    @IBOutlet weak var textFild: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func getValue(_ sender: Any) {
        
        guard let getText = textFild.text else {
            return
        }
        guard let selfNum = Int(getText) else{
            return
        }
        
        var temp = 0
        
        for i in getText {
            
            temp += Int(String(i))!
            
        }
        
        var result: String
        
        if selfNum%temp == 0 {
            result = "\(selfNum) -> true"
        }else {
            result = "\(selfNum) -> false"
        }
        
        label.text = result
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
