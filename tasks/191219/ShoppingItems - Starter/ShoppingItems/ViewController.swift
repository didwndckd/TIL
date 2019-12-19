//
//  ViewController.swift
//  ShoppingItems
//
//  Created by giftbot on 2019. 12. 17..
//  Copyright © 2019년 giftbot. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  
  @IBOutlet private weak var tableView: UITableView!
    
    var phoneList = [
    (name: "iPhone8", currentOrderMount: 0, maximumMount: 4),
    (name: "iPhone11", currentOrderMount: 0, maximumMount: 1),
    (name: "iPhoneSE_Gold", currentOrderMount: 0, maximumMount: 2),
    (name: "iPhoneSE_RoseGold", currentOrderMount: 0, maximumMount: 3),
    (name: "iPhoneX_SpaceGray", currentOrderMount: 0, maximumMount: 5),
    (name: "iPhoneX_White", currentOrderMount: 0, maximumMount: 6),
    (name: "iPhone5", currentOrderMount: 0, maximumMount: 9),
    (name: "iPhone6", currentOrderMount: 0, maximumMount: 12),
    (name: "iPhone7", currentOrderMount: 0, maximumMount: 3),
    (name: "iPhone11pro", currentOrderMount: 0, maximumMount: 2),]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.dataSource = self
    tableView.register(ItemCell.self, forCellReuseIdentifier: "ItemCell")
    tableView.rowHeight = 80
    
    
  }
}

// MARK: - UITableViewDataSource

extension ViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return phoneList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
    
    cell.textLabel?.text = phoneList[indexPath.row].name
    cell.imageView?.image = UIImage(named: phoneList[indexPath.row].name)
    
    
    return cell
  }
}

