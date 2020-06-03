//
//  DecodableExtension.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

extension Decodable {
  static func decode(
    from data: Data,
    decoder: JSONDecoder = JSONDecoder()
    ) throws -> Self {
    return try decoder.decode(self, from: data)
  }
}
