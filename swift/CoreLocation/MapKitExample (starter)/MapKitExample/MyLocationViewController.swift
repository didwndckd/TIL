//
//  MyLocationViewController.swift
//  MapKitExample
//
//  Created by giftbot on 2020. 1. 5..
//  Copyright © 2020년 giftbot. All rights reserved.
//

import MapKit
import UIKit

final class MyLocationViewController: UIViewController {
    
  
  @IBOutlet private weak var mapView: MKMapView!
  let locationManager = CLLocationManager()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    checkAuthorizationStatus()
    locationManager.delegate = self
    mapView.showsUserLocation = true // 사용자의 위치를 보여준다
//    mapView.mapType = .satellite // 위성사진으로 맵뷰를 보여준다
  }
  
  
  func checkAuthorizationStatus() {
    
    switch CLLocationManager.authorizationStatus() {
    case .notDetermined :
        locationManager.requestWhenInUseAuthorization()
    case .restricted, .denied: break
    case .authorizedWhenInUse:
        fallthrough
    case .authorizedAlways:
        startUpdatingLocation()
    @unknown default: break
        
    }
    
  }
  
  func startUpdatingLocation() {
    
    let status = CLLocationManager.authorizationStatus()
    guard status == .authorizedWhenInUse || status == .authorizedAlways else {
        return
    }
    
    guard CLLocationManager.locationServicesEnabled() else { return }
//        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//        locationManager.distanceFilter = 10.0
        locationManager.startUpdatingLocation()
        
    
    
    
  }
  
  @IBAction func mornitoringHeading(_ sender: Any) {
    
    guard CLLocationManager.headingAvailable() else {return}
    locationManager.startUpdatingHeading()
    
  }
  
  @IBAction func stopMornitoring(_ sender: Any) {
    locationManager.stopUpdatingHeading()
  }
}

extension MyLocationViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("locationManager didchangeAuthorization")
        switch status {
        case .authorizedWhenInUse, . authorizedAlways:
            print("Authorized")
        default:
            print("Unauthotized")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        print("locationManager didUpdateLocation")
        let current = locations.last!
        let coordinate = current.coordinate
        
        if abs(current.timestamp.timeIntervalSinceNow) < 10 {
            
        
        let span = MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001)
        
        let region = MKCoordinateRegion(center: coordinate, span: span)
        mapView.setRegion(region, animated: true)
        addAnnotation(location: current)
            }
    }

    
    func addAnnotation(location: CLLocation) {
        let annotation = MKPointAnnotation()
        annotation.title = "MyLocation"
        annotation.coordinate = location.coordinate
        mapView.addAnnotation(annotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("-----------------locationManager UpdateHeading-----------------------------")
        print("trueHeading: ", newHeading.trueHeading)
        print("magneticHeading: ", newHeading.magneticHeading)
        print("values: \(newHeading.x) \(newHeading.y), \(newHeading.z)")
    }
    
}
