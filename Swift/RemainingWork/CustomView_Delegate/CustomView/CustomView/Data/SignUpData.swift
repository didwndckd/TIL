//
//  SignUpData.swift
//  CustomView
//
//  Created by Lee on 2019/12/11.
//  Copyright © 2019 Kira. All rights reserved.
//

import Foundation

class SignUpData {
  static let shared = SignUpData()
  
  var data = [String: Any]()
  
  private init() {}
}
