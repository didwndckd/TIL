//
//  SecondViewController.swift
//  Storyboard_Segue
//
//  Created by 양중창 on 2019/12/03.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var label: UILabel!
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        label.text = "\(count)"

        // Do any additional setup after loading the view.
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        view.endEditing(true) // 뷰의 에디팅을 끝낸다
    }
   
    
    @IBAction func noString(_ sender: UITextField) {
        
        guard let editText = sender.text else{return}
            
            if Int(editText) == nil {
                textField.text = ""
            }
            
        
        
        
    }
    @IBAction func unwindToSecondViewController(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        // Use data from the view controller which initiated the unwind segue
        
        
        
    }
    
    @IBAction func didEnd(_ sender: Any) {
    }
    
}
