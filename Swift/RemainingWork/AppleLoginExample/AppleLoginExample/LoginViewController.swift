//
//  LoginViewController.swift
//  AppleLoginExample
//
//  Created by Giftbot on 2020/03/17.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit
import AuthenticationServices

class LoginViewController: UIViewController {
  
  @IBOutlet private weak var stackView: UIStackView!
  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupAppleIDButton()
  }
  
  private func setupAppleIDButton() {
    let appleIDButton = ASAuthorizationAppleIDButton(
        authorizationButtonType: .signIn,
        authorizationButtonStyle: .black)
    
    appleIDButton.cornerRadius = 6.0 // 기본값 6
    appleIDButton.addTarget(self, action: #selector(didTapAppleIDButton(_:)), for: .touchUpInside)
    
    stackView.addArrangedSubview(appleIDButton)
    stackView.arrangedSubviews.first?.isHidden = true
  }
  
  
  // MARK: Action
  
  @objc private func didTapAppleIDButton(_ sender: Any) {
    let idRequest = ASAuthorizationAppleIDProvider().createRequest()
    idRequest.requestedScopes = [.email, .fullName]
    
    let authorizationController = ASAuthorizationController(authorizationRequests: [idRequest])
    authorizationController.delegate = self
    
    authorizationController.presentationContextProvider = self
    
    authorizationController.performRequests()
  }
}


extension LoginViewController: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        guard let error = error as? ASAuthorizationError else { return }
        
        switch error.code {
        case .unknown:
            print("Unknown")
        case .canceled:
            print("Canceled")
        case .invalidResponse:
            print("InvalidResponse")
        case .notHandled:
            print("Not Handled")
        case .failed:
            print("Failed")
        @unknown default:
            print("Default")
        }
        
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let idCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
              let idTocken = idCredential.identityToken,
              let tockenString = String(data: idTocken, encoding: .utf8) else { return }
        
        let userID = idCredential.user
        let familyName = idCredential.fullName?.familyName ?? ""
        let givenName = idCredential.fullName?.givenName ?? ""
        let email = idCredential.email ?? ""
        
        // userID를 제외한 다른 정보들은 최초 로그인 할 때에만 받을 수 있고
        // 두번째 로그인 부터는 받을 수 없기 때문에 최초에 따로 저장을 해 놓아야 한다.
        // 두번째 로그인 부터는 ID만 받을 수 있음
        // 계속 같은 ID가 들어오고 사용자가 appleID 사용을 중지했다가 다시 사용해도 같은 ID가 들어온다.
        
        let user = User(id: userID, familyName: familyName, givenName: givenName, email: email)
        print(user)
        print(tockenString)
        
        if let encodedData = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encodedData, forKey: "AppleIDData")
        }
        
        switch idCredential.realUserStatus {
        case .likelyReal:
            print("아마도 실제 사용자일 가눙성이 높음")
        case .unknown:
            print("실제 사용자인지 봇인지 확실치 않음")
        case .unsupported:
            print("iOS가 아님 이건 iOS에서만 지원")
        }
        
        
        let vc = presentingViewController as! ViewController
        vc.user = user
        dismiss(animated: true, completion: nil)
        
    }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        self.view.window!
    }
}
