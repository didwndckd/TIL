//
//  ViewController.swift
//  CalculatorExample
//
//  Created by giftbot on 2019/12/19.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet var myView: CustomView!
    
    private var beforeButton: UIButton?
    
    
    
    var model = Model()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    myView.delegate = self
    
  }
    
    
    func setCurrentNumber(number: String) -> String? {
        
        guard let displayNumber = Double(number) else {return nil}
        
        model.currentNumber = displayNumber
        
        return formatterNumber(number: displayNumber)
        
    }
    
    
    func formatterNumber(number: Double) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        let finalDisplayNumber = formatter.string(from: number as NSNumber)
        return finalDisplayNumber
    }
    
    
    
    
    
    func setValue(value: Double?) -> String? {
        
        guard let finalValue = value else {
            return formatterNumber(number: model.currentNumber)
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 3
        let finalDisplayNumber = formatter.string(from: finalValue as NSNumber)
        return finalDisplayNumber
    }
    
   
    
    
    
    
}



extension ViewController: CustomViewDelegate {
    
    func tapNumberButtonAction(tag: Int) -> String?  {
        
        guard model.currentNumbertext.count < 13 else {
            return formatterNumber(number: model.currentNumber)
            
        }
        model.currentNumbertext += "\(tag)"
        return setCurrentNumber(number: model.currentNumbertext)
        
    }
    
    func allClearAction() {
        model.value = 0
        model.currentNumber = 0
        model.currentNumbertext = ""
        model.currentOperator = .none
    }
    
    func operationAction(argumentOperator: Operator) -> String? {
        let value = model.operation(paramOperator: argumentOperator)
        return setValue(value: value)
    }
    
    
    
    
}
