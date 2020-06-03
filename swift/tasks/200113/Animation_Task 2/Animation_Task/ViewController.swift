//
//  ViewController.swift
//  Animation_Task
//
//  Created by 양중창 on 2020/01/13.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class Buttons {
    let button: UIButton
    let bottomConstraint: NSLayoutConstraint
    let haveMarginConstraint: NSLayoutConstraint
    init(button: UIButton, bottomConstraint: NSLayoutConstraint, haveMarginConstraint: NSLayoutConstraint) {
        self.button = button
        self.bottomConstraint = bottomConstraint
        self.haveMarginConstraint = haveMarginConstraint
    }
}

class ViewController: UIViewController {
    
    private let leftBaseButton = UIButton(type: .system)
    private let rightBaseButton = UIButton(type: .system)
    private var leftButtons: [Buttons] = []
    private var leftButtonStatus = true
    private var rightButtons: [Buttons] = []
    private var rightButtonStatus = true

    override func viewDidLoad() {
        super.viewDidLoad()
        leftBaseButton.addTarget(self, action: #selector(didTapLeftButton), for: .touchUpInside)
        rightBaseButton.addTarget(self, action: #selector(didTapRightButton), for: .touchUpInside)
        
        setupLeftButtons()
        setupRightButtons()
    }
    
    @objc private func didTapLeftButton() {
        if leftButtonStatus {
            self.leftButtonStatus = false
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [],
                           animations: {
                            for button in self.leftButtons {
                                let margin = button.button.bounds.width + 16
                                button.bottomConstraint.constant -= margin
                                button.button.transform = .identity
                                self.view.layoutIfNeeded()
                                // view.layoutIfNeeded() ->
                                // 원래는 런루프를 돌다가 돌아 왔을때 UI의 변경사항을 적용하는데
                                // layoutIfNeeded()를 사용하면 런루프를 기다리지않고 즉시 적용한다
                            }
                            
            })
        }else {
            self.leftButtonStatus = true
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: [],
                           animations: {
                            for (index, button) in self.leftButtons.enumerated() {
                                let margin: CGFloat = 32
                                button.button.transform = .init(scaleX: 0.2, y: 0.2)
                                button.bottomConstraint.constant = index == 0 ? -margin : 0
                                self.view.layoutIfNeeded()
                            }
                            
            })
        }

        
        
    }
    
    @objc private func didTapRightButton() {
        
//         addkeyframe
//         option -> begainFromCurrentState
        let withDuration = 1.0
        if rightButtonStatus {
            rightButtonStatus = false

            UIView.animateKeyframes(
                withDuration: withDuration,
                delay: 0,
                options: [.beginFromCurrentState],
                animations: {
                    let buttons = self.rightButtons
                    for (index, buttonsObject) in buttons.enumerated() {
                        let startTime = Double(index) / Double(buttons.count)
                        let relativeDutation = withDuration / Double(buttons.count)

                        let margin: CGFloat = buttonsObject.button.bounds.height + 16
                        print("strarTime: \(startTime), Dutaition: \(relativeDutation)")
                        UIView.addKeyframe(
                            withRelativeStartTime: startTime,
                            relativeDuration: relativeDutation,
                            animations: {
                                buttonsObject.button.transform = .identity
//                                buttonsObject.button.center.y -= margin
                                buttonsObject.bottomConstraint.constant -= margin
                                self.view.layoutIfNeeded()
                                
                        })
                    }
                    

            },
                completion: {
                    (bool) in
                    print(bool)
            })
        }else {
            rightButtonStatus = true
            UIView.animateKeyframes(
                withDuration: withDuration,
                delay: 0,
                options: [.beginFromCurrentState],
                animations: {

                    var buttons = self.rightButtons
                    buttons.reverse()
                    for (index, buttonsObject) in buttons.enumerated() {
                        let startTime = Double(index) / Double(buttons.count)
                        let relativeDutation = withDuration / Double(buttons.count)
                        let margin: CGFloat = buttonsObject.button.bounds.height + 16
                        print("strarTime: \(startTime), Dutaition: \(relativeDutation)")
                        UIView.addKeyframe(
                            withRelativeStartTime: startTime,
                            relativeDuration: relativeDutation,
                            animations: {
                                buttonsObject.button.transform = .init(scaleX: 0.4, y: 0.4)
//                                buttonsObject.button.center.y += margin
                                buttonsObject.bottomConstraint.constant += margin
                                self.view.layoutIfNeeded()
//                                self.view.setNeedsLayout()
                        })
                       
                    }
                     

            },
                completion: {
                    (bool) in
                    print(bool)
            })
        }
        

        
    }
    
    private func setupLeftButtons() {
        
        // using
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 32
        let size: CGFloat = 72
        
        
        
        
        for i in 0...4 {
            
            let button = UIButton(type: .system)
            let bottomConstraint: NSLayoutConstraint
            button.setTitle("버튼 \(i+1)", for: .normal)
            button.backgroundColor = setColor()
            view.addSubview(button)
            
            button.translatesAutoresizingMaskIntoConstraints = false
            
            bottomConstraint = i == 0 ?
                button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -margin) :
                button.bottomAnchor.constraint(equalTo: leftButtons[i - 1].button.bottomAnchor)
            
            bottomConstraint.isActive = true
            button.leadingAnchor.constraint(equalTo: guide.leadingAnchor , constant: margin).isActive = true
            button.widthAnchor.constraint(equalToConstant: size).isActive = true
            button.heightAnchor.constraint(equalToConstant: size).isActive = true
            button.layer.cornerRadius = size / 2
            button.transform = .init(scaleX: 0.4, y: 0.4)
            leftButtons.append(Buttons(button: button, bottomConstraint: bottomConstraint, haveMarginConstraint: NSLayoutConstraint()))
        }
        
        view.addSubview(leftBaseButton)
        leftBaseButton.translatesAutoresizingMaskIntoConstraints = false
        leftBaseButton.backgroundColor = .green
        leftBaseButton.setTitle("버튼 0 ", for: .normal)
        
        leftBaseButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor , constant: margin).isActive = true
        leftBaseButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -margin).isActive = true
        leftBaseButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        leftBaseButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        leftBaseButton.layer.cornerRadius = size / 2
        
        
        
    }
    
    private func setupRightButtons() {
        
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 32
        let size: CGFloat = 72
        
        
        for i in 0...4 {
            let button = UIButton(type: .system)
            let bottomConstraint: NSLayoutConstraint
            let haveMarginConstraint: NSLayoutConstraint
            
            button.setTitle("버튼 \(i + 1)", for: .normal)
            button.backgroundColor = setColor()
            
            button.translatesAutoresizingMaskIntoConstraints = false
            if i == 0 {
                view.addSubview(button)
                bottomConstraint = button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -margin)
                haveMarginConstraint = button.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -(margin*2 + size))
                
            }else {
                rightButtons[i - 1].button.addSubview(button)
                bottomConstraint = button.bottomAnchor.constraint(equalTo:
                    rightButtons[i - 1].button.bottomAnchor)
                haveMarginConstraint = button.bottomAnchor.constraint(equalTo:
                rightButtons[i - 1].button.bottomAnchor, constant: -(margin + size) )
            }
            
            bottomConstraint.isActive = true
            button.trailingAnchor.constraint(equalTo: guide.trailingAnchor,
                                             constant: -margin ).isActive = true
            button.widthAnchor.constraint(
                equalToConstant: size).isActive = true
            button.heightAnchor.constraint(
                equalToConstant: size).isActive = true
            button.layer.cornerRadius = size / 2
            button.transform = .init(scaleX: 0.4, y: 0.4)
            rightButtons.append(Buttons(button: button, bottomConstraint: bottomConstraint, haveMarginConstraint: haveMarginConstraint))
            
            
        }
        rightButtons.reverse()
        
        view.addSubview(rightBaseButton)
        rightBaseButton.translatesAutoresizingMaskIntoConstraints = false
        rightBaseButton.backgroundColor = .red
        rightBaseButton.setTitle("버튼 0 ", for: .normal)
        
        rightBaseButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor , constant: -margin).isActive = true
        rightBaseButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -margin).isActive = true
        rightBaseButton.widthAnchor.constraint(equalToConstant: size).isActive = true
        rightBaseButton.heightAnchor.constraint(equalToConstant: size).isActive = true
        rightBaseButton.layer.cornerRadius = size / 2
        
        
        rightButtons.reverse()
    }
    
    private func setColor() -> UIColor {
        let red = CGFloat(drand48())
        let blue = CGFloat(drand48())
        let green = CGFloat(drand48())
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        return color
    }
    
    
    override func viewLayoutMarginsDidChange() {
        super.viewLayoutMarginsDidChange()
    }
    
    


}

