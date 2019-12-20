//
//  Model.swift
//  CalculatorExample
//
//  Created by 양중창 on 2019/12/20.
//  Copyright © 2019 giftbot. All rights reserved.
//

import Foundation




class Model {
    
    enum Operator {
        case addition, subtraction, multiplication, division, none
        
        func operation(value: Double, currentNumber: Double) -> Double {
            
            
            switch self {
            case .addition:
                return value + currentNumber
            case . subtraction:
                return value - currentNumber
            case .multiplication:
                return value * currentNumber
            case .division:
                return value / currentNumber
            default:
                return 0
            }
            
            
        }
    }
    
    var currentOperator: Operator
    
    init(currentOperator: Operator) {
        self.currentOperator = currentOperator
        
        
        
    }
    
}
