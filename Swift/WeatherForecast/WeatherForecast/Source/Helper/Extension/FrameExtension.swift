//
//  FrameExtensions.swift
//  WeatherForecast
//
//  Created by giftbot on 13/06/2019.
//  Copyright © 2019 giftbot. All rights reserved.
//

import UIKit

extension CGRect {
  static var screenBounds: CGRect { UIScreen.main.bounds }
  
  static func make(
    _ x: CGFloat, _ y: CGFloat, _ width: CGFloat, _ height: CGFloat
  ) -> CGRect {
    CGRect(x: x, y: y, width: width, height: height)
  }
}

extension CGFloat {
  public static let screenWidth = UIScreen.main.bounds.size.width
  public static let screenHeight = UIScreen.main.bounds.size.height
}

extension UIView {
  var x: CGFloat {
    get { frame.origin.x }
    set { frame.origin.x = newValue }
  }
  var y: CGFloat {
    get { frame.origin.y }
    set { frame.origin.y = newValue }
  }
  var width: CGFloat {
    get { frame.width }
    set { frame.size.width = newValue }
  }
  var height: CGFloat {
    get { frame.height }
    set { frame.size.height = newValue }
  }
  var origin: CGPoint {
    get { frame.origin }
    set { frame.origin = newValue }
  }
  var size: CGSize {
    get { frame.size }
    set { frame.size = newValue }
  }
  var maxX: CGFloat { frame.origin.x + frame.size.width }
  var maxY: CGFloat { frame.origin.y + frame.size.height }
}
