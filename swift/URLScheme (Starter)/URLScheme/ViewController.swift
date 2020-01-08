//
//  ViewController.swift
//  URLScheme
//
//  Created by giftbot on 2020. 1. 4..
//  Copyright © 2020년 giftbot. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  
  @IBAction private func openSetting(_ sender: Any) {
    print("\n---------- [ openSettingApp ] ----------\n")
    guard let url = URL(string: UIApplication.openSettingsURLString),UIApplication.shared.canOpenURL(url)
        else { return }
    
    UIApplication.shared.open(url)
    
    
  }
  
  @IBAction private func openMail(_ sender: Any) {
    print("\n---------- [ openMail ] ----------\n")
    //스킴을 지정해준다.
    // mailto: -> 메일 스킴
    // mailto: 다음 메일 주소를 입력하면 자동으로 메일 주소가 들어가 있는다
    // , 로 이어주면 여러명에게 동시 전송 가능
//    let scheme = "mailto:didwndckd@gmail.com,someone@mail.com,someone2@mail.com"
    
    //메일이름?cc=참조&subject=타이틀&body=내용
    let scheme = "mailto:someone@mail.com?cc=foo@bar.com&subject=title&body=MyText"
    guard let url = URL(string: scheme),
        UIApplication.shared.canOpenURL(url)
        else{return}
    print(url)
    UIApplication.shared.open(url)
    
  }

  @IBAction private func openMessage(_ sender: Any) {
    print("\n---------- [ openMessage ] ----------\n")
    let url = URL(string: "sms:01033349929")!
    guard UIApplication.shared.canOpenURL(url) else { return }
    UIApplication.shared.open(url)
  }
  
  @IBAction private func openWebsite(_ sender: Any) {
    print("\n---------- [ openWebsite ] ----------\n")
    let url = URL(string: "https://google.com")!
    guard UIApplication.shared.canOpenURL(url) else {return}
    UIApplication.shared.open(url)
    
  }
  
  @IBAction private func openFacebook(_ sender: Any) {
    print("\n---------- [ openFacebook ] ----------\n")
    //3rd Party 앱에 대해서 화이트리스트 등록 필요
    // 최초 1회 넘어갈 때 이동을 허락하면 이후부터는 바로 넘어감
    let url = URL(string: "fb:")!
    guard UIApplication.shared.canOpenURL(url) else { return }
    UIApplication.shared.open(url)
  }
  
  @IBAction private func openMyApp(_ sender: Any) {
    print("\n---------- [ openMyApp ] ----------\n")
    //let url = URL(string: "myApp:")!
    //myApp://host?name=abc&age=10
    //host: host
    //query: name=abc&age=10
    let url = URL(string: "myApp://host?name=abc&age=10")!
    guard UIApplication.shared.canOpenURL(url) else { return }
    UIApplication.shared.open(url)
  }
}




