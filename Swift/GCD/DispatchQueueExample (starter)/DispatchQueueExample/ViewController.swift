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
  
  
  func bigTask(_ label: String = "") {
    
    print("= Big task start =", label)
    for i in 0...5_000_000 {
      if i % 1_000_000 == 0 {
        print(label, "->", i)
      }
    }
    print("= Big task end =", label)
  }
  
  @IBAction func bigTaskOnMainThread() {
    
    print("start:")
    bigTask()
    print("end:")
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
    let serialQueue = DispatchQueue(label: "kr.doan.serialQueue")
    serialQueue.sync { log("1") }
    log("A")
    serialQueue.sync { log("2") }
    log("B")
    serialQueue.sync { log("3") }
    log("C")
    print()
    // 1 - A - 2 - B - 3 - C
    // sync - 호출한 함수가 종료되어야 다음 작업이 진행됨
  }
  
  @IBAction private func serialAsyncOrder(_ sender: UIButton) {
    print("\n---------- [ Serial Async ] ----------\n")
    let serialQueue = DispatchQueue(label: "kr.doan.serialQueue")
    serialQueue.async { self.log("1") }
    log("A")
    serialQueue.async { self.log("2") }
    log("B")
    serialQueue.async { self.log("3") }
    log("C")
    print()
    //A - 1 - B - 2 - C - 3
    // A, B, C 순서 동일 / 1, 2, 3 순서 동일
    // async - 함수를 호출하고 바로 종료시킨다. -> 실행 시점은 운영체제에서 결정하기때문에 언제가 될지는 알수 없음
    // serialQueue -> 1 - 2 - 3 - 4
    //
  }
  
  
  @IBAction private func concurrentSyncOrder(_ sender: UIButton) {
    print("\n---------- [ Concurrent Sync ] ----------\n")
    let concurrentQueue = DispatchQueue(
      label: "kr.doan.concurrentQueue",
      attributes: [.concurrent]
    )
    concurrentQueue.sync { log("1") }
    log("A")
    concurrentQueue.sync { log("2") }
    log("B")
    concurrentQueue.sync { log("3") }
    log("C")
    print()
    
    // 1 - A - 2 - B - 3 - C
    // sync - 무조건 호출한 작업이 끝나야 다음 작업을 실행하기 때문에 concurrent이던 아니던 상관없음
    
  }
  
  @IBAction private func concurrentAsyncOrder(_ sender: UIButton) {
    print("\n---------- [ Concurrent Async ] ----------\n")
    let concurrentQueue = DispatchQueue(
      label: "kr.doan.concurrentQueue",
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
      print("Started workItem")
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
    let myQueue = DispatchQueue(label: "kr.doan.myQueue")
    myQueue.async(execute: workItem)
    
    print("Before waiting")
    workItem.wait() // async를 원하는 시점에 sync 처럼 동작. 실행이 완료될 때까지 대기 다른 스레드를 대기시키는?
    print("After waiting")
  }
  
  
  let inactiveQueue = DispatchQueue(
    label: "kr.giftbot.inactiveQueue",
    attributes: [.initiallyInactive, .concurrent] // activate로 실행 시켜야함
  )


  @IBAction func initiallyInactiveQueue() {
    print("\n---------- [ initiallyInactiveQueue ] ----------\n")
    
    let workItem = createDispatchWorkItem()
    inactiveQueue.async(execute: workItem)
    //    inactiveQueue.sync(execute: workItem)
    
    print("= Do Something... =")
    
    // 필요한 타이밍에 activate 메서드를 통해 활성화
    inactiveQueue.activate() // Queue 에서 작업을 빼서 실행하겠다.
  }
  
  
  @IBAction func groupNotify() {
    print("\n---------- [ groupNotify ] ----------\n")
    
    let queue1 = DispatchQueue(label: "kr.doan.concurrentQueue",
                               attributes: .concurrent)
    let queue2 = DispatchQueue(label: "kr.doan.serialQueue")
    
    func calculate(task: Int, limit: Int) {
      print("Task\(task) 시작")
      for _ in 0...limit { _ = 1 + 1 }
      print("Task\(task) 종료")
    }
    
    // DispatchGroup을 사용하지 않은 경우
//    queue1.async { calculate(task: 1, limit: 12_000_000) }
//    queue1.async { calculate(task: 2, limit:  5_000_000) }
//    queue2.async { calculate(task: 3, limit:  2_000_000) }
//    print("모든 작업 완료")
//    모든 작업 완료
//    Task1 시작
//    Task3 시작
//    Task2 시작
//    Task3 종료
//    Task2 종료
//    Task1 종료
    
    // DispatchGroup을 사용하여 aync작업을 group에 포함시킨 경우
    let group = DispatchGroup()
    queue1.async(group: group) { calculate(task: 1, limit: 12_000_000) }
    queue1.async(group: group) { calculate(task: 2, limit:  5_000_000) }
    queue2.async(group: group) { calculate(task: 3, limit:  2_000_000) }
    group.notify(queue: .main){ print("모든 작업 완료") }
//    Task3 시작
//    Task1 시작
//    Task2 시작
//    Task3 종료
//    Task2 종료
//    Task1 종료
//    모든 작업 완료
    
    // DispatchGroup의 enter()와 leave()를 사용한 경우
//    let group = DispatchGroup()
//    group.enter()
//    queue1.async {
//      calculate(task: 1, limit: 12_000_000)
//      group.leave()
//    }
//
//    group.enter()
//    queue1.async {
//      calculate(task: 2, limit:  5_000_000)
//      group.leave()
//    }
//
//    group.enter()
//    queue2.async {
//      calculate(task: 3, limit:  2_000_000)
//      group.leave()
//    }
//
//    group.notify(queue: .main){ print("모든 작업 완료") }
//    Task1 시작
//    Task3 시작
//    Task2 시작
//    Task3 종료
//    Task2 종료
//    Task1 종료
//    모든 작업 완료
    
    
    // DispatchGroup wait을 사용한 경우
//    let group = DispatchGroup()
//    queue1.async(group: group) { calculate(task: 1, limit: 12_000_000) }
//    queue1.async(group: group) { calculate(task: 2, limit:  5_000_000) }
//    queue2.async(group: group) { calculate(task: 3, limit:  2_000_000) }
//    let groupTimeResult = group.wait(timeout: .distantFuture)
//
//    switch groupTimeResult {
//    case .success:
//      print("모든 작업 완료")
//    case .timedOut:
//      print("TimeOut")
//    }
    //Task1 시작
    //Task2 시작
    //Task3 시작
    //Task3 종료
    //Task2 종료
    //Task1 종료
    //모든 작업 완료

    
  }
  
  
  var cancellableWorkItem: DispatchWorkItem!
  
  @IBAction func cancelDispatchWorkItem() {
    
    cancellableWorkItem = DispatchWorkItem {
      let bigNumber = 8_000_000
      let divideNumber = bigNumber / 4
      
      for i in 1...bigNumber {
        guard i % divideNumber == 0 else { continue }
        guard !self.cancellableWorkItem.isCancelled else { return }
        print(i / divideNumber * 25, "%")
      }
    }
    
    DispatchQueue.global().async(execute: cancellableWorkItem)
    // 3초안에 실행 안되면 취소
    let timeLimit = 3.0
    
    let timeoutResult: DispatchTimeoutResult = cancellableWorkItem.wait(timeout: .now() + timeLimit) // 3초 wait()
    
    switch timeoutResult {
    case .success:
      print("success within \(timeLimit) seconds")
    case .timedOut:
      cancellableWorkItem.cancel()
      print("TimeOut")
    }
    
//    DispatchQueue.main.asyncAfter(deadline: .now() + timeLimit, execute: {
//      self.myWorkItem.cancel()
//      print("canceled")
//    })
    
  }
  
  @IBAction func myTest(_ sender: Any) {
    
    present(TestViewController(), animated: true)
    
    
    
  }
  
  private func checkThread(label: String) {
    print("====================================")
    print("ThreadCheck:", label)
    print("current", Thread.current)
    print("is Main:", Thread.isMainThread)
    print("===========================================")
  }
  //
  //  @objc private func runLoopCallback(_ timer: Timer) {
  //    print("RunLoop")
  //    print("timer:", timer.fireDate)
  //  }
  
}


