//
//  View.swift
//  GestureRecognizerTask
//
//  Created by 양중창 on 2020/01/07.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

protocol CustomViewDelegate: class {
    func tapGestureAction(point: CGPoint) -> Int
}

class CustomView: UIView {
    
    private let pointLabel = UILabel()
    private let countLabel = UILabel()
    weak var delegate: CustomViewDelegate?
    var mode = 0

    init() {
        super.init(frame: .zero)
        backgroundColor = .systemBackground
        setupUI()
        let tapGestrue = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tapGestrue)
        
        let gestureReco = UIGestureRecognizer()
        gestureReco.delegate = self
        addGestureRecognizer(gestureReco)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTapGesture(_ sender: UITapGestureRecognizer) {
        
        guard mode == 1 else {return}
        
        print("tapGesture", mode)
        
        let point = sender.location(in: sender.view)
        
        let formetter = NumberFormatter()
        formetter.minimumFractionDigits = 0
        formetter.maximumFractionDigits = 1
        guard let pointX = formetter.string(from: point.x as NSNumber) else { return }
        guard let pointY = formetter.string(from: point.y as NSNumber) else { return }
        
        
        pointLabel.text = "좌표 x: \(pointX) , y: \(pointY)"
        if let count = delegate?.tapGestureAction(point: point){
        countLabel.text = "누른 횟수: \(count)"
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        guard mode == 0 else {return}
        print("touchBegan", mode)
        guard let touch = touches.first else { return }
        let point = touch.location(in: touch.view)
        
        let formetter = NumberFormatter()
        formetter.minimumFractionDigits = 0
        formetter.maximumFractionDigits = 1
        guard let pointX = formetter.string(from: point.x as NSNumber) else { return }
        guard let pointY = formetter.string(from: point.y as NSNumber) else { return }
        
        
        pointLabel.text = "좌표 x: \(pointX) , y: \(pointY)"
        if let count = delegate?.tapGestureAction(point: point){
        countLabel.text = "누른 횟수: \(count)"
        
        }
        
    }
    
    private func setupUI() {
        
        addSubview(countLabel)
        addSubview(pointLabel)
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        pointLabel.translatesAutoresizingMaskIntoConstraints = false
        
        countLabel.text = "누른 횟수: 0"
        pointLabel.text = "좌표 x: 0 , y: 0"
        
        countLabel.font = .systemFont(ofSize: 20)
        pointLabel.font = .systemFont(ofSize: 20)
        
        let margin: CGFloat = 30
        
        countLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: margin).isActive = true
        countLabel.topAnchor.constraint(equalTo: topAnchor, constant: margin).isActive = true
        
        pointLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: margin).isActive = true
        pointLabel.leadingAnchor.constraint(equalTo: countLabel.leadingAnchor).isActive = true
        
        
    }
    
  
    
    

    
    
    
    
}

extension CustomView:  UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard mode == 2 else {return false}
        print("shouldRecive", mode)
        
        let point = touch.location(in: touch.view)
        
        let formetter = NumberFormatter()
        formetter.minimumFractionDigits = 0
        formetter.maximumFractionDigits = 1
        guard let pointX = formetter.string(from: point.x as NSNumber) else { return false }
        guard let pointY = formetter.string(from: point.y as NSNumber) else { return false }
        
        
        pointLabel.text = "좌표 x: \(pointX) , y: \(pointY)"
        if let count = delegate?.tapGestureAction(point: point){
        countLabel.text = "누른 횟수: \(count)"
        
        }
        
        
        return true
    }
}
