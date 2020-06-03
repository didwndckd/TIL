//
//  WeatherCasterViewController.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit

final class WeatherCasterViewController: UIViewController {

  private let forecastService: ForecastServiceType = ForecastService()
  private let locationManager = LocationManager()
  
  private var currentForecast: CurrentForecast? {
    didSet {
      rootView.tableView.alpha = 0
      rootView.tableView.transform = CGAffineTransform(translationX: 500, y: 0)
      UIView.animate(withDuration: 0.4, animations: {
        self.rootView.tableView.alpha = 1
        self.rootView.tableView.transform = .identity
        self.rootView.tableView.reloadSections([0], with: .none)
      })
    }
  }
  private var shortRangeForecastList: [ShortRangeForecast]? {
    didSet {
      rootView.tableView.separatorStyle = .singleLine
      rootView.tableView.reloadSections([1], with: .automatic)
    }
  }

  private let rootView = WeatherCasterView()
  private let formatter = Formatter()
  
  // MARK: LifeCycle
  
  override func loadView() {
    view = rootView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self
    configureViews()
  }
  
  func configureViews() {
    rootView.reloadButton.addTarget(action: #selector(updateWeather(_:)))
    
    rootView.tableView.register(cell: CurrentForecastCell.self)
    rootView.tableView.register(cell: ShortRangeForecastCell.self)
    rootView.tableView.dataSource = self
    rootView.tableView.delegate = self
  }
  
  override var prefersStatusBarHidden: Bool { true }
  
  
  // MARK: Action
  
  var count = 0
  @objc private func updateWeather(_ sender: UIButton) {
    locationManager.startUpdatingLocation()
    
    //날씨 상태를 참고해 그에 맞는 이미지를 뿌려줄 수도 있으나 여기서는 단순 교체
    //01:맑음, 02:구름조금, 03:구름많음, 04:구름많고 비, 05:구름많고 눈,
    //06:구름많고 비 또는 눈, 07:흐림, 08:흐리고 비, 09:흐리고 눈, 10:흐리고 비 또는 눈,
    //11:흐리고 낙뢰 12:뇌우/비, 13:뇌우/눈, 14:뇌우/비 또는 눈
    let imageName = ["sunny", "lightning", "cloudy", "rainy"]
    count += 1
    rootView.updateBackgroundImage(imageName: imageName[count % imageName.count])
    
    // 회전 애니메이션
    let spinAnimation = CABasicAnimation(keyPath: "transform.rotation")
    spinAnimation.duration = 0.5
    spinAnimation.toValue = CGFloat.pi * 2
    sender.layer.add(spinAnimation, forKey: "spinAnimation")
  }
  
  private func presentAlert(title: String = "알림", message: String) {
    let alertController = UIAlertController(
      title: title, message: message, preferredStyle: .alert
    )
    let okAction = UIAlertAction(title: "확인", style: .default)
    alertController.addAction(okAction)
    
    if presentedViewController == nil {
      present(alertController, animated: true)
    }
  }
}


// MARK: - LocationManagerDelegate

extension WeatherCasterViewController: LocationManagerDelegate {
  func locationManagerShouldRequestAuthorization(_ manager: LocationManager) {
    presentAlert(message: "앱을 사용하기 위해서는 위치 권한이 필요합니다.")
  }
  
  func locationManager(_ manager: LocationManager, didReceiveAddress address: String?) {
    if let address = address {
      let now = formatter.string(from: Date(), type: .currentTime)
      rootView.updateTopInfoView(location: address, time: now)
    } else {
      presentAlert(message: "위치 조회 실패. 다시 시도해 주세요.")
    }
  }
  
  func locationManager(_ manager: LocationManager, didReceiveLocation location: Location) {
    let latitude = location.coordinate.latitude
    let longitude = location.coordinate.longitude
    fetchCurrentForecast(lat: latitude, lon: longitude)
    fetchShortRangeForecast(lat: latitude, lon: longitude)
  }
  
  private func fetchCurrentForecast(lat: Double, lon: Double) {
    forecastService.fetchCurrentForecast(latitude: lat, longitude: lon) {
      [weak self] result in
      
      DispatchQueue.main.async {
        switch result {
        case .success(let value):
          self?.currentForecast = value
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
  
  private func fetchShortRangeForecast(lat: Double, lon: Double) {
    forecastService.fetchShortRangeForecast(latitude: lat, longitude: lon) {
      [weak self] result in
      
      DispatchQueue.main.async {
        switch result {
        case .success(let value):
          self?.shortRangeForecastList = value.filter({
            $0.date.timeIntervalSinceNow > 0
          })
        case .failure(let error):
          print(error.localizedDescription)
        }
      }
    }
  }
}


// MARK: - UITableViewDataSource

extension WeatherCasterViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return ForecastType.allCases.count
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if ForecastType.current.rawValue == section {
      return currentForecast == nil ? 0 : 1
    } else {
      return shortRangeForecastList?.count ?? 0
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    // CurrentForecastCell
    if ForecastType.current.rawValue == indexPath.section {
      let cell = tableView.dequeue(CurrentForecastCell.self)
      
      if let current = currentForecast {
        // SKY-A01 -> SKY_01
        let imageName = "SKY_" + current.sky.code.dropFirst(5)
        let status = current.sky.name
        let minTemp = current.temperature.tmin
        let maxTemp = current.temperature.tmax
        let temp = String(current.temperature.tc.dropLast() + "°")
        
        cell.configureCell(
          weatherImageName: imageName,
          weatherStatus: status,
          minMaxTemp: "⤓  \(minTemp.dropLast())°   ⤒  \(maxTemp.dropLast())°",
          currentTemp: temp
        )
      }
      return cell
    } else {
      // ShortRangeForecastCell
      let cell = tableView.dequeue(ShortRangeForecastCell.self)
      if let forecast = shortRangeForecastList?[indexPath.row] {
        let day = formatter.string(from: forecast.date, type: .day)
        let time = formatter.string(from: forecast.date, type: .time)
        let imageName = "SKY_" + forecast.skyCode.dropFirst(5)
        let temp = String(format: "%.0f°", forecast.temperature)
        cell.configureCell(
          date: day, time: time, imageName: imageName, temperature: temp
        )
      }
      return cell
    }
  }
}


// MARK: - UITableViewDelegate

extension WeatherCasterViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if ForecastType.current.rawValue == indexPath.section {
      return 200
    } else {
      return 80
    }
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let topInset = scrollView.contentInset.top
    let offset = (topInset + scrollView.contentOffset.y) / topInset
    let alpha = 0.8 * min(1, offset)
    rootView.updateBlurView(alpha: alpha)
    
    let translationX = 30 * min(1, offset)
    rootView.applyParallaxEffect(translationX: translationX)
  }
}
