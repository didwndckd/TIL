//
//  ServiceManager.swift
//  AlamofirePractice
//
//  Created by 양중창 on 2020/02/21.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import Alamofire



final class ServiceManager {
    static let shared = ServiceManager()
    
    private let baseURL = "https://go.aws/2PcKamh"
    private let reachability = NetworkReachabilityManager(host: "google.com")
    
    private init() {
        reachability?.startListening(onUpdatePerforming: {
            (status) in
            switch status {
            case .notReachable:
                print("notReachable")
            case .reachable(.cellular):
                print("celular")
            case .reachable(.ethernetOrWiFi):
                print("ethernetOrWiFi")
            case .unknown:
                print("unknown")
            }
        })
    }
    
    
    func requestUser(completionHandler: @escaping (Result<[User], Error>) -> Void) {
        
        AF.request(baseURL)
        .validate()
            .responseDecodable(completionHandler: { (response: DataResponse<[User], AFError>) in
                switch response.result {
                case .failure(let error):
                    completionHandler(.failure(error))
                case .success(let users):
                    completionHandler(.success(users))
                }
            })
        
        
        
    }
    
    
    func requestImage(_ url: String, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        AF.request(url)
            .validate()
            .responseData(completionHandler: {
            (response) in
            switch response.result {
            case .success(let data):
                completionHandler(.success(data))
            case .failure(let error):
                completionHandler(.failure(error))
            }
        })
    }
    
    
    
    
    
}
