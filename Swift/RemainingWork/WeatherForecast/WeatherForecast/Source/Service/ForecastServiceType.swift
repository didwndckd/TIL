//
//  ForecastServiceType.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

protocol ForecastServiceType {
  func fetchCurrentForecast(
    latitude: Double,
    longitude: Double,
    completionHandler: @escaping (Result<CurrentForecast, ServiceError>) -> Void
  )
  
  func fetchShortRangeForecast(
    latitude: Double,
    longitude: Double,
    completionHandler: @escaping (Result<[ShortRangeForecast], ServiceError>) -> Void
  )
}
