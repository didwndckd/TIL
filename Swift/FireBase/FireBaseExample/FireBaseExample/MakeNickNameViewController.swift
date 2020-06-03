//
//  MakeNickNameViewController.swift
//  FireBaseExample
//
//  Created by 양중창 on 2020/02/19.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit
import Firebase

class MakeNickNameViewController: UIViewController {
    
    private var ref: DocumentReference?
    private let db = Firestore.firestore()
    
    private let textField = UITextField()
    private let button = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        view.addSubview(textField)
        view.addSubview(button)
        
        view.backgroundColor = .white
        
        textField.placeholder = "닉네임 입력"
        textField.borderStyle = .roundedRect
        
        button.setTitle("닉네임 조회", for: .normal)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
        
        setupConstraint()
        
    }
    
    private func setupConstraint() {
        
        let guide = view.safeAreaLayoutGuide
        let margin: CGFloat = 8
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        button.translatesAutoresizingMaskIntoConstraints = false
        
        textField.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: margin).isActive = true
        textField.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -margin).isActive = true
        textField.topAnchor.constraint(equalTo: guide.topAnchor, constant: 160).isActive = true
        
        button.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: margin).isActive = true
        button.centerXAnchor.constraint(equalTo: guide.centerXAnchor).isActive = true
        
        
    }
    
    @objc func didTapButton() {
        
        guard let nickName = textField.text else { return }
        
        findNickName(nickName: nickName)
    }
    
    private func findNickName(nickName: String) {
        
        db.collection("users").whereField(nickName, isEqualTo: true).getDocuments(completion: {
            
            (querySnapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else {
                guard let snapshot = querySnapshot else { return }
                
                
                
            }
        })
        
    }
    
    private func addNickName(nickName: String) {
        
    }
    
    private func displayAlert(check: Bool, nickName: String ) {
        let message = check ? "사용 가능": "사용 불가"
        let alertController = UIAlertController(title: "알림", message: message, preferredStyle: .alert)
        let okAction: UIAlertAction
            
        if check {
            okAction = UIAlertAction(title: "확인", style: .default, handler: { _ in
                self.addNickName(nickName: nickName)
            })
        }else {
            okAction = UIAlertAction(title: "확인", style: .default)
        }
        alertController.addAction(okAction)
               present(alertController, animated: true)
    }
        
       

}
