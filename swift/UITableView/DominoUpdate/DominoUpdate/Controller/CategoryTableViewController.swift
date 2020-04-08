//
//  CategoryTableViewController.swift
//  DominoUpdate
//
//  Created by 양중창 on 2020/01/29.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // self.clearsSelectionOnViewWillAppear = false
        
        title = "Category"
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.frame = CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 200))
        imageView.contentMode = .scaleAspectFit
        tableView.tableHeaderView = imageView
        self.clearsSelectionOnViewWillAppear = false
        tableView.register(CategoryTableViewCell.self, forCellReuseIdentifier: CategoryTableViewCell.identifier)

    }

    // MARK: - Table view data source

   

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryTableViewCell.identifier, for: indexPath) as? CategoryTableViewCell
            else { return UITableViewCell() }
        
        cell.configure(named: menuData[indexPath.row].category)
//        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let productVC = ProductTableViewController(menu: menuData[indexPath.row])
        navigationController?.pushViewController(productVC, animated: true)
    }


}
