//
//  ViewController.swift
//  NavigationControllerExample
//
//  Created by 양중창 on 2019/12/23.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .never // 라지타이틀 쓸지 말지 어쩔지
        title = "FirstVC"
        let barButtonItem = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(pushViewController(_:)))
        let barButtonItem2 = UIBarButtonItem(title: "Next2", style: .done, target: self, action: #selector(pushViewController(_:)))
        
        let buttons = [barButtonItem, barButtonItem2]
        
        navigationItem.rightBarButtonItems = buttons
        view.backgroundColor = .yellow
        
    }
    
    @objc func pushViewController(_ sender: Any) {
        
        let seconVC = SecondViewController()
        show(seconVC, sender: nil)
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//        let initalVC = storyBoard.instantiateInitialViewController()
        // 메인 스토리 보드의 시작점 스토리보드를 가져옴
        
//        let secondVC = storyBoard.instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
//        show(secondVC, sender: nil)
        // 메인 스토리보드의 아이덴티를 통해 해당 뷰 컨트롤러를 가져옴
        
        
//        navigationController?.pushViewController(secondVC, animated: true)
        
        
        // 네비게이션의 루트뷰 컨트롤러로 이동
//        navigationController?.popToRootViewController(animated: true)
        
//        let secondVC = SecondViewController()
//
//        show(secondVC, sender: nil)
        
        
        
    }


}

