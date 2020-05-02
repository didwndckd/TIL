//
//  Formatter.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

struct Formatter {
  enum DateType {
    case currentTime, day, time
  }

  private let dateFormatter = DateFormatter().then {
    $0.locale = Locale(identifier: "ko")
  }
  
  func string(from date: Date, type: DateType) -> String {
    switch type {
    case .currentTime: dateFormatter.dateFormat = "a h:mm"
    case .day: dateFormatter.dateFormat = "M.d (E)"
    case .time: dateFormatter.dateFormat = "HH:mm"
    }
    return dateFormatter.string(from: date)
  }
}
