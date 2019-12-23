//
//  CustomButton.swift
//  CalculatorExample
//
//  Created by 양중창 on 2019/12/20.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit


class CustomButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
    }
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        layer.cornerRadius = 45
        addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    }
    
    @objc func didTapButton (_ sender: UIButton) {
        if let identifier = restorationIdentifier {
            
            switch identifier {
            case "equal":
                blinkEvent()
            case "AllClear":
                blinkEvent()
            default:
                print("Button")
                didTapOperatorButton()
            }
            
        }else{
            blinkEvent()
        }
        
    }
    
    private func blinkEvent () {
        backgroundColor = backgroundColor?.withAlphaComponent(0.5)
        UIView.animate(withDuration: 0.1, animations: {(
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1)
        )})
    }
    
    private func didTapOperatorButton() {
        backgroundColor = backgroundColor?.withAlphaComponent(0.5)
    }
    
    func didTapOtherOperatorButton() {
       backgroundColor = backgroundColor?.withAlphaComponent(1)
    }
    
    
    
}
