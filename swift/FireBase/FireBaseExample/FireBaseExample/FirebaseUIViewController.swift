//
//  FirebaseUIViewController.swift
//  FireBaseExample
//
//  Created by 양중창 on 2020/02/19.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import UIKit
import FirebaseUI

class FirebaseUIViewController: UIViewController {
    var authUI: FUIAuth?

    override func viewDidLoad() {
        super.viewDidLoad()
        emailSignInCheck()
        

    }
    
    
    private func emailSignInCheck() {
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        authUI?.providers = [FUIEmailAuth()]
        authUI?.shouldHideCancelButton = true
        
        guard let loginVC  = authUI?.authViewController() else { return }
        
        loginVC.modalPresentationStyle = .fullScreen
        present(loginVC, animated: true)
    }
    


}

extension FirebaseUIViewController: FUIAuthDelegate {
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
    }
}
