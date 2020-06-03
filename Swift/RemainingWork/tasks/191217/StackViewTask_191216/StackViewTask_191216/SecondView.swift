//
//  SecondView.swift
//  StackViewTask_191216
//
//  Created by 양중창 on 2019/12/18.
//  Copyright © 2019 didwndckd. All rights reserved.
//

import UIKit

class SecondView: UIView {
    
    let imageView0 = UIImageView(image: UIImage(named: "cat1"))
    let imageView1 = UIImageView(image: UIImage(named: "cat2"))
    let imageView2 = UIImageView(image: UIImage(named: "cat3"))
    let imageView3 = UIImageView(image: UIImage(named: "cat4"))

    let grandStackView = UIStackView()
    let topStackView = UIStackView()
    let bottomStackView = UIStackView()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(grandStackView)
        grandStackView.axis = .vertical
        grandStackView.alignment = .fill
        grandStackView.distribution = .fillEqually
        
        topStackView.axis = .horizontal
        topStackView.alignment = .fill
        topStackView.distribution = .fillEqually
        
        bottomStackView.axis = .horizontal
        bottomStackView.alignment = .fill
        bottomStackView.distribution = .fillEqually
        
        imageView0.contentMode = .scaleAspectFill
        imageView1.contentMode = .scaleAspectFill
        imageView2.contentMode = .scaleAspectFill
        imageView3.contentMode = .scaleAspectFill
        
        
        
        grandStackView.addSubview(topStackView)
        topStackView.addSubview(imageView0)
        topStackView.addSubview(imageView1)
        
        grandStackView.addSubview(bottomStackView)
        bottomStackView.addSubview(imageView2)
        bottomStackView.addSubview(imageView3)
        
        grandStackView.translatesAutoresizingMaskIntoConstraints = false
        topStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomStackView.translatesAutoresizingMaskIntoConstraints = false
        
        setUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
   func setUI() {
    
    grandStackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    grandStackView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    grandStackView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    grandStackView.heightAnchor.constraint(equalTo: grandStackView.widthAnchor).isActive = true
    
    
    
    
        
    }
    
}
