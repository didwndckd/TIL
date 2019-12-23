//
//  Model.swift
//  CalculatorExample
//
//  Created by 양중창 on 2019/12/20.
//  Copyright © 2019 giftbot. All rights reserved.
//

import Foundation

enum Operator {
    case addition, subtraction, multiplication, division, equal, none
    
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
            return 123456778
        }
        
        
    }
}



struct Model {
    
    private var _currentOperator: Operator = .none
    private var _value: Double = 0
    private var _currentNumbertext = "0"
    private var _currentNumber: Double = 0
    
    
     var value: Double {
        get{
            return _value
        }
        set{
            _value = newValue
        }
    }
    
    var currentNumbertext: String {
        get {
            return _currentNumbertext
        }
        set {
            _currentNumbertext = newValue
        }
    }
    
    var currentNumber: Double {
        get {
            return _currentNumber
        }
        set {
            _currentNumber = newValue
        }
    }
    
    var currentOperator: Operator {
        get {
            return _currentOperator
        }
        set {
            _currentOperator = newValue
        }
        
    }
    
    mutating func operation(paramOperator: Operator) -> Double? {
        
        if paramOperator != .equal{
            guard !_currentNumbertext.isEmpty else {
                _currentOperator = paramOperator
                return nil
            }
        }
        
        guard _currentOperator != .none else {
            _currentOperator = paramOperator
            _currentOperator = paramOperator == .equal ? .none : paramOperator
            _value = _currentNumber
            _currentNumbertext = ""
            return nil
        }
        
        let finalValue = _currentOperator.operation(value: _value, currentNumber: _currentNumber)
        
        _value = finalValue
        _currentNumbertext = ""
        _currentNumber = finalValue
        _currentOperator = paramOperator == .equal ? .none : paramOperator
        
        
        return finalValue
    }
    
    
    
}
