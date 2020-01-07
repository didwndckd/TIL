//
//  GestureViewController.swift
//  GestureRecognizerExample
//
//  Created by giftbot on 2020/01/04.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

import AudioToolbox.AudioServices

final class GestureViewController: UIViewController {
  
  @IBOutlet private weak var imageView: UIImageView!
//    var center = CGPoint(x: 0, y: 0)
    var transform = true
    var lastPanPoint: CGPoint = CGPoint(x: 0, y: 0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.layer.cornerRadius = imageView.frame.width / 2
    imageView.layer.masksToBounds = true
    imageView.isUserInteractionEnabled = true
    
  }

    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        print("tapGesture")
        
        guard sender.state == .ended else { return }
        
        print(imageView.transform)
        if transform {
            imageView.transform = imageView.transform.scaledBy(x: 2, y: 2)
            // 크기를 두배로 늘려줌
            
//            imageView.transform = imageView.transform.rotated(by: 0.25)
            // 이미지를 돌려줌
            
//            imageView.transform = imageView.transform.translatedBy(x: 100, y: 100)
            // 이미지를 움직여줌
            
//        imageView.transform.a *= 2
//        imageView.transform.d *= 2
            
        } else {
            imageView.transform = CGAffineTransform.identity
            // 원래의 크기로 바꿔준다
            
//            imageView.transform.a /= 2
//            imageView.transform.d /= 2
            
        }
        
        transform.toggle()
        
        
//        imageView.bounds.size.width *= 2
//        imageView.bounds.size.height *= 2
//        imageView.layer.cornerRadius = imageView.frame.width / 2
//        imageView.layer.masksToBounds = true
        
    }
    
    @IBAction func rotationGesture(_ sender: UIRotationGestureRecognizer) {
        
        print(sender.rotation)
        imageView.transform = imageView.transform.rotated(by: sender.rotation)
        sender.rotation = 0
        
    }
    
    @IBAction func swifeGesture(_ sender: UISwipeGestureRecognizer) {
        
        print("swipeGesture")
        
        if sender.direction == .left {
            print("left")
            imageView.image = UIImage(named: "cat1")
        }else if sender.direction == .right {
            print("rigth")
            imageView.image = UIImage(named: "cat2")
        }
        
    }
    
    var initalCenter = CGPoint()
    @IBAction func panGesture(_ sender: UIPanGestureRecognizer) {
        print("panGesture")
        guard let dragView = sender.view else {return}
        // dragView -> imageView
        
        let translation = sender.translation(in: dragView.superview)
        
        if sender.state == .began {
            initalCenter = dragView.center
        }
        
        if sender.state != .cancelled {
            dragView.center = CGPoint(x: initalCenter.x + translation.x,
                                      y: initalCenter.y + translation.y)
        }else {
            dragView.center = initalCenter
        }
        
    }
    
    @IBAction func longPressGesture(_ sender: Any) {
        vibrate()
    }
    
    private func vibrate() {
        //핸드폰 진동
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
    }
    
    
}
