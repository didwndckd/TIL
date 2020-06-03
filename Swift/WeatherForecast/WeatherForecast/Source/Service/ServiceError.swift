//
//  ServiceError.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

enum ServiceError: Error {
  case noData
  case clientError
  case invalidStatusCode
  case invalidFormat
}
