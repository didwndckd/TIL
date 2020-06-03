//
//  SectionViewController.swift
//  CollectionViewExample
//
//  Created by giftbot on 2020/01/24.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

final class SectionViewController: UIViewController {
  
  // CollectionView 설정
  
  let states = ParkManager.imageNames(of: .state)
  let parkList = ParkManager.list
    let layout: UICollectionViewFlowLayout = {
       let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        layout.minimumInteritemSpacing = 15
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 150, height: 150)
        layout.headerReferenceSize = CGSize(width: 60, height: 60)
        layout.footerReferenceSize = CGSize(width: 50, height: 50)
        // header, footer 를 만들려면 height값 필수(세로방향 스크롤일 때)
        // 가로방향 스크롤에서는 width값 필수
        
        
        layout.sectionHeadersPinToVisibleBounds = true
//        layout.sectionFootersPinToVisibleBounds = true
        return layout
    }()
    lazy var collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupCollectionView()
  }
  
  func setupCollectionView() {
    collectionView.register(SectionCell.self, forCellWithReuseIdentifier: SectionCell.identifier)
    
    collectionView.register( // section header 레지스터
        SectionHeaderView.self,
        forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
        withReuseIdentifier: SectionHeaderView.identifier)
    
    collectionView.register( // section footer 레지스터
    SectionFooterView.self,
    forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
    withReuseIdentifier: SectionFooterView.identifier)
    
    collectionView.dataSource = self
    collectionView.backgroundColor = .white
    view.addSubview(collectionView)
  }
}

// MARK: - UICollectionViewDataSource

extension SectionViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        states.count
    }
    
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    let parks = parkList.filter({ $0.location.rawValue == states[section]})
    
    return parks.count * 2
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SectionCell.identifier, for: indexPath
    ) as! SectionCell
    let parks = parkList.filter({$0.location.rawValue == states[indexPath.section]})
    let parkName = parks[indexPath.row % parks.count].name
    cell.configure(image: UIImage(named: parkName), title: parkName)
    
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionHeader {
            
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionHeaderView.identifier,
                for: indexPath) as! SectionHeaderView
            let state = states[indexPath.section]
            header.configure(image: UIImage(named: state), title: state)
            
            return header
            
        }else {
            
            let footer = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: SectionFooterView.identifier,
                for: indexPath) as! SectionFooterView
            
            let count = parkList.filter({$0.location.rawValue == states[indexPath.section]}).count * 2
            let title = "총 \(count)개의 이미지"
            footer.configure(title: title)
            return footer
            
        }
        
    }
    
    
}

