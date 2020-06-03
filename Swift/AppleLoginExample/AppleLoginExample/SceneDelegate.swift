//
//  SceneDelegate.swift
//  AppleLoginExample
//
//  Created by Giftbot on 2020/03/17.
//  Copyright © 2020 Giftbot. All rights reserved.
//

import UIKit
import AuthenticationServices

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?


  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let _ = (scene as? UIWindowScene) else { return }
    

    appelIDCredentialState()
    
      
    }
    
    
    func appelIDCredentialState() {
        guard let data = UserDefaults.standard.data(forKey: "AppleIDData"),
            let decodedData = try? JSONDecoder().decode(User.self, from: data)
            else { return }
        

        let user = decodedData
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
          appleIDProvider.getCredentialState(forUserID: user.id, completion: {
              credentialState, error in
              switch credentialState {
              case .authorized:
                  print("authorized") // 이미 인증되어 있는 경우
              case .revoked:
                  print("revoked") // 사용 중단
              case .notFound:
                  print("notFound") // 가입 이름이 없는 경우
              default:
                  print("degault")
              }
          })
    }
    
    
    
    
}
