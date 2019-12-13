//
//  CustomView.swift
//  DelegateExample
//
//  Created by 양중창 on 2019/12/10.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

// 프로토콜 정의

protocol CustomViewDelegate: class {// :class 해주는 이유 -> 사용할 때 weak를 하기 위해서 class로 한정 지어줘야 함
    func colorForBackground(_ newColor: UIColor?) -> UIColor
}

class CustomView: UIView {

    
     var delegate: CustomViewDelegate? {
        didSet {
            guard let delegate = delegate else { return }
            print("NextViewController customView delegate : \(CFGetRetainCount(delegate))")
        }
    }
    
    
    override var backgroundColor: UIColor? { // 프로퍼티 옵저버 사용 불가
                                            // 오버라이드 프로퍼티는 저장프로퍼티로 사용할 수 없다
        get{                                // 연산 프로퍼티만 가능함
            return super.backgroundColor
        }
        set{
            
            let color = delegate?.colorForBackground(newValue)
            let newColor = color ?? newValue ?? .gray
           // print("델리게이트: \(delegate)")
            super.backgroundColor = newColor
            print("새로 변경될 색은: \(newColor)")
            
        }
        
    }
    
    deinit {
        print("deinit CustomView")
    }
    
    

}
