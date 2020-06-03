//
//  ListViewController.swift
//  DominoStarter
//
//  Created by Lee on 2019/12/27.
//  Copyright © 2019 Kira. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    
    let navigationTitle = "Domino's"
    let tableView = UITableView()
    var model = MenuList()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupTableView()
    
  }
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 120
        tableView.sectionHeaderHeight = 80
       // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MenuCell")

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = navigationTitle
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        let guide = view.safeAreaLayoutGuide
        
        
        
        //addSubView
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        //addSubView
        
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        
    }
    
    
    
    
  
}

extension ListViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return model.menuList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.menuList[section].products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
        if cell == nil{
        print("생성")
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MenuCell")
        }else {
            print("재사용")
        }
        let product = model.menuList[indexPath.section].products[indexPath.row]
        cell!.imageView?.image = UIImage(named: product.name)
        cell!.textLabel?.text = product.name
        cell!.detailTextLabel?.text = "\(product.price) 원"
//        print(cell!.detailTextLabel)
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let productImageView = UIImageView()
        let imageName = model.menuList[section].category
        productImageView.image = UIImage(named: imageName)
        productImageView.contentMode = .scaleAspectFit
        productImageView.backgroundColor = .systemBackground
        
        return productImageView
    }
    
    
    
    
}

extension ListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let detailViewController = DetailViewController()
        let product = model.menuList[indexPath.section].products[indexPath.row]
        detailViewController.productTitle = product.name
        detailViewController.price = product.price
        detailViewController.category += model.menuList[indexPath.section].category
        navigationController?.pushViewController(detailViewController, animated: true)
        
        return nil
    }
    
    
}
