//
//  ViewController.swift
//  ViewControllerExample
//
//  Created by 양중창 on 2019/11/25.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let button = UIButton(type: .system)
    let tag = "First View Controller"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(tag+"-view Did Load")
        // Do any additional setup after loading the view.
        
        
        setupBtn()
        
        
    }
    
    func setupBtn(){
        
        if #available(iOS 13.0, *){
            view.backgroundColor = .systemBackground
        }else{
            view.backgroundColor = .white
        }
        
        
        button.frame.size = CGSize(width: 100, height: 50)
        button.center = view.center
        button.setTitle("Button", for: .normal)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.addSubview(button)
    }
    
    
    @objc func didTapButton(_ sender: UIButton){
        let nextVC = SecondViewController()
//        nextVC.modalPresentationStyle = .fullScreen
        nextVC.view.backgroundColor = .blue
        nextVC.presentationController?.delegate = self //프레젠테이션할 때 내가 컨트롤 하겠다
        present(nextVC, animated: true)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(tag+"-view Will Appear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(tag+"-view Did Appear")
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(tag+"-view Will Disappear")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(tag+"-view Did Disappear")
    }

    
    

}

extension ViewController: UIAdaptivePresentationControllerDelegate {
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        print("디드 디스미스")
    }
    
    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        print("윌 디스미스")
    }
    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
        print("슈드 디스미스")
        return true
    }
    
    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
        print("디드엣템프투디스미스")
    }
    
}

