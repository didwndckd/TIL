//
//  SecondViewController.swift
//  AppLifeCycleTest
//
//  Created by 양중창 on 2019/11/28.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("세컨드 뷰 윌 디드로드")
        
        
        view.backgroundColor = .blue
        
        self.dismiss(animated: true)
        
        
        // Do any additional setup after loading the view.
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
