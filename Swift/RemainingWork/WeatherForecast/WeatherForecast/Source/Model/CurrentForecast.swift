//
//  CurrentForecast.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

// Endpoint - /weather/current/hourly

/// 현재 기상예보 - 1시간 단위
struct CurrentForecast {
  let grid: Grid
  let wind: Wind
  let precipitation: Precipitation
  let sky: Sky
  let temperature: Temperature
  let humidity: String
  
  struct Grid: Decodable {
    let city: String
    let county: String
    let village: String
  }
  struct Wind: Decodable {
    let wdir: String
    let wspd: String
  }
  struct Precipitation: Decodable {
    let sinceOntime: String
    let type: String
  }
  struct Sky: Decodable {
    let code: String
    let name: String
  }
  struct Temperature: Decodable {
    let tc: String
    let tmax: String
    let tmin: String
  }
}


// MARK: - Decodable

extension CurrentForecast: Decodable {
  private enum CodingKeys: String, CodingKey {
    case weather
  }
  private enum WeatherKeys: String, CodingKey {
    case hourly
  }
  private enum HourlyKeys: String, CodingKey {
    case grid, wind, precipitation, sky, temperature, humidity
  }
  
  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let weather = try container.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weather)
    var hourlyArr = try weather.nestedUnkeyedContainer(forKey: .hourly) // 배열에 첫번째 인자만 꺼내서 바로 디코딩 가능
    // decoder.userInfo
    let data = try hourlyArr.nestedContainer(keyedBy: HourlyKeys.self)
    
    grid = try data.decode(Grid.self, forKey: .grid)
    wind = try data.decode(Wind.self, forKey: .wind)
    precipitation = try data.decode(Precipitation.self, forKey: .precipitation)
    sky = try data.decode(Sky.self, forKey: .sky)
    temperature = try data.decode(Temperature.self, forKey: .temperature)
    humidity = try data.decode(String.self, forKey: .humidity)
  }
}


// MARK: - CustomStringConvertible

extension CurrentForecast: CustomStringConvertible {
  var description: String {
    return """
    Grid : \(grid)
    Wind : \(wind)
    Precipitation : \(precipitation)
    Sky : \(sky)
    Temperature : \(temperature)
    Humidity : \(humidity)
    """
  }
}
