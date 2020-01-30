//
//  BasicViewController.swift
//  CollectionViewExercises
//
//  Created by Giftbot on 2020/01/28.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

final class BasicViewController: UIViewController {
  

    let dataSource = cards
    
    var collectionView: UICollectionView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
    
    
    
    private func setupCollectionView() {
        
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        let itemSize: CGFloat = view.frame.width / 5
        layout.itemSize = CGSize(width: itemSize, height: itemSize * 2)
        
        collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
    }
    
  
}

// MARK: - UICollectionViewDataSource

extension BasicViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return dataSource.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
    
    cell.backgroundColor = dataSource[indexPath.item].color
    
    
    
    return cell
  }
}
