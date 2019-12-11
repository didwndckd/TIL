//
//  SecondViewController.swift
//  DelegateExample_Table
//
//  Created by 양중창 on 2019/12/11.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    var tableView: CustomTableView?
    var arr: [String] = []
    var cnt = 0
    let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let frame = CGRect(x: 0,
        y: 100,
        width: view.frame.size.width,
        height: view.frame.size.height)
        
        tableView = CustomTableView(frame, view, arr)
        tableView?.delegate = self
        tableView?.setTable(arr: arr)
        
        
        setUI()
        // Do any additional setup after loading the view.
    }
    
    
    
    func setUI () {
        
        button.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        button.setTitle("add", for: .normal)
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        
        
        
    }
    
    @objc func didTapButton (_ sender: UIButton) {
        
        arr.append("\(cnt)")
        cnt += 1
        tableView?.modify(arr: arr)
        
    }
    

}

extension SecondViewController: TableDelegate {
    
    func cell(position: Int) -> MyCell {
        let cell = SecondCell()
        
        cell.delegate = self
        cell.position = position
        cell.label.text = arr[position]
        cell.button.setTitle("\(arr[position]) 버튼", for: .normal)
        
        
        return cell
    }
    
    
    func count() -> Int {
        arr.count
    }
}

extension SecondViewController: SecondCellDelegate {
    func didTapButton(position: Int) {
        let alert = UIAlertController(title: "\(arr[position]) 버튼", message: "클릭함", preferredStyle: .alert)
        let cancle = UIAlertAction(title: "Cancle", style: .cancel)
        alert.addAction(cancle)
        present(alert, animated: true)
    }
    
    
}
