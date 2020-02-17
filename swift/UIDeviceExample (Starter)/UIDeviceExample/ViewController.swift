//
//  ViewController.swift
//  UIDeviceExample
//
//  Created by giftbot on 2020/01/28.
//  Copyright © 2020 giftbot. All rights reserved.
//

import UIKit

/***************************************************
 UIDevice
 - 디바이스 이름 / 모델 / 화면 방향 등
 - OS 이름 / 버전
 - 인터페이스 형식 (phone, pad, tv 등)
 - 배터리 정보
 - 근접 센서 정보
 - 멀티태스킹 지원 여부
 ***************************************************/


final class ViewController: UIViewController {
  
  @IBOutlet private weak var label: UILabel!
  let device = UIDevice.current
  let notiCenter = NotificationCenter.default
  
  @IBAction private func systemVersion() {
    print("\n---------- [ System Version ] ----------\n")
    
    print("Sysyem Name: ", device.systemName)
    let systemVersion = device.systemVersion
    print(systemVersion)
    label.text = systemVersion
    
    let splitVersion = systemVersion.split(separator: ".").compactMap({ Int($0) })
    print(splitVersion)
    
    
    
  }
    
    @objc func keyBoardWillShowNotification(_ noti: Notification) {
        
        guard
        let userInfo = noti.userInfo,
        let frame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect, // 키보드의 프레임 값
        let duration = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? TimeInterval // 키보드가 올라오는 시간
        else { return }
        
        
    }
  
  @IBAction private func architecture() {
    print("\n---------- [ Architecture ] ----------\n")
    
    
    //환경변수에 대한 조건문 (어떤 환경 일때에 대한 조건)
    #if targetEnvironment(simulator) // 시뮬레이터 상황
    print("Simulator")
    label.text = "Simulator"
    #else
    print("Device")
    label.text = "Device"
    #endif
    
    // DEBUGMODE 에서만 작동
    #if DEBUG
    print("debugging")
    #endif
    
    
    // iOS 여부
    print("TARGET_OS_IOS: ", TARGET_OS_IOS)
    print("TARGET_CPU_X86: ", TARGET_CPU_X86)
    print("TARGET_CPU_X86_64: ", TARGET_CPU_X86_64)
    
    print("TARGET_CPU_ARM: ", TARGET_CPU_ARM)
    print("TARGET_CPU_ARM64: ", TARGET_CPU_ARM64)
    
  }
  
  @IBAction private func deviceModel() {
    print("\n---------- [ Device Model ] ----------\n")
    
    print("name: ", device.name)
    print("model: ", device.model)
    print("localizedModel: ", device.localizedModel)
    print("userInterfaceIdiom: ", device.userInterfaceIdiom)
    print("orientation: ", device.orientation)
    print("isMultitaskingSupported: ", device.isMultitaskingSupported)
    
    //extension
    print("modelIdentifire: ", device.identifier)
    print("modelName: ", device.modelName)
    label.text = "\(device.identifier), \(device.modelName)"
    
    
  }
  
  
  // MARK: - Battery
  
  @IBAction private func battery() {
    print("\n-------------------- [ Battery Info ] --------------------\n")
    
    print("betteryState: ", device.batteryState)
    print("betteryLevel: ", device.batteryLevel)
    print("isBatteryMoniteringEnable :", device.isBatteryMonitoringEnabled)
    label.text = "\(device.batteryState) : \(device.batteryLevel)"
    
    
  }
  
  @IBAction private func batteryMonitoring(_ sender: UIButton) {
    print("\n---------- [ batteryMonitoring ] ----------\n")
    sender.isSelected.toggle()
    device.isBatteryMonitoringEnabled.toggle()
    
    if device.isBatteryMonitoringEnabled {
        notiCenter.addObserver(
            self,
            selector: #selector(didChangeBatteryState(_:)),
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil)
    }else {
        notiCenter.removeObserver(
            self,
            name: UIDevice.batteryStateDidChangeNotification,
            object: nil)
    }
    
  }
  
  @objc func didChangeBatteryState(_ noti: Notification) {
    guard let device = noti.object as? UIDevice else { return }
    print("batteryState: ", device.batteryState)
    print("batteryLevel: ", device.batteryLevel)
    
  }
  
  
  // MARK: - Proximity State
  
  @IBAction private func proximityMonitoring(_ sender: UIButton) {
    print("\n-------------------- [ Proximity Sensor ] --------------------\n")
    sender.isSelected.toggle()
    device.isProximityMonitoringEnabled.toggle()
    print("ProximityMoniterring: ", device.isProximityMonitoringEnabled)
    
    if device.isProximityMonitoringEnabled {
        notiCenter.addObserver(
            self,
            selector: #selector(didChangeProximityState(_:)),
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil)
    }else {
        notiCenter.removeObserver(
            self,
            name: UIDevice.proximityStateDidChangeNotification,
            object: nil)
    }
  }
  
  @objc func didChangeProximityState(_ noti: Notification) {
    print(UIDevice.current.proximityState)
    label.text = "\(UIDevice.current.proximityState)"
  }
  
  
  // MARK: - Orientation Notification
  
  @IBAction private func beginOrientationNotification() {
    print(device.isGeneratingDeviceOrientationNotifications)
    device.beginGeneratingDeviceOrientationNotifications() // true false가 아니라 count 로
    label.text = "\(device.isGeneratingDeviceOrientationNotifications)"
    
    notiCenter.addObserver(
        self,
        selector: #selector(orientationDidChange(_:)),
        name: UIDevice.orientationDidChangeNotification,
        object: nil)
  }
  
  @objc func orientationDidChange(_ noti: Notification) {
    
    if let device = noti.object as? UIDevice {
        print("Device Orientation: ", device.orientation)
    }
    
    if #available(iOS 13, *) {
        let scene = UIApplication.shared.connectedScenes.first
        let orientation = (scene as! UIWindowScene).interfaceOrientation
        print("Interface Orientation: ",orientation) // 콘텐츠가 표시되는 방향
    }else {
        let orientation = UIApplication.shared.statusBarOrientation
        print("StatusBar Orientation: ", orientation)
        print(orientation.isPortrait)
        print(orientation.isLandscape)
    }
    
    // StatusBar Orientation의 값 중 ipsideDown은 노치 있는 기기에서는 미지원 ( iPhone8 이하에서만 지원)
    
  }
  
  @IBAction private func endOrientationNotification() {
    
    while device.isGeneratingDeviceOrientationNotifications {
        // beginGeneratingDeviceOrientationNotifications이 true/false 가 아니라 count 이기 때문에 begin 한 횟수만큼 꺼줘야함
        device.endGeneratingDeviceOrientationNotifications()
    }
    
    
    notiCenter.removeObserver(
        self,
        name: UIDevice.orientationDidChangeNotification,
        object: nil)
    
    label.text = "\(device.isGeneratingDeviceOrientationNotifications)"
  }
    

}





