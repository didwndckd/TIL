//
//  ProductTableViewController.swift
//  DominoUpdate
//
//  Created by 양중창 on 2020/01/29.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class ProductTableViewController: UITableViewController {
    
    private let menu: Menu
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = menu.category
//        self.clearsSelectionOnViewWillAppear = false
        
    }
    
    init(menu: Menu) {
        self.menu = menu
        super.init(nibName: nil, bundle: nil)
        
    }
    
  
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menu.products.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") {
            let data = menu.products[indexPath.row]
            
            let image = UIImage(named: data.name )
            cell.imageView?.image = image
            cell.textLabel?.text = data.name
            cell.detailTextLabel?.text = "\(data.price)"
            
            return cell
        }else {
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            let data = menu.products[indexPath.row]
            let image = UIImage(named: data.name )
            cell.imageView?.image = image
            cell.textLabel?.text = data.name
            cell.detailTextLabel?.text = "\(data.price)"
//            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(productName: menu.products[indexPath.row].name)
        navigationController?.pushViewController(detailVC, animated: true)
    }

    

}
