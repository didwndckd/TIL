//
//  ViewController.swift
//  CalculatorExample
//
//  Created by giftbot on 2019/12/19.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var additionButton: CustomButton!
    @IBOutlet weak var divisionButton: CustomButton!
    @IBOutlet weak var multiplicationButton: CustomButton!
    @IBOutlet weak var subtractionButton: CustomButton!
    @IBOutlet weak var displayLabel: UILabel!
    var buttons: [CustomButton] = []
   
    
    var value: Double = 0
    var currentNumbertext = "0"
    var currentNumber: Double = 0
    
    let model = Model(currentOperator: .none)

  override func viewDidLoad() {
    super.viewDidLoad()
    buttons = [additionButton, divisionButton, multiplicationButton, subtractionButton]
  }
    
    @IBAction func didTapNumber(_ sender: UIButton) {
        
        print("didTapNumber:", sender.tag)
        sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(0.5)
        
        UIView.animate(withDuration: 0.1, animations: {(
            sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(1)
            )})
        
        guard currentNumbertext.count < 13 else {return}
        currentNumbertext += "\(sender.tag)"
        disPlay(number: currentNumbertext)
         
        
    }
    
    func disPlay(number: String) {
        
        guard let displayNumber = Double(number) else {return}
        
        currentNumber = displayNumber
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        print(displayLabel.font.pointSize)
        let finalDisplayNumber = formatter.string(from: displayNumber as NSNumber)
        displayLabel.text = finalDisplayNumber
    }
    
    func setLabeltoValue(value: Double) {
        
        self.value = value
        currentNumbertext = ""
        currentNumber = value
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        let finalDisplayNumber = formatter.string(from: self.value as NSNumber)
        displayLabel.text = finalDisplayNumber
        

        
    }
    
    @IBAction func AllClear(_ sender: UIButton) {
        
        sender.backgroundColor = .gray
        
        UIView.animate(withDuration: 0.1, animations: {(
            sender.backgroundColor = .lightGray
            )})
        
        value = 0
        currentNumbertext = ""
        model.currentOperator = .none
        displayLabel.text = "0"
    }
    
    func selectOperator(sender: UIButton) {
        
        for i in buttons {
            if sender.restorationIdentifier == i.restorationIdentifier {
                i.backgroundColor = i.backgroundColor?.withAlphaComponent(0.5)
            }else{
                i.backgroundColor = i.backgroundColor?.withAlphaComponent(1)
            }
        }
        
    }
    
    
    
    
    @IBAction func didTapOperationButton(_ sender: UIButton) {
        
        selectOperator(sender: sender)
        
        switch sender.restorationIdentifier {
        case "addition":
            
            print("addition")
            guard Double(currentNumbertext) != nil else {
                model.currentOperator = .addition
                return
            }
            guard model.currentOperator != .none else {
                model.currentOperator = .addition
                value = currentNumber
                currentNumbertext = ""
                return
            }
            
            let value = model.currentOperator.operation(value: self.value, currentNumber: currentNumber)
            
            setLabeltoValue(value: value)
            model.currentOperator = .addition
            
        case "subtraction":
            print("subtraction")
            
            guard Double(currentNumbertext) != nil else {
                model.currentOperator = .subtraction
                return
            }
            guard model.currentOperator != .none else {
                model.currentOperator = .subtraction
                value = currentNumber
                currentNumbertext = ""
                return
            }
            
            let value = model.currentOperator.operation(value: self.value, currentNumber: currentNumber)
            
            setLabeltoValue(value: value)
            model.currentOperator = .subtraction
            
        case "multiplication":
            print("multiplication")
            
            guard Double(currentNumbertext) != nil else {
                model.currentOperator = .multiplication
                return
            }
            guard model.currentOperator != .none else {
                model.currentOperator = .multiplication
                value = currentNumber
                currentNumbertext = ""
                return
            }
            
            let value = model.currentOperator.operation(value: self.value, currentNumber: currentNumber)
            
            setLabeltoValue(value: value)
            model.currentOperator = .multiplication
            
        case "division":
            print("division")
            guard Double(currentNumbertext) != nil else {
                model.currentOperator = .division
                return
            }
            guard model.currentOperator != .none else {
                model.currentOperator = .division
                value = currentNumber
                currentNumbertext = ""
                return
            }
            
            let value = model.currentOperator.operation(value: self.value, currentNumber: currentNumber)
            
            setLabeltoValue(value: value)
            model.currentOperator = .division
            
        case "equal":
            print("equal")
            sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(0.5)
            UIView.animate(withDuration: 0.1, animations: {(
                sender.backgroundColor = sender.backgroundColor?.withAlphaComponent(1)
                
                )})
            guard model.currentOperator != .none else {
                model.currentOperator = .none
                currentNumbertext = ""
                return
            }
            
            let value = model.currentOperator.operation(value: self.value, currentNumber: currentNumber)
            
            setLabeltoValue(value: value)
            model.currentOperator = .none
            
        default:
            return
        }
        
    }
    
    
    
    
}
