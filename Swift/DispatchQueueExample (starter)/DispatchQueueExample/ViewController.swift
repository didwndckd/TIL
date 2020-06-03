//
//  ViewController.swift
//  DispatchQueueExample
//
//  Created by giftbot on 2020. 2. 12..
//  Copyright © 2020년 giftbot. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  
  @IBOutlet private weak var testView: UIView!

  @IBAction private func buttonDidTap(_ sender: Any) {
    print("---------- [ Change Color ] ----------\n")
    let r = CGFloat.random(in: 0...1.0)
    let g = CGFloat.random(in: 0...1.0)
    let b = CGFloat.random(in: 0...1.0)
    testView.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
  }
    

  func bigTask() {
    print("= Big task start =")
    for _ in 0...5_000_000 { _ = 1 + 1 }
    print("= Big task end =")
  }
  
  @IBAction func bigTaskOnMainThread() {
    print("start")
    bigTask()
    print("end")
    //serial queue 에서 작업 하기 때문에 작업이 끝날때까지 다른작업을 할 수 없다 (동기방식)
  }
  
    
    @IBAction func uiTaskOnBackgroundThread() {
        print("\n---------- [ uiTaskOnBackgroundThread ] ----------\n")
        
        DispatchQueue.global().async { // concurrent - async
            self.bigTask()
            DispatchQueue.main.async { // serial - async
                self.buttonDidTap(self)
                //UI관련 작업은 main에서만 해야 한다.
            }
        }
        
    }
    
  
  func log(_ str: String) {
    print(str, terminator: " - ")
  }
  
  @IBAction private func serialSyncOrder(_ sender: UIButton) {
    print("\n---------- [ Serial Sync ] ----------\n")
    let serialQueue = DispatchQueue(label: "kr.giftbot.serialQueue")
    serialQueue.sync { log("1") }
    log("A") // -> main에서 실행
    serialQueue.sync { log("2") }
    log("B")
    serialQueue.sync { log("3") }
    log("C")
    print()
    // sync - 호출한 함수가 종료되어야 다음 작업이 진행됨
  }
  
  @IBAction private func serialAsyncOrder(_ sender: UIButton) {
    print("\n---------- [ Serial Async ] ----------\n")
    let serialQueue = DispatchQueue(label: "kr.giftbot.serialQueue")
    serialQueue.async { self.log("1") }
    log("A")
    serialQueue.async { self.log("2") }
    log("B")
    serialQueue.async { self.log("3") }
    log("C")
    print()
    
    // A, B, C 순서 동일 / 1, 2, 3 순서 동일
    // async - 함수를 호출하고 바로 종료시킨다. -> 실행 시점은 운영체제에서 결정하기때문에 언제가 될지는 알수 없음
    // serialQueue -> 1 - 2 - 3 - 4
    //
  }
    
  
  @IBAction private func concurrentSyncOrder(_ sender: UIButton) {
    print("\n---------- [ Concurrent Sync ] ----------\n")
    let concurrentQueue = DispatchQueue(
      label: "kr.giftbot.concurrentQueue",
      attributes: [.concurrent]
    )
    concurrentQueue.sync { log("1") }
    log("A")
    concurrentQueue.sync { log("2") }
    log("B")
    concurrentQueue.sync { log("3") }
    log("C")
    print()
    // sync - 무조건 호출한 작업이 끝나야 다음 작업을 실행하기 때문에 concurrent이던 아니던 상관없음
    
  }
  
  @IBAction private func concurrentAsyncOrder(_ sender: UIButton) {
    print("\n---------- [ Concurrent Async ] ----------\n")
    let concurrentQueue = DispatchQueue(
      label: "kr.giftbot.concurrentQueue",
      attributes: [.concurrent]
    )
    concurrentQueue.async { self.log("1") }
    log("A")
    concurrentQueue.async { self.log("2") }
    log("B")
    concurrentQueue.async { self.log("3") }
    log("C")
    concurrentQueue.async { self.log("4") }
    log("D")
    print()
    
    // A, B, C, D 고정 / 1, 2, 3, 4 랜덤
    // [1] -> OS
    // [2] -> OS
    // [3] -> OS
    // [4] -> OS
    
  }
  
  
  
  private func createDispatchWorkItem() -> DispatchWorkItem {
    // 출력 순서
    // 25%, 50% , 75%, 100%
    let workItem = DispatchWorkItem {
      let bigNumber = 8_000_000
      let divideNumber = 2_000_000
      for i in 1...bigNumber {
//        print(i)
        guard i % divideNumber == 0 else { continue }
        print(i / divideNumber * 25, "%")
      }
    }
    return workItem
  }
  
  
  @IBAction func waitWorkItem() {
    print("\n---------- [ waitWorkItem ] ----------\n")

    let workItem = createDispatchWorkItem()
    let myQueue = DispatchQueue(label: "kr.giftbot.myQueue")
//    print(DispatchQueue.main.label)
    // async vs sync
    myQueue.async(execute: workItem)
//    myQueue.sync(execute: workItem)
    
    print("before waiting")
    workItem.wait() // async를 원하는 시점에 sync 처럼 동작. 실행이 완료될 때까지 대기 다른 스레드를 대기시키는?
    print("after waiting")
  }
  
  
  let inactiveQueue = DispatchQueue(
    label: "kr.giftbot.inactiveQueue",
    attributes: [.initiallyInactive, .concurrent] // activate로 실행 시켜야함
  )
  
  @IBAction func initiallyInactiveQueue() {
    print("\n---------- [ initiallyInactiveQueue ] ----------\n")

    let workItem = createDispatchWorkItem()
    inactiveQueue.async(execute: workItem)
    
    print("= Do Something... =")
    
    // 필요한 타이밍에 activate 메서드를 통해 활성화
    inactiveQueue.activate() // Queue 에서 작업을 빼서 실행하겠다.
  }
  
  
  @IBAction func groupNotify() {
    print("\n---------- [ groupNotify ] ----------\n")
    
    let queue1 = DispatchQueue(label: "kr.giftbot.example.queue1",
                               attributes: .concurrent)
    let queue2 = DispatchQueue(label: "kr.giftbot.example.queue2")
    
    func calculate(task: Int, limit: Int) {
      print("Task\(task) 시작")
      for _ in 0...limit { _ = 1 + 1 }
      print("Task\(task) 종료")
    }
    
//    queue1.async { calculate(task: 1, limit: 12_000_000) }
//    queue1.async { calculate(task: 2, limit:  5_000_000) }
//    queue2.async { calculate(task: 3, limit:  2_000_000) }
    
    let group = DispatchGroup()
    queue1.async(group: group) { calculate(task: 1, limit: 12_000_000) }
    queue1.async(group: group) { calculate(task: 2, limit:  5_000_000) }
    queue2.async(group: group) { calculate(task: 3, limit:  2_000_000) }
    group.notify(queue: .main){ print("모든 작업 완료") }
  }
  
  
  var myWorkItem: DispatchWorkItem!
  
  @IBAction func cancelDispatchWorkItem() {
    myWorkItem = DispatchWorkItem {
      let bigNumber = 8_000_000
      let divideNumber = bigNumber / 4
       
      for i in 1...bigNumber {
        guard i % divideNumber == 0 else { continue }
        guard !self.myWorkItem.isCancelled else { return }
        print(i / divideNumber * 25, "%")
      }
    }

    DispatchQueue.global().async(execute: myWorkItem)
    // 3초안에 실행 안되면 취소
    let timeLimit = 3.0
    
    let timeoutResult = self.myWorkItem.wait(timeout: .now() + timeLimit)
    switch timeoutResult {
    case .success:
        print("success within \(timeLimit) seconds")
    case .timedOut:
        self.myWorkItem.cancel()
        print("TimeOut")
    }
  }
    
    @IBAction func myTest(_ sender: Any) {
        
        for i in 0...100 {
            DispatchQueue.main.async {
                print("Main Queue async: \(i)")
            }
        }
        
        let queue = DispatchQueue(label: "doan")
        
        print("=======================Start1==============================================")
        queue.sync {
            for i in 0...100 {
                print("Custom Queue1:", i)
            }
        }
        print("=======================Start2==============================================")
        queue.sync {
            for i in 0...100 {
                print("Custom Queue2:", i)
            }
        }
        
    }
    
    
}