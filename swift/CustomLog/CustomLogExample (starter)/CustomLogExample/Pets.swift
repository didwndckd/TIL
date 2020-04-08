//
//  Pets.swift
//  CustomLogExample
//
//  Created by giftbot on 2020/01/30.
//  Copyright © 2020 giftbot. All rights reserved.
//

import Foundation

class Dog: NSObject {
    // CustomStringConvertible 프로토콜을 채택하면 프린트할때 description에 정의한 문자열을 출력한다.
    // CustomDebugStringConvertible 프로토콜은 마찬가지로 debugprint 할때 debugDescription에 정의한 문자열을 출력
    override var debugDescription: String {
        "Dog's name: \(name), age: \(age), feature: \(feature)"
    }
    
    override var description: String {
        "Dog's name: \(name), age: \(age) "
    }
  let name = "Tory"
  let age = 5
  let feature: [String: String] = [
    "breed": "Poodle",
    "tail": "short"
  ]
    
    
    
    
}

struct Cat {
    var description: String {
        "Cat's name: \(name), age: \(age)"
    }
  let name = "Lilly"
  let age = 2
  let feature: [String: String] = [
    "breed": "Koshort",
    "tail": "short"
  ]
}
