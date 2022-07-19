//
//  UIButtonExtension.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

extension UIButton {
  func addTarget(action: Selector) {
    guard let vc = parentViewController else {
      fatalError("버튼이 뷰 계층 구조에 추가되어 있지 않습니다.")
    }
    addTarget(vc, action: action, for: .touchUpInside)
  }
}
