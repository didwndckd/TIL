//
//  TableViewEditing.swift
//  BasicTableView
//
//  Created by Giftbot on 2019/12/05.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

final class TableViewEditing: UIViewController {
  
  /***************************************************
   테이블뷰 목록 수정하기 (insert, delete 등)
   ***************************************************/
  
  override var description: String { "TableView - Editing" }
  
  let tableView = UITableView()
  var data = Array(1...50)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Edit", style: .plain, target: self, action: #selector(switchToEditing)
    )
  }
  
  func setupTableView() {
    tableView.frame = view.frame
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
    view.addSubview(tableView)
    
    let refreshControl = UIRefreshControl()
    refreshControl.attributedTitle = NSAttributedString(string: "Refreshing...")
    refreshControl.tintColor = .blue
    refreshControl.addTarget(self, action: #selector(reloadData), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  @objc func reloadData() {
    tableView.refreshControl?.endRefreshing()
    tableView.reloadData()
  }
  
  @objc func switchToEditing() {
    
    tableView.setEditing(!tableView.isEditing, animated: true) // 현재의 editing값의 반대값을 전달 한다can
    
  }
}

// MARK: - UITableViewDataSource

extension TableViewEditing: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return data.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
    cell.textLabel?.text = "\(data[indexPath.row])"
    return cell
  }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .none: print("none")
        case .delete:
            print("delete", indexPath)
//            data.remove(at: data.firstIndex(of: data[indexPath.row])!)
            data.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            
        case .insert:
            print("insert", indexPath)
//            data.remove(at: indexPath.row)
            data.insert((0...100).randomElement()!, at: indexPath.row)
            tableView.insertRows(at: [indexPath], with: .automatic)
        default: print("default")
        }

    }
    
    
}


// MARK: - UITableViewDelegate

extension TableViewEditing: UITableViewDelegate {
  
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        //기본값 true
//        return indexPath.row.isMultiple(of: 2)
//
//    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        // 기본값 delete
        
        let row = indexPath.row
        if row % 3 == 0 {
            print("none")
            return .none
        }else if row % 3 == 1 {
            print("delete")
            return .delete
        }else {
            print("insert")
            return .insert
            
        }
        
    }
    
    
    //iOS 8~10
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        return [UITableViewRowAction(style: .normal , title: "Add"){(action, sourceView, actionPerformed) in
//            print("Add Action")
//            actionPerformed(true)
//        }]
//    }
    
    // iOS 11 이상
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let addAction = UIContextualAction(style: .normal, title: "Add") {(action, sourceView, actionPerformed) in
            print("Add Action")
            actionPerformed(true)
        }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
            (action, sourceView, actionPerformed) in
            print("delete Action")
            actionPerformed(true)
        }
        
        let configuration = UISwipeActionsConfiguration(actions: [addAction, deleteAction])
//        configuration.performsFirstActionWithFullSwipe = false
    return configuration
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let addAction = UIContextualAction(style: .normal, title: "Add") {(action, sourceView, actionPerformed) in
                    print("Add Action")
                    actionPerformed(true)
                }
                
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") {
                    (action, sourceView, actionPerformed) in
                    print("delete Action")
                    actionPerformed(true)
                }
                
        
                
                let configuration = UISwipeActionsConfiguration(actions: [addAction, deleteAction])
        //        configuration.performsFirstActionWithFullSwipe = false
            return configuration
    }
}

