//
//  DetailViewController.swift
//  DominoStarter
//
//  Created by Lee on 2019/12/27.
//  Copyright © 2019 Kira. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var orderCount = 0{
        willSet {
            orderAmountLabel.text = "\(newValue) 개"
        }
    }
    var productTitle = ""
    var price = 0
    var category = ""
    
    let productImage = UIImageView()
    let additionButton = UIButton(type: .system)
    let subtractionButton = UIButton(type: .system)
    let orderAmountLabel = UILabel()
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.topItem?.title = category
    setupWiget()
    setupUI()
    
  }
    
    
    func setupWiget() {
        let font: CGFloat = 25
        //additionButton 세팅
        additionButton.translatesAutoresizingMaskIntoConstraints = false
        additionButton.setTitle("+", for: .normal)
        additionButton.backgroundColor = .white
        additionButton.tintColor = .darkGray
        additionButton.titleLabel?.font = .systemFont(ofSize: font)
        additionButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        //additionButton 세팅
        
        //subtractionButton 세팅
        subtractionButton.translatesAutoresizingMaskIntoConstraints = false
        subtractionButton.setTitle("-", for: .normal)
        subtractionButton.backgroundColor = .white
        subtractionButton.tintColor = .darkGray
        subtractionButton.titleLabel?.font = .systemFont(ofSize: font)
        subtractionButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
//        subtractionButton.
        
        //subtractionButton 세팅
        
        //orderAmountLabel 세팅
        orderAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        orderAmountLabel.text = "0 개"
        orderAmountLabel.font = .systemFont(ofSize: font)
        orderAmountLabel.textColor = .white
        //orderAmountLabel 세팅
        
        //productImage 세팅
        productImage.image = UIImage(named: productTitle)
        productImage.contentMode = .scaleAspectFit
        productImage.translatesAutoresizingMaskIntoConstraints = false
        //productImage 세팅
    }
    
    func setupUI() {
        // 기본 설정
        let guide = view.safeAreaLayoutGuide
        view.backgroundColor = .systemBackground
        navigationItem.title = productTitle
        //기본 설정
        
        
        let margin: CGFloat = 64
        // amountStackView
        let amountStackView = UIView()
        view.addSubview(amountStackView)
        view.addSubview(productImage)
        
        amountStackView.translatesAutoresizingMaskIntoConstraints = false
        amountStackView.backgroundColor = .darkGray
        
        amountStackView.addSubview(subtractionButton)
        amountStackView.addSubview(orderAmountLabel)
        amountStackView.addSubview(additionButton)
        
        
        amountStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -margin).isActive = true
        amountStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: margin).isActive = true
        amountStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -margin).isActive = true
        //amountStackView
        let orderAmountMargin: CGFloat = 5
        
        
        subtractionButton.leadingAnchor.constraint(equalTo: amountStackView.leadingAnchor, constant: orderAmountMargin).isActive = true
        subtractionButton.topAnchor.constraint(equalTo: amountStackView.topAnchor, constant: orderAmountMargin).isActive = true
        subtractionButton.bottomAnchor.constraint(equalTo: amountStackView.bottomAnchor, constant: -orderAmountMargin).isActive = true
        subtractionButton.widthAnchor.constraint(equalTo: subtractionButton.heightAnchor).isActive = true
        
        additionButton.trailingAnchor.constraint(equalTo: amountStackView.trailingAnchor, constant: -orderAmountMargin).isActive = true
        additionButton.topAnchor.constraint(equalTo: amountStackView.topAnchor, constant: orderAmountMargin).isActive = true
        additionButton.bottomAnchor.constraint(equalTo: amountStackView.bottomAnchor, constant: -orderAmountMargin).isActive = true
        additionButton.widthAnchor.constraint(equalTo: additionButton.heightAnchor).isActive = true
        
        orderAmountLabel.centerXAnchor.constraint(equalTo: amountStackView.centerXAnchor).isActive = true
        orderAmountLabel.centerYAnchor.constraint(equalTo: amountStackView.centerYAnchor).isActive = true
        
        
        productImage.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        productImage.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        productImage.topAnchor.constraint(equalTo: guide.topAnchor, constant: margin).isActive = true
        productImage.bottomAnchor.constraint(equalTo: amountStackView.topAnchor, constant: -margin).isActive = true
        
        
    }
    
    func orderSet(count: Int) {
        if let index = WishList.shared.orderList.firstIndex(where: {$0.name == productTitle}){
            WishList.shared.orderList[index].count = count
        }else {
            WishList.shared.orderList.append(Order(name: productTitle, count: count, price: price))
        }
    }
    
    @objc func didTapButton (_ sender: UIButton) {
        
        switch sender.titleLabel?.text {
        case "+":
            orderCount += 1
            orderSet(count: orderCount)
            print(WishList.shared.orderList[0].count)
            
        case "-":
            if orderCount > 0 {
                orderCount -= 1
                orderSet(count: orderCount)
                print(WishList.shared.orderList[0].count)
            }
        default:
            return
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let index = WishList.shared.orderList.firstIndex(where: {$0.name == productTitle}){
            orderCount = WishList.shared.orderList[index].count
        }else{
            orderCount = 0
        }
        
    }

}
