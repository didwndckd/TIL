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

    
    weak var delegate: CustomViewDelegate?
    
    override var backgroundColor: UIColor? { // 프로퍼티 옵저버 사용 불가
                                            // 오버라이드 프로퍼티는 저장프로퍼티로 사용할 수 없다
        get{                                // 연산 프로퍼티만 가능함
            return super.backgroundColor
        }
        set{
//            self.backgroundColor //-> 자기자신에게 계속 접근한다(무한 루프에 빠진다)
            
            //newValue가 nil이 들어오면 백그라운드 컬러를 black으로 바꾸고 리턴
//            guard let value = newValue else {
//                super.backgroundColor = .black
//                print("nil 들어옴")
//                return
//            }
//
//            if value == .red {
//                super.backgroundColor = .blue
//                print("red 색상 들어옴")
//            }else {
//                super.backgroundColor = value
//                print("변경될 색: \(super.backgroundColor!)")
//            }
//             델리게이트 쓰기 전
            
            
            let color = delegate?.colorForBackground(newValue)
            let newColor = color ?? newValue ?? .gray
            print("델리게이트: \(delegate)")
            super.backgroundColor = newColor
            print("새로 변경될 색은: \(newColor)")
            
        }
        
    }
    
    

}
