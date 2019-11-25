//
//  NextViewController.swift
//  task_191125
//
//  Created by 양중창 on 2019/11/25.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    
    var count: Int = 0
    let label = UILabel()
    let button = UIButton(type: .system)
    let button2 = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray
        setLabel()
        setButton()
        setButton2()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        label.text = "Second View: \(count)"
        print("어피어")
    }
    
    
    func setButton2() {
        button2.frame.size = CGSize(width: 100, height: 50)
        button2.center.x = view.center.x
        button2.center.y = view.center.y + 200
        button2.setTitle("NextView", for: .normal)
        button2.addTarget(self, action: #selector(tapButton2(_:)), for: .touchUpInside)
        view.addSubview(button2)
    }
    
    @objc func tapButton2(_ sender: UIButton) {
        let thirdView = ThirdViewController()
        thirdView.presentationController?.delegate = self
        thirdView.count = count + 1
        present(thirdView, animated: true)
    }
    
    
    
    func setButton() {
        button.frame.size = CGSize(width: 100, height: 50)
        button.center.x = view.center.x
        button.center.y = view.center.y + 100
        button.setTitle("beforeView", for: .normal)
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    @objc func tapButton(_ Button: UIButton) {
        guard let vc = presentingViewController as? ViewController else{return}
        vc.count = count + 1
        dismiss(animated: true)
    }
    
    
    func setLabel() {
        label.frame.size = CGSize(width: view.frame.size.width, height: 100)
        label.center.y = view.center.y - 200
        label.center.x = view.center.x
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        view.addSubview(label)
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




extension NextViewController: UIAdaptivePresentationControllerDelegate{
    
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("디드 디스미스")
        
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("윌 디스미스")
        guard let vc = presentedViewController as? ThirdViewController else { return  }
        count = vc.count + 1
        label.text = "Second View \(count)"
        
        
    }
    
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        print(presentedViewController)
        print("슈드 디스미스")
        return true
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print("디드 엣텀프투 디스미스")
    }
    
    
    
    
    
    
    
}
