//
//  SecondView.swift
//  191121
//
//  Created by 양중창 on 2019/11/21.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit



class SecondView: UIViewController {

    let addButton = UIButton(type: .system)
    let subButton = UIButton(type: .system)
    let label = UILabel()
    var num: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        label.frame = CGRect(x: 198.5, y: 220, width: 80, height: 80)
        label.text = "0"
        label.font = label.font.withSize(30)
        view.addSubview(label)
        
        addButton.frame = CGRect(x: 90, y: 544, width: 80, height: 80)
        addButton.setTitle("add", for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(addButton)
        addButton.addTarget(self, action: #selector(add), for: .touchUpInside)
        
        subButton.frame = CGRect(x: 274, y: 544, width: 80, height: 80)
        subButton.setTitle("sub", for: .normal)
        subButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
        view.addSubview(subButton)
        subButton.addTarget(self, action: #selector(sub), for: .touchUpInside)
        //274 544
        
        
        
    }
    
    
    @objc func add () {
        num += 1
        label.text = String(num)
        label.textColor = .blue
    }
    
    @objc func sub() {
        num -= 1
        label.text = String(num)
        label.textColor = .red
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
