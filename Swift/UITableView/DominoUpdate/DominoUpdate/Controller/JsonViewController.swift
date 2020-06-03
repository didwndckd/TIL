//
//  SectionViewViewController.swift
//  DominoUpdate
//
//  Created by 양중창 on 2020/01/29.
//  Copyright © 2020 didwndckd. All rights reserved.
//


import UIKit

class JsonViewController: UIViewController {
  
  private let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    navigationSet()
    configure()
    autoLayout()
  }
  private func navigationSet() {
    title = "Json"
  }
  
  private func configure() {
    tableView.dataSource = self
    tableView.delegate = self
    view.addSubview(tableView)
  }
  
  private func autoLayout() {
    let guide = view.safeAreaLayoutGuide
    
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
    tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
    tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
  }
}

extension JsonViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    guard let menu = jsonData as? [Any] else { return 0 }
    return menu.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard
        let menu = jsonData as? [[String: Any]],
        let products = menu[section]["products"] as? [Any]
        else { return 0 }
    
    return products.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard
        let menu = jsonData as? [[String: Any]],
        let products = menu[indexPath.section]["products"] as? [[String: Any]],
        let name = products[indexPath.row]["name"] as? String,
        let price = products[indexPath.row]["price"] as? Int
           else { return UITableViewCell() }

    
    let cell: UITableViewCell
    if let reusableCell = tableView.dequeueReusableCell(withIdentifier: "cell") {
      cell = reusableCell
    } else {
      cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
    }
    
    let product = menuData[indexPath.section].products[indexPath.row]
    cell.imageView?.image = UIImage(named: product.name)
    cell.textLabel?.text = name
    cell.detailTextLabel?.text = String(price) + " 원"
    cell.selectionStyle = .none
    
    return cell
  }
}

extension JsonViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard
    let menu = jsonData as? [[String: Any]],
    let products = menu[indexPath.section]["products"] as? [[String: Any]],
    let name = products[indexPath.row]["name"] as? String
       else { return }
    let detailVC = DetailViewController(productName: name)
    navigationController?.pushViewController(detailVC, animated: true)
  }
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let herderView = UIImageView()
    herderView.backgroundColor = .white
    herderView.image = UIImage(named: menuData[section].category)
    herderView.contentMode = .scaleAspectFit
    return herderView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 80
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 120
  }
}

