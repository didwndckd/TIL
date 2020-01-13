//
//  ImageAnimationViewController.swift
//  UIViewAnimation
//
//  Created by giftbot on 2020. 1. 7..
//  Copyright © 2020년 giftbot. All rights reserved.
//

import UIKit

final class ImageAnimationViewController: UIViewController {
  
  @IBOutlet private weak var imageView: UIImageView!
  @IBOutlet private weak var durationLabel: UILabel!
  @IBOutlet private weak var repeatCountLabel: UILabel!
  
  let images = [
    "AppStore", "Calculator", "Calendar", "Camera", "Clock", "Contacts", "Files"
    ].compactMap(UIImage.init(named: ))
    // String 배열이 UIImage 배열로 바뀐다
    
    
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.animationImages = images
  }
  
  @IBAction private func startAnimation(_ sender: Any) {
    // 1/30 초에 한장 보여줌 (기본값)
    imageView.startAnimating()
    
  }
  
  @IBAction private func stopAnimation(_ sender: Any) {
    guard imageView.isAnimating else { return }
    imageView.stopAnimating()
  }
  
  @IBAction private func durationStepper(_ sender: UIStepper) {
    durationLabel.text = "\(sender.value)"
    imageView.animationDuration = sender.value
    // sender.value 초당 한장
    
  }
  
  @IBAction private func repeatCountStepper(_ sender: UIStepper) {
    let repeatCount = Int(sender.value)
    repeatCountLabel.text = "\(sender.value)"
    imageView.animationRepeatCount = repeatCount
    // sende.value 번 싸이클 돌림
  }
}
