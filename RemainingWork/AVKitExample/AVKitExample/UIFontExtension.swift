//
//  FontExtension.swift
//  AVKitExample
//
//  Created by 양중창 on 2020/03/20.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit

extension UIFont {
    
    // MARK: - 기기별 폰트사이즈 변경
    class func dynamicFont(fontSize size: CGFloat, weight: UIFont.Weight) -> UIFont {
        let bounds = UIScreen.main.bounds
        let height = bounds.size.height
        let base: CGFloat = 812.0 // 11Pro, iphone X, XS => 5.8 inch
        
        let multiflire: CGFloat = base / height
        
        return systemFont(ofSize: size * multiflire, weight: weight)
    }
    
        
}
