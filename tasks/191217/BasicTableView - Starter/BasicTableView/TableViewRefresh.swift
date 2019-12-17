//
//  TableView03.swift
//  BasicTableView
//
//  Created by Giftbot on 2019/12/05.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class TableViewRefresh: UIViewController {
  
  override var description: String { "TableView - Refresh" }
  
  /***************************************************
   테이블뷰를 새로 불러올 때마다 숫자 목록을 반대로 뒤집어서 출력하기
   ***************************************************/
  
  let tableView = UITableView()
  var data = Array(1...40)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh", style: .done, target: self, action: #selector(reloadData))
  }
  
  func setupTableView() {
    tableView.frame = view.frame
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    view.addSubview(tableView)
    
    tableView.rowHeight = 60 // Cell의 높이를 지정할 수 있다
    
    let refreshControl = UIRefreshControl() // refreshControll 만들어줌
    refreshControl.tintColor = .blue
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    refreshControl.attributedTitle = NSAttributedString(
        string: "Refreshing...",
        attributes: [.font: UIFont.systemFont(ofSize: 30),
                     .kern: 5])
    
    tableView.refreshControl = refreshControl // tabelView의 refreshControll프로퍼티에 만들어 놓은 refreshControll을 넣어준다
  }
  
    
    
    
  @objc func reloadData() {
    print("reloadData()")
    data.reverse()
    tableView.refreshControl?.endRefreshing() // tableView의 refreshControll을 끝내준다
    tableView.reloadData()
    
  }
}

// MARK: - UITableViewDataSource

extension TableViewRefresh: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
    cell.textLabel?.text = "\(data[indexPath.row])"
    return cell
  }
}
