//
//  ServiceManager.swift
//  ItunesPlayer
//
//  Created by 양중창 on 2020/02/28.
//  Copyright © 2020 didwndckd. All rights reserved.
//

import Foundation
import Alamofire

class ServiceManager {
    
    private var songRequest: DataRequest? = nil {
        didSet { oldValue?.cancel() }
    }
    var artWorkRequest: [Int: URLSessionTask] = [:]
    
    
    func request(query: String, complitionHandler: @escaping (Result<Medias, Error>) -> Void) {
        
        let urlString = SearchURL()
            .addQuery(key: .term, value: query)
            .addQuery(key: .country, value: "US")
            .addQuery(key: .media, value: "music")
            .addQuery(key: .entity, value: "song")
//            .addQuery(key: .lang, value: "en_US")
            .resolvedURL()
        
        songRequest = AF.request(urlString)
            
        songRequest?.validate()
        .responseDecodable(completionHandler: { (response: DataResponse<Medias, AFError>) in
            switch response.result {
            case .success(let medias):
                complitionHandler(.success(medias))
            case .failure(let error):
                complitionHandler(.failure(error))
            }
        })
        
        
    }
    
    func fetchArtWorl(
        url: String,
        completionHandler: @escaping (Result<Data, Error>) -> Void )
        -> URLSessionTask? {
            let request = AF.request(url)
            
            request
                .validate(contentType: ["image/jpeg"])
                .responseData(completionHandler: {
                guard let data = try? $0.result.get() else { return }
                completionHandler(.success(data))
            })
            
            return request.task
    }
    
}

extension ServiceManager {
  final class SearchURL {
    enum Key: String {
      case term, country, media, entity, lang
    }
    private let baseURL: String = "https://itunes.apple.com/search?"
    private var query: String = ""
    func addQuery(key: Key, value: String) -> Self {
      query += "\(key.rawValue)=\(value)&"
      return self
    }
    func resolvedURL() -> String {
      let url = baseURL + query
      query = ""
      return String(url.dropLast())
    }
  }
}
