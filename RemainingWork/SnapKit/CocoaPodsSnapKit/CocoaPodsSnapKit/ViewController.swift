//
//  ViewController.swift
//  CocoaPodsSnapKit
//
//  Created by 양중창 on 2020/02/20.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let squareView = UIView()
    let topView = UIView()
    let bottomView = UIView()
    let topLable = UILabel()
    let bottomLable = UILabel()
    let circleView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
    }

    func setupUI() {
        view.addSubview(squareView)
        view.addSubview(circleView)
        squareView.addSubview(topView)
        squareView.addSubview(bottomView)
        topView.addSubview(topLable)
        bottomView.addSubview(bottomLable)
        
        squareView.backgroundColor = .green
        
        topView.backgroundColor = .systemPink
        
        bottomView.backgroundColor = .yellow
        
        topLable.text = "Top"
        topLable.textAlignment = .center
        
        
        bottomLable.text = "Bottom"
        bottomLable.textAlignment = .center
        
        circleView.backgroundColor = .cyan
        
        setupSnapKit()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.animate(withDuration: 2, animations: {
            self.circleView.snp.updateConstraints {
                $0.top.equalTo(self.squareView.snp.bottom).offset( -self.squareView.frame.height - self.circleView.frame.height)
            }
            self.view.layoutIfNeeded()
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        circleView.layer.cornerRadius = circleView.frame.width / 2
    }
    
    func setupSnapKit() {
        
        squareView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(50)
            $0.trailing.equalToSuperview().offset(-50)
            $0.top.equalToSuperview().offset(200)
            $0.bottom.equalToSuperview().offset(-200)
        }
        
        topView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(20)
//            $0.height.equalToSuperview().multipliedBy(0.5)
        }
        
        bottomView.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview().inset(20)
            $0.top.equalTo(topView.snp.bottom)
            $0.height.equalTo(topView)
        }
        
        topLable.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        bottomLable.snp.makeConstraints {
            $0.size.equalTo(topLable)
            $0.leading.bottom.equalToSuperview()
        }
        
        circleView.snp.makeConstraints {
            $0.top.equalTo(squareView.snp.bottom)
            $0.centerX.equalTo(squareView)
            $0.size.equalTo(squareView.snp.width).dividedBy(2)
        }
    }

}

