//
//  ViewController.swift
//  DelegateExample
//
//  Created by 양중창 on 2019/12/10.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {

    @IBOutlet weak var myView: CustomView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        print(CFGetRetainCount(self))
        myView.delegate = self
        myView.backgroundColor = nil
        myView.backgroundColor = .red
//        myView.backgroundColor = .red
        //바꿀때마다 프린트를 찍어야하는 문제점
        print(CFGetRetainCount(self))
        
        
        
    }
    
    deinit {
        print("ViewController deinit: \(CFGetRetainCount(self))")
    }

    @IBAction func dismissButton(_ sender: Any) {
        
        print("dismissButton")
        dismiss(animated: false)
    }
    
}

extension ViewController: CustomViewDelegate {
    func colorForBackground(_ newColor: UIColor?) -> UIColor {
        guard let color = newColor else {return .black}
        
        return color == .red ? .blue : color
    }
    

}
