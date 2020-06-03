//
//  ViewController.swift
//  CollectionViewPractice
//
//  Created by Giftbot on 2020/01/28.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: LifeCycle
    
    private var canSelect = false
    private var datas: [String] = []
    private let layout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
    
    setDatas()
  }
    
    private func setDatas() {
        for i in 0...19 {
            let named = "cat" + String(i % 10)
            datas.append(named)
        }
    }
    
    
    
    private func setupCollectionView() {
        let guide = view.safeAreaLayoutGuide
        
        setupLayout()
        
        collectionView.register(CustomCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.allowsMultipleSelection = true
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        
        
    }
    
    
    private func setupLayout() {
        let margin: CGFloat = 8
        let itemSize = (view.frame.width - (margin * 3)) / 2
        
        layout.minimumLineSpacing = margin
        layout.minimumInteritemSpacing = margin
        layout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
    }
  
  // MARK: Action
    @IBAction func didTapDeleteButton(_ sender: UIBarButtonItem) {
        
        guard let deleteDatas = collectionView.indexPathsForSelectedItems?.sorted().reversed()
            else { return }
        if canSelect {
            deleteDatas.forEach {
                datas.remove(at: $0.item)
            }
            collectionView.deleteItems(at: collectionView.indexPathsForSelectedItems ?? [])
            canSelect = false
        }else {
            canSelect = true
        }
        
        var indexPathArray: [IndexPath] = []
        if datas.isEmpty {
            setDatas()
            for (index, _) in datas.enumerated() {
                let indexPath = IndexPath(item: index, section: 0)
                indexPathArray.append(indexPath)
            }
            collectionView.insertItems(at: indexPathArray)
        }
        
        
        
    }
    
}


// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return datas.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
    let image = UIImage(named: datas[indexPath.item])
    cell.configure(selected: cell.isSelected, image: image)
    
    
    return cell
  }
}


extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return canSelect
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelected")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.isSelected = true
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print("didDeselect")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.isSelected = false
        
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldBeginMultipleSelectionInteractionAt indexPath: IndexPath) -> Bool {
        true
    }
    
    
    
}
