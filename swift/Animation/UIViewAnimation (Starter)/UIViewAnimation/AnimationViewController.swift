//
//  AnimationViewController.swift
//  UIViewAnimation
//
//  Created by giftbot on 2020. 1. 7..
//  Copyright © 2020년 giftbot. All rights reserved.
//

import UIKit

final class AnimationViewController: UIViewController {
  
  // MARK: - Properties
  
  @IBOutlet private weak var userIdTextField: UITextField!
  @IBOutlet private weak var passwordTextField: UITextField!
  @IBOutlet private weak var loginButton: UIButton!
  @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
  @IBOutlet private weak var countDownLabel: UILabel!
  @IBOutlet weak var frameView: UIView!
  @IBOutlet weak var tempView: UIView!
    
    func test() {
        let initialFrame = tempView.frame
        
        // withDyration -> 전체 시간
        // withRelativeStartTime -> 시작 시간(withDyration의 비율로)
        // relativeDuration -> 애니메이션 동작 시간
        
        UIView.animateKeyframes(withDuration: 10,
                                delay: 0,
                                animations: {
                                    // 0초 -> 0.25초 동안 애니메이션
                                    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.25, animations: {
                                        self.tempView.center.x += 50
                                        self.tempView.center.y -= 150
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                                        // 2.5초 -> 2.5초동안 애니메이션
                                        self.tempView.center.x += 100
                                        self.tempView.center.y += 50
                                    })
                                    UIView.addKeyframe(withRelativeStartTime: 0.7, relativeDuration: 0.3, animations: {
                                        // 7초 -> 3초동안 애니메이션
                                        self.tempView.frame = initialFrame
                                    })
        }
        )
    }
    
    
    var count = 4 {
    didSet { countDownLabel.text = "\(count)" }
  }
  
  // MARK: - View LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        frameView.center.x = view.center.x
        activityIndicatorView.isHidden = true
    }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    // 최초 텍스트 필드와 로그인 버튼을 왼쪽 보이지 않는 부분으로 이동
    userIdTextField.center.x = -view.frame.width
    passwordTextField.center.x = -view.frame.width
    loginButton.center.x = -view.frame.width
    
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    // 텍스트 필드 들을 원래 위치로 애니메이션 이동
    UIView.animate(withDuration: 0.6,  animations: {
        self.userIdTextField.center.x = self.userIdTextField.superview!.bounds.midX
    })
    UIView.animate(withDuration: 0.6, delay: 0.5,  animations: {
        self.passwordTextField.center.x = self.passwordTextField.superview!.bounds.midX
    })
//    UIView.animate(withDuration: 0.6, delay: 1,  animations: {
//        self.loginButton.center.x = self.loginButton.superview!.bounds.midX
//    })
    
    // loginButton 원위치
    UIView.animate(withDuration: 2, // 애니메이션 시간
                   delay: 1,        // 딜레이
                   usingSpringWithDamping: 0.6, // 도착해서 튕기는 정도
                   initialSpringVelocity: 0,
                   options: [.curveEaseInOut,
//                             .autoreverse,
//                             .repeat
                            ], animations: {
            
                    self.loginButton.center.x = self.loginButton.superview!.bounds.midX
                    },
                               completion: { (result: Bool) in
                    // 애니메이션이 정상적으로 완료 되었는지를 BoolType 매개변수로 받을 수 있음
                    print("isFinished: ", result)
    })
    
    //usingSpringWithDamping -> 감쇠 조화 진동좌 -> 도착해서 튕기는 정도?
    //initialSpringVelocity -> 이거도 튕기는 정도?
    
    // options ->
    // .curveEase*-> 나오는 형식정도?
    // .autoreverse -> 애니메이션을 다시 되돌리는 옵션
    // .repeat -> 애니메이션을 반복한다
    
//    test()
    
  }
  
  // MARK: - Action Handler
  
  @IBAction private func didEndOnExit(_ sender: Any) {}
  
  @IBAction private func login(_ sender: Any) {
  }

  
  func addAnimateKeyframes() {
  }
    func loginAction() {
        let centerOrigin = loginButton.center
        
        UIView.animateKeyframes(withDuration: 1.6,
                                delay: 0,
                                animations: {
                                    // 우 하단으로 이동
                                    UIView.addKeyframe(withRelativeStartTime: 0.0,          relativeDuration: 0.25,
                                                       animations: {
                                                        self.loginButton.center.x += 50
                                                        self.loginButton.center.y += 20
                                    })
                                    // 1/4 회전하며 우상단으로 이동후 사라짐
                                    UIView.addKeyframe(withRelativeStartTime: 0.25, relativeDuration: 0.25, animations: {
                                        self.loginButton.transform = CGAffineTransform(rotationAngle: .pi / 4)
                                        self.loginButton.center.x += 150
                                        self.loginButton.center.y -= 70.0
                                        self.loginButton.alpha = 0.0
                                    })
                                    //superView의 아래 120 밑으로 이동
                                    UIView.addKeyframe(withRelativeStartTime: 0.51, relativeDuration: 0.01, animations: {
                                        self.loginButton.transform = .identity
                                        self.loginButton.center = CGPoint(
                                            x: centerOrigin.x,
                                            y: self.loginButton.superview!.bounds.height + 120
                                        )
                                    })
                                    // 밑에서 올라오며 나타남
                                    UIView.addKeyframe(withRelativeStartTime: 0.75, relativeDuration: 0.25, animations: {
                                        self.loginButton.alpha = 1.0
                                        self.loginButton.center = centerOrigin
                                    })
        }) {
            _ in
            self.activityIndicatorView.isHidden = true
        }
        
    }
  
  @IBAction func loginButtonAnimation() {
    view.endEditing(true)
    
    guard countDownLabel.isHidden else { return }
    activityIndicatorView.isHidden = false
    activityIndicatorView.startAnimating()
    loginAction()
    countDown()
    
    
    
    
    
  }
  
  func countDown() {
    
    countDownLabel.isHidden = false
    UIView.transition(with: countDownLabel,
                      duration: 0.4,
                      options: [.transitionFlipFromLeft],
                      animations: {
                        self.count -= 1
    }) {
        _ in
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            guard self.count == 0 else { return self.countDown()}
            self.count = 4
            self.countDownLabel.isHidden = true
            self.activityIndicatorView.stopAnimating()
        }
    }
    
  }
}
