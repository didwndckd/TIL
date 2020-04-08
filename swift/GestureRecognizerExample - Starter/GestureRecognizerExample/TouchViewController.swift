//
//  TouchViewController.swift
//  GestureRecognizerExample
//
//  Created by giftbot on 2020/01/04.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

final class TouchViewController: UIViewController {

  @IBOutlet private weak var imageView: UIImageView!
    let defaultImage = UIImage(named: "cat1")
    let changeImage = UIImage(named: "cat2")
    var beforeTouchPoint: CGPoint = CGPoint(x: 0, y: 0)
    var isHoldingImage = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageView.layer.cornerRadius = imageView.frame.width / 2
//    imageView.clipsToBounds = true
    imageView.layer.masksToBounds = true
    // 화면 밖을 벗어나는 이미지를 잘라낸다
    
  }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("-----------touchBegan------------")
        guard let touch = touches.first else {return}
        let touchPoint = touch.location(in: touch.view)
        print(touchPoint)
        
        if imageView.frame.contains(touchPoint) {
            isHoldingImage = true
            imageView.image = changeImage
            beforeTouchPoint = touchPoint
        }
        
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        print("------------touchMoved---------------")
        
        guard let touch = touches.first else {return}
        let touchPoint = touch.location(in: touch.view)
        print(touchPoint)
        if isHoldingImage {
            
            let dePointX = beforeTouchPoint.x - touchPoint.x
            let dePointY = beforeTouchPoint.y - touchPoint.y
            
            imageView.center.x -= dePointX
            imageView.center.y -= dePointY

            beforeTouchPoint = touchPoint
            
//            let preTouchPoint = touch.previousLocation(in: touch.view)
//            imageView.center.x = imageView.center.x + (touchPoint.x - preTouchPoint.x)
//            imageView.center.y = imageView.center.y + (touchPoint.y - preTouchPoint.y)
        }
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        print("---------------touchEnded-------------")
        imageView.image = defaultImage
        isHoldingImage = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        imageView.image = defaultImage
        isHoldingImage = false
    }
  
}



