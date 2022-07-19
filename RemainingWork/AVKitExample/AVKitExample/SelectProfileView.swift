//
//  SelectProfileView.swift
//  AVKitExample
//
//  Created by 양중창 on 2020/03/20.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

class SelectProfileView: UIView {
    
    private let layout = UICollectionViewFlowLayout()
    private let collectionView: UICollectionView
    private var profiles = ""
    
    override init(frame: CGRect) {
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(frame: frame)
        
        setUI()
        setConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setCollectionViewLayout() {
        
        
        
    }
    
    private func setUI() {
        [collectionView].forEach({
            addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
    }
    
    private func setConstraint() {
        
    }

    
}
