//
//  ViewController.swift
//  FireBaseExample
//
//  Created by 양중창 on 2020/02/12.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAnalytics
import FirebaseRemoteConfig

class ViewController: UIViewController {
    var ref: DatabaseReference!
    var idCheck = false
    var remotConfig: RemoteConfig!
    
    
    @IBOutlet weak var remoteConfigLabel: UILabel!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var birthdayTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        
    }
    
    private func srtupRemoteConfig() {
        
    }
    
    private func displayAlert(message: String) {
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
    
    
    @IBAction func didTapInsertButton(_ sender: Any) {
        guard
            let email = emailTextField.text,
            let birthday = birthdayTextField.text,
            let name = nameTextField.text
            else { return }
        let userInfo = ["email": email, "birthday": birthday, "name": name]
        
        ref.child("user")
        .childByAutoId()
            .setValue(userInfo) { [weak self] error, _ in
                if let error = error {
                    self?.displayAlert(message: "에러")
                    print(error.localizedDescription)
                }else {
                    self?.displayAlert(message: "완료")
                }
        }
        
        
    }
    
    @IBAction func didTapinquire(_ sender: Any) {
        
        guard let name = nameTextField.text else { return }
        
        ref.child("user")
        .queryOrdered(byChild: "name")
        .queryEqual(toValue: name)
        .queryLimited(toLast: 1)
            .observeSingleEvent(of: .value, with: { snapshot in
                guard
                    let userDatas = snapshot.value as? [String: [String: Any]],
                    let userData = userDatas.first
                    else {
                        self.displayAlert(message: "없음")
                        return
                }
                
                let value = userData.value
                guard
                let userEmail = value["email"] as? String,
                let userName = value["name"] as? String,
                let userBirthDay = value["birthday"] as? String
                    else { return }
                
                let message = "\(userName)\n\(userEmail)\n\(userBirthDay)"
                self.displayAlert(message: message)
                
                
            })
        
        
        
    }
    
    @IBAction func didTapLogButton(_ sender: Any) {
        
        Analytics.logEvent("LogButton", parameters: ["Device": UIDevice.current])
        
    }
    
    
}

