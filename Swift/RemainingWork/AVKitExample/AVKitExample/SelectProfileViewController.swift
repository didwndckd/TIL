//
//  SelectProfileViewController.swift
//  AVKitExample
//
//  Created by 양중창 on 2020/03/20.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class SelectProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(UIScreen.main.bounds)
        
//        print(view.frame)
        
//        let test: CGFloat = 10
        print(CGFloat.dinamicXMargin(margin: 10))
        print(CGFloat.dinamicYMargin(margin: 10))
        //(0.0, 0.0, 414.0, 896.0)
        //(0.0, 0.0, 375.0, 812.0)
    }
    

}
