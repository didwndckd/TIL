//
//  ViewController.swift
//  UserDefaults
//
//  Created by giftbot on 2019. 11. 20..
//  Copyright © 2019년 giftbot. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    let dateStandard = "DateStandard"
    let alertStandard = "AlertStandard"
    
  @IBOutlet private weak var datePicker: UIDatePicker!
  @IBOutlet private weak var alertSwitch: UISwitch!

  // MARK: Action Handler
  
  @IBAction func saveData(_ button: UIButton) {
    
    UserDefaults.standard.set(datePicker.date, forKey: dateStandard)
    UserDefaults.standard.set(alertSwitch.isOn, forKey: alertStandard)
  }
  
  @IBAction func loadData(_ button: UIButton) {
    guard let date = UserDefaults.standard.object(forKey: dateStandard) as? Date else{return}
    let isOn = UserDefaults.standard.bool(forKey: alertStandard)
    alertSwitch.setOn(isOn, animated: true)
    datePicker.setDate(date, animated: true)
    
    
  }
}

