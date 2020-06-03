//
//  ForecastService.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import Foundation

// 실제 API용 클래스
final class ForecastService: ForecastServiceType {
  private let baseUrl = "https://apis.openapi.sk.com"
  private let appKey = "l7xxedccea1442a042a78d31018e0cc04c10"
  
  private func constructURLRequest(
    _ path: String,
    lat: Double,
    lon: Double
  ) -> URLRequest? {
    var urlComp = URLComponents(string: baseUrl)
    urlComp?.path = path
    urlComp?.queryItems = [
      URLQueryItem(name: "version", value: String(2)),
      URLQueryItem(name: "lat", value: String(lat)),
      URLQueryItem(name: "lon", value: String(lon)),
    ]
    guard let url = urlComp?.url else { return nil }
    
    var urlRequest = URLRequest(url: url)
    urlRequest.addValue(appKey, forHTTPHeaderField: "appKey")
    return urlRequest
  }
  
  
  // MARK: CurrentForecast
  
  func fetchCurrentForecast(
    latitude: Double,
    longitude: Double,
    completionHandler: @escaping (Result<CurrentForecast, ServiceError>) -> Void
    ) {
    let path = "/weather/current/hourly"
    guard let urlRequest = constructURLRequest(path, lat: latitude, lon: longitude)
      else { return }
    
    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      guard error == nil else { return completionHandler(.failure(.clientError)) }
      guard let header = response as? HTTPURLResponse,
        (200..<300) ~= header.statusCode
        else { return completionHandler(.failure(.invalidStatusCode)) }
      guard let data = data else { return completionHandler(.failure(.noData)) }
      
      if let currentForecast = try? CurrentForecast.decode(from: data) {
        completionHandler(.success(currentForecast))
      } else {
        completionHandler(.failure(.invalidFormat))
      }
    }
    
    task.resume()
  }
  
  
  // MARK: ShortRangeForecast
  
  func fetchShortRangeForecast(
    latitude: Double,
    longitude: Double,
    completionHandler: @escaping (Result<[ShortRangeForecast], ServiceError>) -> Void
    ) {
    let path = "/weather/forecast/3days"
    guard let urlRequest = constructURLRequest(path, lat: latitude, lon: longitude)
      else { return }
    
    let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
      guard error == nil else { return completionHandler(.failure(.clientError)) }
      guard let header = response as? HTTPURLResponse,
        (200..<300) ~= header.statusCode
        else { return completionHandler(.failure(.invalidStatusCode)) }
      guard let data = data else { return completionHandler(.failure(.noData)) }
      
      guard let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
        let weather = json["weather"] as? [String: Any],
        let forecast3days = (weather["forecast3days"] as? [[String: Any]])?.first,
        let fcst3hour = forecast3days["fcst3hour"] as? [String: Any]
        else { return completionHandler(.failure(.invalidFormat)) }
      
      guard let timeRelease = forecast3days["timeRelease"] as? String,
        let sky = fcst3hour["sky"] as? [String: String],
        let temperature = fcst3hour["temperature"] as? [String: String]
        else { return completionHandler(.failure(.invalidFormat)) }
      // 기본 파싱 완료
      
      // 셀에 들어갈 데이터 파싱
      var forecastArr: [ShortRangeForecast] = []
      for hour in stride(from: 4, through: 67, by: 3) {
        guard let skyCode = sky["code\(hour)hour"], !skyCode.isEmpty,
          let skyName = sky["name\(hour)hour"], !skyName.isEmpty,
          let tempStr = temperature["temp\(hour)hour"],
          let temp = Double(tempStr)
          else { continue }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let releaseTime = dateFormatter.date(from: timeRelease) else { continue }
        let forecastTime = releaseTime.addingTimeInterval(TimeInterval(hour) * 3600)
        
        // skyName(맑음, 흐림 등)은 데이터를 넣기만 하고 셀에서 미사용
        let forecast = ShortRangeForecast(
          skyCode: skyCode,
          skyName: skyName,
          temperature: temp,
          date: forecastTime
        )
        forecastArr.append(forecast)
      }
      
      completionHandler(.success(forecastArr))
    }
    
    task.resume()
  }
}
