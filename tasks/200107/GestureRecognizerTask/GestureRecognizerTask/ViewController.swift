//
//  ViewController.swift
//  GestureRecognizerTask
//
//  Created by 양중창 on 2020/01/07.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var model = Model()
    private let myView = CustomView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let touchBeganButton = UIBarButtonItem(title: "TouchBegan", style: .done, target: self, action: #selector(didTapToolbar(_:)))
        touchBeganButton.tag = 0
        
        let tapGestureButton = UIBarButtonItem(title: "TapGesture", style: .done, target: self, action: #selector(didTapToolbar(_:)))
        tapGestureButton.tag = 1
        
        let delegateButton = UIBarButtonItem(title: "Delegate", style: .done, target: self, action: #selector(didTapToolbar(_:)))
        delegateButton.tag = 2
        
        navigationController?.isToolbarHidden = false
        toolbarItems = [touchBeganButton, tapGestureButton, delegateButton]
        
        myView.delegate = self
        setupView()
        
    }
    
    @objc func didTapToolbar (_ sender: UIBarButtonItem) {
        print(sender.tag)
        myView.mode = sender.tag
    }
    
    private func setupView() {
        view.addSubview(myView)
        myView.translatesAutoresizingMaskIntoConstraints = false
        let guide = view.safeAreaLayoutGuide
        
        myView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        myView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        myView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        myView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        
    }


}

extension ViewController: CustomViewDelegate {
    func tapGestureAction(point: CGPoint) -> Int {
        guard let lastPoint = model.lastPoint else {
            model.lastPoint = point
            model.count = 1
            return 1}
        let dePointX = abs(lastPoint.x - point.x)
        let dePointY = abs(lastPoint.y - point.y)
        
//        print("x: \(dePointX), y: \(dePointY)")
        print((pow(dePointX, 2) + pow(dePointY, 2)).squareRoot())
        if (pow(dePointX, 2) + pow(dePointY, 2)).squareRoot() >= 10 {
            model.lastPoint = point
            model.count = 1
            return model.count
        }else {
            model.lastPoint = point
            model.count += 1
            return model.count
        }
        
    }
    
    
}

