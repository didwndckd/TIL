//
//  ViewController.swift
//  YoutubeCrawlling
//
//  Created by 양중창 on 2020/01/08.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let model = Model()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        model.parsing()
        setupUI()
        
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    
}

