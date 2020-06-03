//
//  ViewController.swift
//  Hello
//
//  Created by 양중창 on 2019/11/21.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tealview : UIView!
    
    @IBOutlet weak var pupleView: UIView!
    
    @IBOutlet weak var myLabel: UILabel!
    
    @IBOutlet weak var mybtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tealview.backgroundColor = .red
        pupleView.backgroundColor = .green
        
        
        let blueview = UIView()
        blueview.backgroundColor = .blue
        blueview.frame = CGRect(x: 0, y: 0 , width: 100, height: 100)
        blueview.center = view.center
        view.addSubview(blueview)
        
        myLabel.text = "씨이발"
        
        mybtn.setTitle("버튼이셈", for: .normal)
        mybtn.setTitle("눌렸음", for: .highlighted)
        mybtn.setTitle("누르는중", for: .selected)
        
        
    }

    @IBAction func clickbtn(_ sender: Any) {
        print("clickbtn")
        
    }
    
}

