//
//  ReorderingViewController.swift
//  CollectionViewExample
//
//  Created by Giftbot on 2020/01/28.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

final class ReorderingViewController: UIViewController {

  var parkImages = ParkManager.imageNames(of: .nationalPark)
  
  let layout = UICollectionViewFlowLayout()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.register(CustomCell.self, forCellWithReuseIdentifier: CustomCell.identifier)
        collectionView.dataSource = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
        
        
        return collectionView
    }()
  
  // MARK: - View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupFlowLayout()
    setupLongPressGestureRecognuzer()
  }


  // MARK: Setup FlowLayout

  func setupFlowLayout() {
    let itemsInLine: CGFloat = 4
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

  // MARK: Setup Gesture
  
    func setupLongPressGestureRecognuzer() {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(reorderCollectionViewItem))
        
        gesture.minimumPressDuration = 0.2
        collectionView.addGestureRecognizer(gesture)
    }
  
  
  // MARK: - Action

  @objc private func reorderCollectionViewItem(_ sender: UILongPressGestureRecognizer) {
    
    let location = sender.location(in: collectionView)
    
    switch sender.state {
    case .began:
        guard let indexPath = collectionView.indexPathForItem(at: location) else { return }
        collectionView.beginInteractiveMovementForItem(at: indexPath)
    case .changed:
        collectionView.updateInteractiveMovementTargetPosition(location)
    case .cancelled:
        collectionView.cancelInteractiveMovement()
    case .ended:
        collectionView.endInteractiveMovement()
    default:
        break
    }
    
  }
}

// MARK: - UICollectionViewDataSource

extension ReorderingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return parkImages.count * 3
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(
      withReuseIdentifier: CustomCell.identifier, for: indexPath
      ) as! CustomCell
    print("cellForItemAt")
    cell.configure(image: UIImage(named: parkImages[indexPath.item % parkImages.count]), title: parkImages[indexPath.item % parkImages.count])
    cell.backgroundColor = .black
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        guard sourceIndexPath != destinationIndexPath else { return }
        let source = sourceIndexPath.item % parkImages.count
        let destination = destinationIndexPath.item % parkImages.count
        print("source: ", source, "detr: ", destination)
        let element = parkImages.remove(at: source)
        parkImages.insert(element, at: destination)
    }
    
}




