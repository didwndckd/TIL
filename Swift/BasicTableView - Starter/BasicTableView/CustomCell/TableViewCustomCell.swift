//
//  TableViewCustomCell.swift
//  BasicTableView
//
//  Created by Giftbot on 2019/12/05.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class TableViewCustomCell: UIViewController {
  
  /***************************************************
   커스텀 셀 사용하기
     
   ***************************************************/
  
  override var description: String { "TableView - CustomCell" }
  
  let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.frame = view.frame
    tableView.dataSource = self
    tableView.delegate = self
    tableView.rowHeight = 80
    view.addSubview(tableView)
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Default")
    tableView.register(CustomCell.self, forCellReuseIdentifier: "Custom")
  }
}

// MARK: - UITableViewDataSource

extension TableViewCustomCell: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 20
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell: UITableViewCell
    
    if indexPath.row.isMultiple(of: 2) {
        cell = tableView.dequeueReusableCell(withIdentifier: "Custom", for: indexPath)
        (cell as! CustomCell).myLabel.text = "ABCDE"
//        (cell as! CustomCell).myLabel.frame = CGRect(x: cell.frame.width - 120, y: 15, width: 100, height: cell.frame.height - 30)
//        이 시점에서는 아직 cell의 프레임이 잡히기 전이기 때문에 기본값의 frame으로 잡히게된다
    }else {
        cell = tableView.dequeueReusableCell(withIdentifier: "Default", for: indexPath)
    }
    cell.textLabel?.text = "\(indexPath.row * 1000)"
    cell.imageView?.image = UIImage(named: "bear")
    
    
    return cell
    
    
  }
}


// MARK: - UITableViewDelegate

extension TableViewCustomCell: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        guard let customCell = cell as? CustomCell else {return}
        customCell.myLabel.frame = CGRect(x: cell.frame.width - 120, y: 15, width: 100, height: cell.frame.height - 30)
        // 여기서는 디스플레이 직전이기 때문에 cell의 frame 이 안전하게 잡혀있는 상태 이기때문에 frame설정이 가능하다
        
    }
    
    
    
    
}

