//
//  LocationService.swift
//  WeatherForecast
//
//  Created by Giftbot on 2020/02/22.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import CoreLocation

// MARK: - DelegateProtocol

protocol LocationManagerDelegate: class {
  typealias Location = CLLocation
  func locationManagerShouldRequestAuthorization(_ manager: LocationManager)
  func locationManager(_ manager: LocationManager, didReceiveAddress address: String?)
  func locationManager(_ manager: LocationManager, didReceiveLocation location: Location)
}


// MARK: - LocationManager

final class LocationManager: NSObject {
  private let manager = CLLocationManager()
  private var latestUpdateDate = Date(timeIntervalSinceNow: -10)
  
  weak var delegate: LocationManagerDelegate?
  
  override init() {
    super.init()
    manager.delegate = self
    requestAuthorization()
  }
  
  private func requestAuthorization() {
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined:
      manager.requestWhenInUseAuthorization()
    case .authorizedAlways, .authorizedWhenInUse: break
    default:
      delegate?.locationManagerShouldRequestAuthorization(self)
    }
  }
  
  func startUpdatingLocation() {
    manager.startUpdatingLocation()
  }
}


// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    switch status {
    case .authorizedWhenInUse, .authorizedAlways:
      manager.startUpdatingLocation()
    default: break
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard let location = locations.last else { return }
    manager.stopUpdatingLocation()
    
    let currentDate = Date()
    if abs(latestUpdateDate.timeIntervalSince(currentDate)) > 2 {
      reverseGeocoding(location: location)
      delegate?.locationManager(self, didReceiveLocation: location)
      latestUpdateDate = currentDate
    }
  }
  
  private func reverseGeocoding(location: CLLocation) {
    let geocoder = CLGeocoder()
    geocoder.reverseGeocodeLocation(location) { [weak self] (placemarks, error) in
      guard let self = self else { return }
      guard error == nil else { return print(error!.localizedDescription) }
      guard let place = placemarks?.first else { return }
      
      let locality = place.locality ?? ""
      let subLocality = place.subLocality ?? ""
      let thoroughfare = place.thoroughfare ?? ""
      let address = locality + " " + (!subLocality.isEmpty ? subLocality : thoroughfare)
      
      DispatchQueue.main.async {
        self.delegate?.locationManager(
          self, didReceiveAddress: locality.isEmpty ? nil : address
        )
      }
    }
  }
}

