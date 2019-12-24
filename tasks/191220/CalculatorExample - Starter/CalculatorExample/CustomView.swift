//
//  CustomView.swift
//  CalculatorExample
//
//  Created by 양중창 on 2019/12/23.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

protocol CustomViewDelegate: class {
    
    func tapNumberButtonAction(tag: Int) -> String?
    
    func allClearAction()
    
    func operationAction(argumentOperator: Operator) -> String?
    
}

class CustomView: UIView {

    weak var delegate: CustomViewDelegate?
   
    @IBOutlet weak private var displayLabel: UILabel!
    private var beforeButton: UIButton?

    
    @IBAction func didTapNumber(_ sender: UIButton) {
        let displayText = delegate?.tapNumberButtonAction(tag: sender.tag)

        print("didTapNumber:", sender.tag)
        displayLabel.text = displayText
        
        if let button = beforeButton as? CustomButton {
                   button.didTapOtherOperatorButton()
               }
        beforeButton = nil

    }


    @IBAction func didTapAllClearButton(_ sender: UIButton) {
        displayLabel.text = "0"
        delegate?.allClearAction()
        if let button = beforeButton as? CustomButton {
            button.didTapOtherOperatorButton()
        }
        beforeButton = nil

    }


    
    @IBAction func didTapOperator(_ sender: UIButton) {
                
                (beforeButton as? CustomButton)?.didTapOtherOperatorButton()
                beforeButton = sender
        
               let operation: Operator
               
               switch sender.restorationIdentifier {
               case "addition":
                   print("addition")
                   operation = .addition
                   
               case "subtraction":
                   print("subtraction")
                   operation = .subtraction
                   
               case "multiplication":
                   print("multiplication")
                   operation = .multiplication
                   
               case "division":
                   print("division")
                   operation = .division
                   
               case "equal":
                   print("equal")
                   operation = .equal
                   
               default:
                   return
               }
        
        let displayText = delegate?.operationAction(argumentOperator: operation)
        displayLabel.text = displayText
    }
    
    
    
}
