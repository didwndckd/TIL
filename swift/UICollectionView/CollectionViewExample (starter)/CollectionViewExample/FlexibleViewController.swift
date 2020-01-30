//
//  FlexibleViewController.swift
//  CollectionViewExample
//
//  Created by giftbot on 2020/01/24.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

final class FlexibleViewController: UIViewController {
  
  let layout = UICollectionViewFlowLayout()
  lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
  var parkImages = ParkManager.imageNames(of: .nationalPark)
  
  
  // MARK: - View Lifecycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  // MARK: Setup CollectionView
  
  func setupCollectionView() {
    setupFlowLayout()
    collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
    collectionView.backgroundColor = .white
    collectionView.dataSource = self
    view.addSubview(collectionView)
    
  }
  
  func setupFlowLayout() {
    let itemsInLine: CGFloat = 5
    let spacing: CGFloat = 10
    let inset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    let cvWidth = collectionView.bounds.width
    let contentSize = (cvWidth - inset.left - inset.right - (spacing * (itemsInLine - 1)) )
    let itemSize = (contentSize / itemsInLine).rounded(.down) // .rounded(.down) -> 소수점 버리는 메서드
    
    layout.minimumLineSpacing = spacing
    layout.minimumInteritemSpacing = spacing
    layout.sectionInset = inset
    layout.itemSize = CGSize(width: itemSize, height: itemSize)
    
    
  }
}


// MARK: - UICollectionViewDataSource

extension FlexibleViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return parkImages.count * 5
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CustomCell.identifier, for: indexPath
      ) as! CustomCell
    cell.backgroundColor = .black
    let item = indexPath.item % parkImages.count
    cell.configure(image: UIImage(named: parkImages[item]), title: parkImages[item])
    
    
    return cell
  }

}



