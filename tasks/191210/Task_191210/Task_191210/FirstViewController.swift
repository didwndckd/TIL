//
//  ViewController.swift
//  Task_191210
//
//  Created by 양중창 on 2019/12/10.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {

    @IBOutlet var myview: UIView!
    
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: SecondDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func unwindToFirstViewcontroller(_ unwindSegue: UIStoryboardSegue) {
        //let sourceViewController = unwindSegue.source
        
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "FirstDelegate" {
            print("First")
            guard let secondVC = segue.destination as? SecondViewController else{return}
            
            
            secondVC.tempDelegate = self
            
        }
        
        else if segue.identifier == "SecondDelegate" {
            print("Second")
            guard let secondVC = segue.destination as? SecondViewController else{return}
            guard let text = textField.text else {return}
            delegate = secondVC
            delegate?.setLabel(text: text)
            
            
        }else {
            return
        }
        
        
        
    }


}

extension FirstViewController: MyDelegate {
    
    func setLabel(_ label: UILabel) {
        guard let text = textField.text else{ return }
        label.text = text
        
    }
    
}

