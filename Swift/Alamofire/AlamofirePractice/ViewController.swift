//
//  ViewController.swift
//  AlamofirePractice
//
//  Created by 양중창 on 2020/02/21.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let tableView = UITableView()
    var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        
        ServiceManager.shared.requestUser(completionHandler: {
            (response) in
            
            switch response {
            case .success(let users):
                self.users = users
            case .failure(let error):
                print(error)
            }
            
        })
        
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.dataSource = self
        tableView.rowHeight = 80
        
        setupConstraint()
    }

    func setupConstraint() {
        
        tableView.snp.makeConstraints({
            $0.top.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        })
        
    }
    
    func requestCellImage(cell: UITableViewCell, indexPath: IndexPath) {
        let user = users[indexPath.row]
        
        ServiceManager.shared.requestImage(user.photo, completionHandler: {
            print("Request Image Success")
            switch $0 {
            case .success(let data):
                if let cell = self.tableView.cellForRow(at: indexPath){
//                    cell.textLabel?.text = user.fullName
//                    cell.detailTextLabel?.text = user.email
                    cell.imageView?.image = UIImage(data: data)
                    cell.layoutSubviews()
//                    print("image")
                }
            case .failure(let error):
                print(error)
            }
            
//            guard let data = try? $0.get() else { return }
//            guard let cell = self.tableView.cellForRow(at: indexPath) else { return }
//            cell.imageView?.image = UIImage(data: data)
//            cell.textLabel?.text = user.fullName
//            cell.detailTextLabel?.text = user.email
        })
        
    }

}




extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let user = users[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell") {
            print("Reuse")
            cell.textLabel?.text = user.fullName
            cell.detailTextLabel?.text = user.email
            requestCellImage(cell: cell, indexPath: indexPath)
            return cell
        }else {
            print("Initialze")
            let cell = MyTableViewCell(style: .subtitle, reuseIdentifier: "cell")
            cell.textLabel?.text = user.fullName
            cell.detailTextLabel?.text = user.email
            requestCellImage(cell: cell, indexPath: indexPath)
            return cell
        }
        
        
    }
    
    
    
}

class MyTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        print("Init style and reuseIdentifier")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("My cell layout subviews")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("My cell Selected: ", selected)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        print("PrepareForReuse")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}










