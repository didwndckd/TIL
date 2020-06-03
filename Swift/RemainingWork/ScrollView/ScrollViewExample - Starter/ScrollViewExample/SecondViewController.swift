//
//  SecondViewController.swift
//  ScrollViewExample
//
//  Created by 양중창 on 2020/01/10.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    
    
    private let scrollView = UIScrollView()
    private let pageControl = UIPageControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDidLoad()")
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        setupUI()
        
    }
    
    private func setupUI() {
        let guide = view.safeAreaLayoutGuide
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
        
        
        pageControl.numberOfPages = 5
        print(pageControl.subviews.count)
        view.addSubview(pageControl)
        
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -48).isActive = true
        pageControl.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        setupPageControl(pageControl: pageControl)
        
        
      
    }
    

    func setupPageControl (pageControl: UIPageControl) {
        
        var views: [UIView] = []
        for i in 0..<pageControl.subviews.count {
            let view = UIView()
            let randomRed: CGFloat = CGFloat(drand48())
            let randomBlue: CGFloat = CGFloat(drand48())
            let randomGreen: CGFloat = CGFloat(drand48())
            view.backgroundColor = UIColor(red: randomRed, green: randomBlue, blue: randomGreen, alpha: 1.0)
            view.translatesAutoresizingMaskIntoConstraints = false
            scrollView.addSubview(view)
            
            let leadingConstraint = i == 0 ? scrollView.topAnchor : views[i - 1].bottomAnchor
            
            view.topAnchor.constraint(equalTo: leadingConstraint).isActive = true
            view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
            view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
            view.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
            
            if i == (pageControl.subviews.endIndex - 1) {
                view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
            }
            views.append(view)
        }
    }
    
}

extension SecondViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 스크롤뷰가 움직일때마다 호출
        print("scrollViewDidScroll")
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // 스크롤뷰에서 손을 뗐을때 호출
        print("scrollViewDidEndDragging()")
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewDidEndDecelerating()")
        // 스크롤뷰 드래그가 끝난후 스크롤뷰가 멈췄을 때 호출
        pageControl.currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        print(scrollView.contentSize)
    }
    
    
    
}
