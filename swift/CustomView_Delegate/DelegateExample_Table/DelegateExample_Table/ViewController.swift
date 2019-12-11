//
//  ViewController.swift
//  DelegateExample_Table
//
//  Created by 양중창 on 2019/12/11.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var tableView: CustomTableView?
    var cnt = 0
   
    
    var arr: [(String, String)] = []

    let nextViewButton = UIButton(type: .system)
    let addButton = UIButton(type: .system)
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let frame = CGRect(x: 0,
           y: 100,
           width: view.frame.size.width,
           height: view.frame.size.height)
        
        
        tableView = CustomTableView(frame, view, arr)
        tableView?.delegate = self
        tableView?.setTable(arr: arr)
        setUI()
        
    }
    
    func setUI () {
        nextViewButton.frame = CGRect(x: 0, y: 50, width: 200, height: 40)
        nextViewButton.setTitle("NextView", for: .normal)
        nextViewButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        view.addSubview(nextViewButton)
        
        addButton.frame = CGRect(x: view.frame.size.width - 200, y: 50, width: 200, height: 40)
               addButton.setTitle("add", for: .normal)
               addButton.addTarget(self, action: #selector(didTapAdd(_:)), for: .touchUpInside)
               view.addSubview(addButton)
    }
    
    @objc func didTapAdd(_ sender: UIButton) {
        arr.append(("\(cnt)","\(cnt)"))
        cnt += 1
        tableView?.modify(arr: arr)
    }
    
    @objc func didTapButton(_ sender: UIButton) {
        let secondVC = SecondViewController()
        present(secondVC, animated: true)
    }


}

extension ViewController: TableDelegate {
    
    func cell(position: Int) -> MyCell {
        
        let mycell = FirstCell()
        
        mycell.label.text = arr[position].0
        mycell.label2.text = arr[position].1
        
        return mycell
    }
    
    
    func count() -> Int {
        return arr.count
    }
    
    
    
    
}

