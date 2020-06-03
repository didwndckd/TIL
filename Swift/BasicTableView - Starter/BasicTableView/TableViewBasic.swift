//
//  TableViewBasic.swift
//  BasicTableView
//
//  Created by Giftbot on 2019/12/05.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class TableViewBasic: UIViewController {
  
  override var description: String { "TableView - Basic" }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tableView = UITableView(frame: view.frame, style: .plain)
    view.addSubview(tableView)
    tableView.dataSource = self // tableView의 dataSource에 self를 넣어서 누가 데이터를 넣어줄지 결정
    
    
    print(UITableViewCell.self)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
//    tableView.register(MyTableViewCell.self, forCellReuseIdentifier: "CellID")
    
    
  }
}

extension TableViewBasic: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 매번 새로운 Cell 만들어주는 문제
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "CellID")
//        cell.textLabel?.text = "\(indexPath.row)"
//        return cell
        
        // Cell 재사용 해야함 ( 미등록 )
//        let cell: UITableViewCell
//        if let reusableCell = tableView.dequeueReusableCell(withIdentifier: "CellID") {
//            cell = reusableCell
//            print("재사용")
//        }else {
//            cell = UITableViewCell(style: .default, reuseIdentifier: "CellID")
//            print("생성")
//        }
//        cell.textLabel?.text = "\(indexPath.row)"
//        return cell
    
    
        //알아서 재사용해줌 (선등록)
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
        
    }
}



