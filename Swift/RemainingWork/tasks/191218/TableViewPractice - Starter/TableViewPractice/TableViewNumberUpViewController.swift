//
//  TableViewNumberUpViewController.swift
//  TableViewPractice
//
//  Created by 양중창 on 2019/12/19.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

class TableViewNumberUpViewController: UIViewController {
    
    
    var data = [Int](1...100)

    override var description: String {
        return "TableView Number Up Task"
    }
    
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.register(CustomCell.self, forCellReuseIdentifier: "Custom")
        
        setTableView()
        

    }
    
    func setTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    

   

}


extension TableViewNumberUpViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return data.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Custom", for: indexPath) as! CustomCell
        cell.textLabel?.text = "\(data[indexPath.row])"
        cell.delegate = self
        
        return cell
        
        
    }
    
    
}

extension TableViewNumberUpViewController: CustomCellDelegate {
    func buttonAction(cell: CustomCell) {
        guard let indexPath = tableView.indexPath(for: cell) else{return}
        let value = data[indexPath.row] + 1
        data[indexPath.row] = value
        cell.textLabel?.text = "\(value)"
    }
    
    
}
