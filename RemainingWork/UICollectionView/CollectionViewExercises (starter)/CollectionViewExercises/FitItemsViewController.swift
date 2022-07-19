//
//  FitItemsViewController.swift
//  CollectionViewExercises
//
//  Created by 양중창 on 2020/01/30.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class FitItemsViewController: UIViewController {
    
    let datas = cards

    private struct CellFrame {
        let itemsInLine: CGFloat = 2
        let lineOnSreen: CGFloat = 2
        let itemSpacing: CGFloat = 10
        let lineSpacing: CGFloat = 10
        let edgeInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let bottomSpacing: CGFloat = 50
    }
    
    private let layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupConstraint()
        setupCollectionView()
        
    }
    
    override func viewWillLayoutSubviews() {
//        setupLayout()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        setupLayout()
//        print(collectionView.frame)
    }
    override func viewWillAppear(_ animated: Bool) {
//        print("viewWillAppear")
    }
    
    private func setupCollectionView() {
        
        collectionView.backgroundColor = .white
        collectionView.dataSource = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
        
        
        
    }
    
    private func setupLayout() {
        
        let frame = CellFrame()
        
        layout.minimumInteritemSpacing = frame.itemSpacing
        layout.minimumLineSpacing = frame.lineSpacing
        layout.sectionInset = frame.edgeInset
        setupFitItems()
        
    }
    
    private func setupFitItems() {
//        layout.scrollDirection = .horizontal
        let frame = CellFrame()
        let itemSpacing = frame.itemSpacing * (frame.itemsInLine - 1)
        let lineSpacing = frame.lineSpacing * (frame.lineOnSreen - 1)
        let horizontalInset = frame.edgeInset.left + frame.edgeInset.right
        let verticalInset = frame.edgeInset.top
            + frame.edgeInset.bottom
        
        let isVertical = layout.scrollDirection == .vertical
        
        let itemWidth = (collectionView.bounds.width - itemSpacing - horizontalInset - (isVertical ? 0: 50)) / frame.itemsInLine
        let itemHeight = (collectionView.bounds.height - lineSpacing - verticalInset - (isVertical ? 50: 0)) / frame.lineOnSreen
        
        layout.itemSize = CGSize(width: itemWidth.rounded(.down), height: itemHeight.rounded(.down))
        
    }
    
    private func setupConstraint() {
        let guide = view.safeAreaLayoutGuide
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        collectionView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        
    }
    
    
    

    

}


extension FitItemsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        cell.contentView.backgroundColor = datas[indexPath.item].color
        
        return cell
        
    }
    
    
}
