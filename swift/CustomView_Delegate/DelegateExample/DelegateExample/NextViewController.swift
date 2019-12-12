//
//  NextViewController.swift
//  DelegateExample
//
//  Created by 양중창 on 2019/12/10.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    @IBOutlet weak var myView: CustomView!
    
    
    override func viewDidLoad() {
            super.viewDidLoad()
            // Do any additional setup after loading the view.
            
            print("ViewDidLoad")
            myView.delegate = self
            myView.backgroundColor = nil
            myView.backgroundColor = .red
    //        myView.backgroundColor = .red
            //바꿀때마다 프린트를 찍어야하는 문제점
            
            
            
            
        }
    
    deinit {
        print("NextView deinit")
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


extension NextViewController: CustomViewDelegate {
func colorForBackground(_ newColor: UIColor?) -> UIColor {
    guard let color = newColor else {return .black}
    
    return color == .red ? .gray : color
}

}
