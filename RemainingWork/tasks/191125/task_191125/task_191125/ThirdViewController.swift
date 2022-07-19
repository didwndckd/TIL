//
//  ThirdViewController.swift
//  task_191125
//
//  Created by 양중창 on 2019/11/25.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ThirdViewController: UIViewController {
    
    var count = 1
    let button = UIButton(type: .system)
    let label = UILabel()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        setLabel()
        setButton()
        // Do any additional setup after loading the view.
    }
    
    func setLabel() {
        label.frame.size = CGSize(width: view.frame.size.width, height: 100)
        label.center.x = view.center.x
        label.center.y = view.center.y - 100
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        label.text = "Third View: \(count)"
        view.addSubview(label)
    }
    
    func setButton() {
        button.frame.size = CGSize(width: 100, height: 100)
        button.center.x = view.center.x
        button.center.y = view.center.y + 100
        button.setTitle("Go Back First View", for: .normal)
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func tapButton(_ button: UIButton) {
        guard let vc = presentingViewController?.presentingViewController
            as? ViewController else {return}
        vc.count = count + 1
        vc.dismiss(animated: true)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        print("써드 디드디스어피어")
//        print(presentingViewController)
//        guard let vc = presentingViewController as? NextViewController else{return}
//        vc.count = count + 1
//        vc.label.text = "Second View: \(vc.count)"
//        
//    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
