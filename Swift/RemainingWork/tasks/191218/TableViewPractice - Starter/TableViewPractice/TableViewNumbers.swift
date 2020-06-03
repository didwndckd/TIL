//
//  TableViewNumbers.swift
//  TableViewPractice
//
//  Created by giftbot on 2019/12/05.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class TableViewNumbers: UIViewController {
  
  /***************************************************
   1부터 50까지의 숫자 출력하기
   ***************************************************/
  
  override var description: String { "Practice 1 - Numbers" }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tableView = UITableView(frame: view.frame)
    view.addSubview(tableView)
    
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
  }
}

extension TableViewNumbers: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //재사용 안하는 방식(사용하면 안될듯)
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellID")
        
        
        //register 선등록 방식
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        print("register선등록 방식: \(indexPath.row)")
        
        //register 미등록 방식
//        let cell: UITableViewCell
//
//        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: "CellID") {
//            cell = reusableCell
//            print("Cell재사용")
//            print("\(indexPath.row)")
//        }else {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "CellID")
//            print("Cell생성")
//            print("\(indexPath.row)")
//        }
        cell.textLabel?.text = "\(indexPath.row)"
        
        return cell
        
    }
    
}
