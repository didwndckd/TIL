//
//  TableViewMultipleSelection.swift
//  TableViewPractice
//
//  Created by giftbot on 2019/12/05.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class TableViewMultipleSelection: UIViewController {
  
  /***************************************************
   [ 실습 - TableViewRefresh 기능을 이어서 수행 ]
   
   1) 처음 화면에 띄워질 목록은 1부터 지정한 숫자까지의 숫자들을 출력
   2) 이후 갱신할 때마다 임의의 숫자들이 출력되도록 할 것
      랜덤 숫자의 범위는 출력할 숫자 개수의 +50 이며, 모든 숫자는 겹치지 않아야 함.
      (여기까지 TableViewRefresh 실습 내용과 동일)
   3) 특정 테이블뷰셀을 선택하고 갱신하면 해당 셀에 있던 숫자는 유지되고 나머지 숫자들만 랜덤하게 갱신되도록 처리
      (셀을 선택한 순서에 따라 그대로 다음 갱신 목록에 출력)
      e.g. 20, 10 두 개의 숫자를 선택하고 갱신하면, 다음 숫자 목록은 (20, 10, random, random...)
   4) 위 3번에서 숫자를 선택할 때 그 숫자가 7보다 작은 셀은 선택이 되지 않도록 처리.
   
   < 힌트 키워드 >
   willSelectRowAt - scrollViewDelegate 참고, 선택 가능 여부
   selectedRow(s) - tableView 속성, 현재 선택된 행에 대한 정보
   multipleSelection - 다중 선택 가능 여부
   ***************************************************/
  
  override var description: String {
    return "Task 1 - MultipleSelection"
  }
  
    let tableView = UITableView()
    let maxCount = 20
    let maxRange = 50
    var result: [Int] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.frame = view.frame
    view.addSubview(tableView)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
    tableView.allowsMultipleSelection = true
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change", style: .done, target: self, action: #selector(change))
    
    resultSet()
    
  }
    
    @objc func change() {
        result.removeAll()
        if let cellList = tableView.indexPathsForSelectedRows {
            
            for i in cellList {
                let cell = tableView.cellForRow(at: i)
                guard let text = cell?.textLabel?.text else{return}
                if let number = Int(text) {
                    result.append(number)
                }
            }
        }
        
        resultSet()
        tableView.reloadData()
        
        
    }
    
    func resultSet() {
        
        
        while result.count < maxCount {
            
            if let num = (0...maxCount + maxRange).randomElement() {
                
                if !result.contains(num) { // result 배열에 값이 없으면 result배열에 추가
                    result.append(num)
                }
            }
        }
        
    }
    
    
    
}

// MARK: - UITableViewDataSource

extension TableViewMultipleSelection: UITableViewDataSource {
    
    
    
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return result.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
    cell.textLabel?.text = "\(result[indexPath.row])"
    return cell
  }
    
}


extension TableViewMultipleSelection: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        if result[indexPath.row] < 7 {
            return nil
        }
        else {
            return indexPath
        }
        
    }
    
    
}


