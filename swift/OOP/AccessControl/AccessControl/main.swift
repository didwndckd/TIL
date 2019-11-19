//
//  main.swift
//  AccessControl
//
//  Created by giftbot on 18/11/2019.
//  Copyright © 2018 giftbot. All rights reserved.
//

import Foundation



/***************************************************
 Internal
 ***************************************************/
print("\n---------- [ Internal ] ----------\n")

let internalClass = InternalClass()
print(internalClass.publicProperty)
print(internalClass.internalProperty)
print(internalClass.defaultProperty)
//print(internalClass.fileprivateProperty)  // 접근 불가
//print(internalClass.privateProperty)      // 접근 불가


/***************************************************
 Fileprivate
 ***************************************************/
print("\n---------- [ Fileprivate ] ----------\n")

//접근 불가
//let fileprivateClass = FileprivateClass()

let anotherClass = SameFileAnotherClass()  // Fileprivate 클래스의 같은 파일에 SameFileAnother 클래스를 만들어서
anotherClass.someFunction()             // SameFileAnother 객체가 someFunction 메서드로  Fileprivate 클래스 에게 접근하게한다


/***************************************************
 Private
 ***************************************************/
print("\n---------- [ Private ] ----------\n")

//접근 불가
//let privateClass = PrivateClass()

let someOtherClass = SomeOtherClass()
someOtherClass.someFunction()
