//
//  ShortRangeForecast.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

// Endpoint - /weather/forecast/3days

/// 단기 예보 (3일)
struct ShortRangeForecast {
  let skyCode: String
  let skyName: String
  let temperature: Double
  let date: Date
}
