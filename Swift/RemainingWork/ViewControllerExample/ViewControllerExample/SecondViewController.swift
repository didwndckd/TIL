//
//  SecondViewController.swift
//  ViewControllerExample
//
//  Created by 양중창 on 2019/11/25.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    let button = UIButton()
    let button2 = UIButton()
    let tag = "Second View Controller"
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tag+"View Did Load")
        view.backgroundColor = .green
        if #available(iOS 13.0, *){
//        isModalInPresentation = true // 카드뷰를 내리지못하게 막는메서드
        }
        setButton()
        thirdButton()
        
        // Do any additional setup after loading the view.
    }
    
    func thirdButton() {
        button2.frame.size = CGSize(width: 100, height: 50)
        button2.center.x = view.center.x + 100
        button2.center.y = view.center.y
        button2.setTitle("Third View", for: .normal)
        button2.addTarget(self, action: #selector(goThird(_:)), for: .touchUpInside)
        view.addSubview(button2)
    }
    
    @objc func goThird(_ sender: UIButton) {
        let thirdView = ThirdViewController()
//        thirdView.modalPresentationStyle = .fullScreen
        present(thirdView, animated: true)
    }
    
    
    func setButton() {
        
        button.frame.size = CGSize(width: 100, height: 50)
        button.center.x = view.center.x - 100
        button.center.y = view.center.y
        print(view.center)
        button.setTitle("First View", for: .normal)
        button.addTarget(self, action: #selector(tapButton(_:)), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    @objc func tapButton(_ button: UIButton){
//        print(presentingViewController) // 나를 띄운 뷰 컨트롤러
//        print(presentedViewController)  // 내가 띄운 뷰 컨트롤러
//        print(presentingViewController?.presentedViewController)
//        self.presentingViewController?.view.backgroundColor = .red
//
//        guard let vc = presentingViewController as? ViewController else {
//            return
//        }
//       vc.button.setTitle("AAAAA", for: .normal)
        
        
        dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(tag+"view Will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(tag+"view Did Appear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(tag+"view Will Disappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(tag+"view Did Disappear")
    }
    
    deinit {
        print(tag+"deinit")
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



