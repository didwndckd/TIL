//
//  WishListViewController.swift
//  DominoStarter
//
//  Created by Lee on 2019/12/27.
//  Copyright © 2019 Kira. All rights reserved.
//

import UIKit

class WishListViewController: UIViewController {
    
    let tableView = UITableView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.title = "Wish List"
    let clearButton = UIBarButtonItem(title: "목록 지우기", style: .done, target: self, action: #selector(didTapBarButton(_:)))
    clearButton.tag = 101
    let orderButton = UIBarButtonItem(title: "주문", style: .done, target: self, action: #selector(didTapBarButton(_:)))
    orderButton.tag = 102
    
    navigationItem.leftBarButtonItem = clearButton
    navigationItem.rightBarButtonItem = orderButton
    
    
    tableView.rowHeight = 100
    tableView.dataSource = self
    tableView.delegate = self
    setupUI()
    
    
  }
    
    func setupUI() {
        view.addSubview(tableView)
        let guide = view.safeAreaLayoutGuide
        
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
    }
    
    @objc func didTapBarButton(_ sender: UIBarButtonItem) {
        
        if sender.tag == 101 {
            //목록 지우기
            WishList.shared.orderList.removeAll()
            tableView.reloadData()
        }else {
            //주문
            var totalPrice = 0
            var totalOrder = ""
            for data in WishList.shared.orderList {
                totalOrder += "\(data.name) - \(data.count)개\n"
                totalPrice += data.price * data.count
                
            }
            
            
            totalOrder += "결제금액: \(totalPrice)"
            let alertController = UIAlertController(title: "결제내역", message: totalOrder, preferredStyle: .alert)
            let cancleAction = UIAlertAction(title: "돌아가기", style: .default)
            alertController.addAction(cancleAction)
            
            let orderAction = UIAlertAction(title: "결제하기", style: .default) { (action) in
               
                WishList.shared.orderList.removeAll()
                self.tableView.reloadData()
                
            }
            alertController.addAction(orderAction)
            present(alertController, animated: true)
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
  
}


extension WishListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WishList.shared.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell")
                if cell == nil{
                print("생성")
                cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MenuCell")
                }else {
                    print("재사용")
                }
        let product = WishList.shared.orderList[indexPath.row]
                cell!.imageView?.image = UIImage(named: product.name)
                cell!.textLabel?.text = product.name
        cell!.detailTextLabel?.text = "주문수량: \(product.count)"
        //        print(cell!.detailTextLabel)
                return cell!
    }
    
    
}

extension WishListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
