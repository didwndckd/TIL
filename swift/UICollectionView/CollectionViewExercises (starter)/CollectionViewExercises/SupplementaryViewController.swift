//
//  SupplementaryViewController.swift
//  CollectionViewExercises
//
//  Created by Giftbot on 2020/01/28.
//  Copyright © 2020 Giftbot. All rights reserved.
//
// 셀 크기 = (80, 80) / 아이템과 라인 간격 = 4 / 인셋 = (25, 5, 25, 5)
// 헤더 높이 50, 푸터 높이 3


import UIKit

final class SupplementaryViewController: UIViewController {
  
    
    private lazy var doneButton = UIBarButtonItem(title: "done", style: .done, target: self, action: #selector(didTapDoneButton(_:)))
    
    private var canMoveItem = false {
        didSet {
            
            doneButton.title = canMoveItem ? "finish" : "done"
        }
    }
    private var dataSource: [Section] = sections
    
    private let layout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 4
        layout.minimumLineSpacing = 4
        layout.sectionInset = UIEdgeInsets(top: 25, left: 5, bottom: 25, right: 5)
        layout.itemSize = CGSize(width: 80, height: 80)
        layout.headerReferenceSize = CGSize(width: 50, height: 50)
        layout.footerReferenceSize = CGSize(width: 3, height: 3)
        layout.sectionHeadersPinToVisibleBounds = true
        
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        let gesture = UILongPressGestureRecognizer(
        target: self,
        action: #selector(gestureRecognizer(_:)))
        gesture.minimumPressDuration = 0.2
        collectionView.addGestureRecognizer(gesture)
        
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "Header")
        
        collectionView.register(
            UICollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
            withReuseIdentifier: "Footer")
        
        return collectionView
    }()
    
    
    
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setNavigation()

  }
    
    private func setNavigation() {
        
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    
    @objc func didTapDoneButton(_ sender: UIBarButtonItem) {
        canMoveItem.toggle()
        
    }
    
    @objc func gestureRecognizer(_ sender: UILongPressGestureRecognizer) {
        guard canMoveItem else { return }
        
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
    
    
    
    
    private func setupUI() {
        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        
    }
    
}






// MARK: - UICollectionViewDataSource

extension SupplementaryViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sections.count
    }
    
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return sections[section].cards.count
    
  }
    
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
    cell.contentView.backgroundColor = sections[indexPath.section].cards[indexPath.item].color
    
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionHeader,
                withReuseIdentifier: "Header",
                for: indexPath) as! SectionHeaderView
            
            header.configure(title: "\(indexPath.section)번")
            return header
            
        }else {
            
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: UICollectionView.elementKindSectionFooter,
                withReuseIdentifier: "Footer",
                for: indexPath)
            footer.backgroundColor = .gray
            return footer
            
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        guard sourceIndexPath != destinationIndexPath else { return }
        
        let element = sections[sourceIndexPath.section].cards.remove(at: sourceIndexPath.item)
        sections[destinationIndexPath.section].cards.insert(element, at: destinationIndexPath.item)
        
        
    }
    
    
    
}
