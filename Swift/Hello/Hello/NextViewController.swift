//
//  NextViewController.swift
//  Hello
//
//  Created by 양중창 on 2019/11/21.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {

    
    let blueView = UIView()
    let redView = UIView()
    let greenView = UIView()
    let MyLable = UILabel()
    let MyButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        blueView.backgroundColor = .blue
        blueView.frame = CGRect(x: 100, y: 0, width: 100, height: 100)
        view.addSubview(blueView)
        
        redView.backgroundColor = . red
        redView.frame = CGRect(x: 100, y: 150, width: 100, height: 100)
        view.addSubview(redView)
        
        greenView.backgroundColor = .green
        greenView.frame = CGRect(x: 100, y: 350 , width: 100, height: 100)
        view.addSubview(greenView)
        
        MyLable.frame = CGRect(x: 100, y: 500, width: 50, height: 50)
        
        MyLable.text = "중창짱"
        view.addSubview(MyLable)
        //MyLable.text = "중창쓰"
        
        
       
        MyButton.frame = CGRect(x: 100, y: 600, width: 50, height: 50)
        MyButton.setTitle("버튼입니다요", for: .normal)//
        view.addSubview(MyButton)
        
        MyButton.addTarget(self, action: #selector(clickButton), for: .touchUpInside)
        
        

        // Do any additional setup after loading the view.
    }
    
    @objc func clickButton () {
        print("버튼눌렀다^^")
        MyButton.setTitle("ㅎㅎㅎㅎㅎ", for: .normal)
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
