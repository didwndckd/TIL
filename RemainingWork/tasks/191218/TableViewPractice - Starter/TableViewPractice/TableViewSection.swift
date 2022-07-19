//
//  TableViewSection.swift
//  TableViewPractice
//
//  Created by giftbot on 2019/12/05.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class TableViewSection: UIViewController {
  
  /***************************************************
   Data :  0 부터  100 사이에 임의의 숫자
   섹션 타이틀을 10의 숫자 단위로 설정하고 각 섹션의 데이터는 해당 범위 내의 숫자들로 구성
   e.g.
   섹션 0 - 0부터 9까지의 숫자
   섹션 1 - 10부터 19까지의 숫자
   ***************************************************/
  
  override var description: String { "Practice 2 - Section" }
  
//    let data = Array(900...1000)
//  let data = [5, 16, 19, 22, 29, 30, 39, 44, 48, 50, 14,81,21,20, 90, 100, 200, 212]
  let data = Array(1...100)
    var datas: [Int: [Int]] = [:]
    var sectionsTitles: [Int] = []
    
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let tableView = UITableView(frame: view.frame)
    view.addSubview(tableView)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellID")
    tableView.dataSource = self
    setSections()
    print("view Did Load")
    print(datas)
  }
    
    
    
    func setSections() {
        
        for data in data {
            
            let section = data/10
            
            if  datas[section] == nil {
                datas[section] = [data]
            }else {
                datas[section]?.append(data)
            }
        }
        sectionsTitles = datas.keys.sorted()
        
        
        
        
        
    }

    
    
}




// MARK: - UITableViewDataSource

extension TableViewSection: UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("numberOfSection()")
        return sectionsTitles.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(sectionsTitles[section])
    }
    
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        let key = sectionsTitles[section]
        guard let dataList = datas[key] else {return 0}
    datas[key]?.sort()
    return dataList.count
    
    }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellID", for: indexPath)
    
    let key = sectionsTitles[indexPath.section]
    let text = datas[key]![indexPath.row]
    cell.textLabel?.text = "\(text)"
    
    return cell
  }
}


