//
//  ViewController.swift
//  ScrollViewExample
//
//  Created by giftbot on 2020. 01. 05..
//  Copyright © 2020년 giftbot. All rights reserved.
//

import UIKit


final class ViewController: UIViewController {

  // MARK: Properties
  
  @IBOutlet private weak var scrollView: UIScrollView!
  @IBOutlet private weak var imageView: UIImageView!
    private var zoomScale: CGFloat = 1.0
  
  // MARK: LifeCycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView.delegate = self
//    scrollView.alwaysBounceVertical = true
//    scrollView.alwaysBounceHorizontal = true
    
    updateScrollViewZoomScale()
    
    
  }
    
    private func updateScrollViewZoomScale() {
        
        let widthScale = view.frame.width / imageView.bounds.width
        let heightScale = view.frame.height / imageView.bounds.height
        let minScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minScale
        scrollView.zoomScale = 1
        scrollView.maximumZoomScale = 3
        printInfo()
    }
  
  // MARK: Action Handler
  
  @IBAction private func fitToWidth(_ sender: Any) {
    print("\n---------- [ fitToWidth ] ----------")
    zoomScale = scrollView.frame.width / imageView.bounds.width
    print(scrollView.contentSize)
    print(imageView.bounds.size)
    scrollView.setZoomScale(zoomScale, animated: true)
    printInfo()
    
    
    
  }
  
  @IBAction private func scaleDouble(_ sender: Any) {
    print("\n---------- [ scaleDouble ] ----------")
    
    scrollView.setZoomScale(zoomScale * 2, animated: true)
    zoomScale = scrollView.zoomScale
    print(zoomScale)
    printInfo()
    
  }

  @IBAction private func moveContentToLeft(_ sender: Any) {
    print("\n---------- [ moveContentToLeft ] ----------")
    
//    let rectToVisible = CGRect(x: 100, y: 100, width: 200, height: 300)
//    scrollView.zoom(to: rectToVisible, animated: true)
//    print(scrollView.zoomScale)
    
    let newOffset = CGPoint(x: scrollView.contentOffset.x + 150,
                          y: scrollView.contentOffset.y)
    scrollView.setContentOffset(newOffset, animated: true)
    printInfo()
  }
    
    private func printInfo() {
        print("frame: \(scrollView.frame)")
        print("contentSize: \(scrollView.contentSize)")
        print("bounds: \(scrollView.bounds)")
        print("contentOffset: \(scrollView.contentOffset)")
        
    }
    
}

extension ViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        printInfo()
    }
    
}

