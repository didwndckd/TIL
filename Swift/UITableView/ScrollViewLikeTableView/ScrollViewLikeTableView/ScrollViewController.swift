//
//  ScrollViewController.swift
//  ScrollViewLikeTableView
//
//  Created by 양중창 on 2020/01/29.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class ScrollViewController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        makeLabels()
    }
    
    
    private func setupUI() {
        view.addSubview(scrollView)
        view.backgroundColor = .white
        let guide = view.safeAreaLayoutGuide
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        
        scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        
        scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        
        scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    }

    private func makeLabels() {
        var labels = [UILabel]()
        for menu in menuData {
            let sectionLabel = UILabel()
            sectionLabel.text = menu.category
            sectionLabel.backgroundColor = .gray
            labels.append(sectionLabel)
            scrollView.addSubview(sectionLabel)
            sectionLabel.heightAnchor.constraint(equalToConstant: 28).isActive = true
            
            for product in menu.products {
                let rowLabel = UILabel()
                rowLabel.text = product.name
                labels.append(rowLabel)
                scrollView.addSubview(rowLabel)
                rowLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
            }
        }
        
        for (index, label) in labels.enumerated() {
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
            label.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            
            switch index {
            case 0 :
                label.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
                
            case labels.count - 1:
                label.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
                fallthrough
                
            default:
                label.topAnchor.constraint(equalTo: labels[index - 1].bottomAnchor).isActive = true
                break
            }
        }
        
    }

}
