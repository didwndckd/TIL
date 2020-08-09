//
//  TestViewController.swift
//  DispatchQueueExample
//
//  Created by 양중창 on 2020/08/09.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit


protocol QueueComponent {
  func string() -> String
}

enum Queue: String, QueueComponent, CaseIterable {
  
  case serial
  case concurrent
  
  func makeQueue(qos: Qos, index: Int) -> DispatchQueue {
    switch self {
    case .serial:
      return DispatchQueue(label: "SerialQueue \(index)", qos: qos.qos())
    case .concurrent:
      return DispatchQueue(label: "ConcurrentQueue \(index)", qos: qos.qos(), attributes: .concurrent)
    }
  }
  
  
  func string() -> String {
    self.rawValue
  }
}

enum Synchronize: String, QueueComponent, CaseIterable {
  case sync
  case aSync
  
  func string() -> String {
    self.rawValue
  }
}

enum Qos: String, QueueComponent, CaseIterable {
  
  case userInteractive
  case userInitiated
  case `default`
  case utility
  case background
  case unspecified
  
  func string() -> String {
    self.rawValue
  }
  
  func qos() -> DispatchQoS {
    switch self {
    case .userInteractive:
      return .userInteractive
    case .userInitiated:
      return .userInitiated
    case .`default`:
      return .default
    case .utility:
      return .utility
    case .background:
      return .background
    case .unspecified:
      return .unspecified
    }
  }
}

struct Task {
  let name: String
  let task: () -> Void
}

class TestViewController: UIViewController {
  
  private let pickerView = UIPickerView()
  private let addButton = UIButton(type: .system)
  private let startButton = UIButton(type: .system)
  private let tableView = UITableView()
  private let reLoadButton = UIButton(type: .system)
  private let runLoopButton = UIButton(type: .system)
  private let stackView = UIStackView()
  
  private var runLoop: Timer?
  
  private let queueCompnent: [[QueueComponent]] = [Queue.allCases, Synchronize.allCases, Qos.allCases]
  
  private let serialQueue = DispatchQueue(label: "doan.SerialQueue")
  private let concurrentQueue = DispatchQueue(label: "doan.ConcurrentQueue", attributes: .concurrent)
  
  private var tasks: [Task] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupContraint()
    
  }
  
  private func setupUI() {
    view.backgroundColor = .white
    pickerView.delegate = self
    pickerView.dataSource = self
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    
    addButton.setTitle("Add", for: .normal)
    addButton.addTarget(self, action: #selector(addAction(_:)), for: .touchUpInside)
    
    startButton.setTitle("Start", for: .normal)
    startButton.addTarget(self, action: #selector(startAction(_:)), for: .touchUpInside)
    
    reLoadButton.setTitle("ReLoad", for: .normal)
    reLoadButton.addTarget(self, action: #selector(reLoadAction(_:)), for: .touchUpInside)
    
    runLoopButton.setTitle("Running", for: .selected)
    runLoopButton.setTitle("Not Running", for: .normal)
    runLoopButton.addTarget(self, action: #selector(didTapRunLoopButton(_:)), for: .touchUpInside)
  }
  
  private func setupContraint() {
    [pickerView, tableView, stackView].forEach({
      view.addSubview($0)
      $0.translatesAutoresizingMaskIntoConstraints = false
    })
    
    [addButton, startButton, reLoadButton, runLoopButton].forEach({
      stackView.addArrangedSubview($0)
    })
    
    
    let guide = view.safeAreaLayoutGuide
    
    pickerView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
    pickerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    pickerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    
    stackView.topAnchor.constraint(equalTo: pickerView.bottomAnchor).isActive = true
    stackView.leadingAnchor.constraint(equalTo: pickerView.leadingAnchor).isActive = true
    stackView.trailingAnchor.constraint(equalTo: pickerView.trailingAnchor).isActive = true
    
    tableView.topAnchor.constraint(equalTo: stackView.bottomAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    
    
  }
  
  @objc private func didTapRunLoopButton(_ sender: UIButton) {
    sender.isSelected.toggle()
  
    if sender.isSelected {
      self.runLoop = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { timer in
        self.checkThread(label: "\(timer.fireDate)")
      })
    } else {
      self.runLoop?.invalidate()
    }
    
    
  }
  
  @objc private func reLoadAction(_ sender: UIButton) {
    tasks.removeAll()
    tableView.reloadData()
  }
  
  
  @objc private func addAction(_ sender: UIButton) {
    let queueIndex = pickerView.selectedRow(inComponent: 0)
    let synchronizeIndex = pickerView.selectedRow(inComponent: 1)
    let qosIndex = pickerView.selectedRow(inComponent: 2)
    
    guard
      let queue = queueCompnent[0][queueIndex] as? Queue,
      let synchronize = queueCompnent[1][synchronizeIndex] as? Synchronize,
      let qos = queueCompnent[2][qosIndex] as? Qos
      else { return }
    
    let dispatchQueue = queue == .serial ? serialQueue: concurrentQueue
    let taskLabel = "\nQueue: \(queue) \nSynchronize: \(synchronize) \nQos: \(qos) \nNumber: \(tasks.isEmpty ? 0: tasks.count)"
    var task: () -> Void
    
    switch synchronize {
    case .aSync:
      task = {
        dispatchQueue.async(qos: qos.qos()) {
          
          self.bigTask(taskLabel)
        }
      }
    case .sync:
      task = {
        dispatchQueue.sync {
          
          self.bigTask(taskLabel)
        }
      }
    }
    
    let taskObject = Task(name: taskLabel, task: task)
    tasks.append(taskObject)
    tableView.reloadData()
  }
  
  @objc private func startAction(_ sender: UIButton) {
    tasks.forEach({
      print("\nStartTask: \($0.name)\n")
      $0.task()
      print("\nEndTask: \($0.name)\n")
    })
    
  }
  
  private func bigTask(_ label: String = "") {
    
    print("= Big task start =", label)
    self.checkThread(label: label)
    
    for i in 0...5_000_000 {
      if i % 1_000_000 == 0 {
        
        print("\nTask inside \n\(label) -> \(i) \n")
        
        DispatchQueue.main.async {
          self.changeBackground()
        }
      }
    }
    print("= Big task end =", label)
  }
  
  private func checkThread(label: String) {
    let output = """
    \n=======================================
    \nThreadCheck: \(label)
    \ncurrent: \(Thread.current)
    \nis Main: \(Thread.isMainThread)
    \n========================================\n
    """
    print(output)
  }
  
  private func changeBackground() {
     print("---------- [ Change Color ] ----------\n")
     let r = CGFloat.random(in: 0...1.0)
     let g = CGFloat.random(in: 0...1.0)
     let b = CGFloat.random(in: 0...1.0)
     view.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1)
   }
  
}


extension TestViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    queueCompnent.count
  }
  
  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    queueCompnent[component].count
  }
  
  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    queueCompnent[component][row].string()
  }
}


extension TestViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    tasks.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    cell.textLabel?.text = tasks[indexPath.row].name
    cell.textLabel?.numberOfLines = 0
    return cell
  }
  
  
}
