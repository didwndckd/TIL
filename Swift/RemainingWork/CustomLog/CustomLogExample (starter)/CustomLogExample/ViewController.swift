//
//  ViewController.swift
//  CustomLogExample
//
//  Created by giftbot on 2020/01/30.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

struct MyData {
    let data1 = "ASDF"
    let data2 = "ASDF"
    let data3 = "ASDF"
    let data4 = "ASDF"
    let data5 = "ASDF"
    let data6 = "ASDF"
    let data7 = "ASDF"
    let data8 = "ASDF"
    let data9 = "ASDF"
    let data10 = "ASDF"
    let data11 = "ASDF"
}

final class ViewController: UIViewController {
  private let dog = Dog()
  private let cat = Cat()
  private let data = MyData()
    
    //description, debugDescription 을 오버라이드해서 사용할 수 있다.
    override var description: String {
        return "ViewController!!!"
    }
    
    override var debugDescription: String {
        return "ViewController Debug!!!"
    }
    
    
  @IBAction private func didTapPrint(_ sender: Any) {
    print("\n---------- [ print ] ----------\n")
    print("Hello, world!")
    print(1...10)
    print(dog)
    print(cat)
    print(self)
  }
  
  @IBAction private func didTapDebugPrint(_ sender: Any) {
    print("\n---------- [ debugPrint ] ----------\n")
    debugPrint("Hello, world!")
    debugPrint(1...10)
    debugPrint(dog)
    debugPrint(cat)
    debugPrint(self)
  }
  
  @IBAction private func didTapDump(_ sender: Any) {
    print("\n---------- [ dump ] ----------\n")
    dump("Hello, world!")
    dump(1...10)
    dump(dog)
    dump(cat)
    dump(self)
  }
  
  @IBAction private func didTapNSLog(_ sender: Any) {
    // 현재 시간 + 프로젝트 이름 + 프린트
    print("\n---------- [ NSLog ] ----------\n")
    NSLog("Hello, world!")
    NSLog("%@", self)
    NSLog("%d", 1)
    NSLog("%@", dog)
    NSLog("%@", cat.description)
  }
  
  @IBAction private func didTapSpecialLiterals(_ sender: Any) {
    print("\n---------- [ didTapSpecialLiterals ] ----------\n")
    /*
     #file : (String) 파일 이름
     #function : (String) 함수 이름
     #line : (Int) 라인 넘버
     #column : (Int) 컬럼 넘버
     */
    
    print("file", #file)
    print("function", #function)
    print("line:", #line)
    print("column: ", #column)
    
  }
  
  @IBAction private func didTapCustomLog(_ sender: Any) {
    print("\n---------- [ Custom Log ] ----------\n")
    logger(dog, header: "Dog")
  }
  
  @IBAction private func didTapTestButton(_ sender: Any) {
    print("\n---------- [ Test ] ----------\n")
    // 테스트용 버튼
  }
}



