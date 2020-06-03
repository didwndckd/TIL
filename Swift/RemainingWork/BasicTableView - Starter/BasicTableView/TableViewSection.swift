//
//  TableView02.swift
//  BasicTableView
//
//  Created by giftbot on 2019. 4. 10..
//  Copyright © 2019년 giftbot. All rights reserved.
//

import UIKit

final class TableViewSection: UIViewController {
  
  override var description: String { "TableView - Section" }
  
  /***************************************************
   섹션을 나누어 데이터 목록 출력하기
   ***************************************************/

  lazy var sectionTitles: [String] = fruitsDict.keys.sorted()
  let fruitsDict = [
    "A": ["Apple", "Avocado"],
    "B": ["Banana", "Blackberry"],
    "C": ["Cherry", "Coconut"],
    "D": ["Durian"],
  ]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let tableView = UITableView(frame: view.frame)
    tableView.dataSource = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    view.addSubview(tableView)
  }
}


// MARK: - UITableViewDataSource

extension TableViewSection: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // 몇개의 Section을 사용할 것인가
        return fruitsDict.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // SectionTitle을 셋팅해 줄 수 있음
        return sectionTitles[section]
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // 몇개의 Cell을 만들것인가
    let titles = fruitsDict.keys.sorted()
    let key = titles[section]
    return fruitsDict[key]!.count
    //return fruitsDict[sectionTitles[section]]!.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    /*
     Section마다 다른 배열처럼 취급
     */
    
    
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
    let fruits = fruitsDict[sectionTitles[indexPath.section]]!
    cell.textLabel?.text = "\(fruits[indexPath.row])"
    return cell
  }
}
