//
//  ViewController.swift
//  URLSessionExample
//
//  Created by giftbot on 2020. 2. 12..
//  Copyright © 2020년 giftbot. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
  
  @IBOutlet private weak var imageView: UIImageView!
  private let imageUrlStr = "https://loremflickr.com/860/640/cat"
  
  
  // MARK: - Sync method
  
  @IBAction private func syncMethod() {
    print("\n---------- [ syncMethod ] ----------\n")
    
    let url = URL(string: imageUrlStr)!
    
//    DispatchQueue.global().async {
//        if let data = try? Data(contentsOf: url) { // sync 메서드 이기때문에 끝날때 까지 다른작업을 할 수 없다. 그래서 global()로 비동기처리 해줘야함
//            DispatchQueue.main.async {
//                self.imageView.image = UIImage(data: data)
//            }
//
//        }
//    }
    
    URLSession.shared.dataTask(with: url) { (data, r, e ) in
        
        if let response = r {
            print(response)
        }
        
        if let data = data {
//            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? String else { return }
//            print(jsonObject)
            DispatchQueue.main.async {
                self.imageView.image = UIImage(data: data)
            }
        }
    }.resume()
    
  }
  
  
  // MARK: - URLComponents
  
  @IBAction private func urlComponentsExample(_ sender: Any) {
    print("\n---------- [ urlComponentsExample ] ----------\n")
    /*
     http://username:password@www.example.com:80/index.html?key1=value1&key2=value2#myFragment
     */
    // 위 URL 구성을 보고 URLComponents의 각 파트를 수정해 위 구성과 같도록 만들어보기
    
    var components = URLComponents()
    components.scheme = "http"
    components.user = "username"
    components.password = "password"
    components.host = "www.example.com"
    components.port = 80
    components.path = "/index.html"    // path는 /로 시작해야 함
    components.query = "key1=value1&key2=value2"
//    components.queryItems = [URLQueryItem(name: "key1", value: "value1"), URLQueryItem(name: "key2", value: "value2")]
    components.fragment = "myFragment" //눌렀을때 원하는 위치로 찾아가게 해주는
//    dump(components)
    
    print("-----------------------------------------------------------------------------------------")
    var comp = URLComponents(string: "http://username:password@www.example.com:80/index.html?key1=value1&key2=value2#myFragment")
    comp?.queryItems = [URLQueryItem(name: "key1", value: "value1"), URLQueryItem(name: "key2", value: "value2")]
//    print(comp)
    print(comp?.url?.absoluteString ?? " ")
    
  }
  
  
  
  // MARK: - URL Encoding Example
  
  @IBAction private func urlEncodingExample() {
    print("\n---------- [ urlEncodingExample ] ----------\n")
    let urlStringE = "https://search.naver.com/search.naver?query=swift"
    print(URL(string: urlStringE) ?? "nil") // url 잘 나옴
    
    let urlStringK = "https://search.naver.com/search.naver?query=한글"
    print(URL(string: urlStringK) ?? "nil") // nil ->
    
    let queryEncodedStr = urlStringK.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
    let convertedURL = URL(string: queryEncodedStr)
    print(convertedURL ?? "nil")
    
    
    //URL -> String
    let encodedUrlString = "http://example.com/#color-%23708090" // %23 -> #
    // %인코딩 제거
    print(encodedUrlString.removingPercentEncoding ?? "")
    
    //String -> URL
    let originalString = "color-#708090"
    var allowed = CharacterSet.urlFragmentAllowed
    allowed.insert("#")
    
    let encodedString = originalString.addingPercentEncoding(withAllowedCharacters: allowed)! // #708090
//    let encodedString = originalString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)! //%23708090
    print(encodedString)
    
    
  }
  
  
  
  // MARK: - Session Configuration
  
  @IBAction private func sessionConfig(_ sender: Any) {
    print("\n---------- [ Session Configuration ] ----------\n")
    
    _ = URLSessionConfiguration.default
    _ = URLSessionConfiguration.ephemeral
    _ = URLSessionConfiguration.background(withIdentifier: "com.didwndckd.example.backgroundConfig")
    
    let sessionConfig = URLSessionConfiguration.default
    sessionConfig.allowsCellularAccess = false // fasle -> Wi-Fi만 가능하도록
    // 기본값 true
    
    sessionConfig.httpMaximumConnectionsPerHost = 5 // host 몇개?
    // 기본값 4
    
    sessionConfig.timeoutIntervalForRequest = 20 //request 얼마나 기다릴 것인지
    // 기본값 1분
    
    sessionConfig.requestCachePolicy = .reloadIgnoringLocalCacheData
    // 기본값 = .useProtocolCachePolicy
    
    sessionConfig.waitsForConnectivity = true //연결이 잘 될때까지 기다리면서 시도하는 것
    //기본값 false
    
    let myCache = URLCache(memoryCapacity: 16_384, diskCapacity: 268_435_456, diskPath: nil)
    //기본캐시 URLCache.shared
    //메모리 - 16KB (16 * 1024 = 16_384)
    //디스크 - 256MB ()
    
    let cache = URLCache.shared
    sessionConfig.urlCache = cache
    
    print(cache.memoryCapacity) // 500KB
    print(cache.diskCapacity) // 약 9.5MB
    
    print(cache.currentMemoryUsage)  // 0
    print(cache.currentDiskUsage) // 현재 사용량
    
    // (user home directory)/Library/Caches/(application bundle id) // -> 저장 경로
    
    cache.removeAllCachedResponses()
    
    let mySession = URLSession(configuration: sessionConfig)
    let url = URL(string: imageUrlStr)!
    let task = mySession.dataTask(with: url) {
        [weak self] (data, response, error) in
        guard let data = data else { return }
        DispatchQueue.main.async {
            self?.imageView.image = UIImage(data: data)
            print("download completed")
        }
    }
    task.resume()
//    print(mySession.configuration.urlCache?.currentDiskUsage)
//    print(mySession.configuration.urlCache?.currentMemoryUsage)
    
    
  }
  

  // MARK: - Get, Post, Delete
  
  // https://jsonplaceholder.typicode.com/
  
  @IBAction func requestGet(_ sender: Any) {
    print("\n---------- [ Get Method ] ----------\n")
    let todoEndpoint = "https://jsonplaceholder.typicode.com/todos/1"
    guard let url = URL(string: todoEndpoint) else { return }
    
    let task = URLSession.shared.dataTask(with: url) {
        (data, response, error) in
        guard error == nil else { return print(error!.localizedDescription) }
        
        guard
            let response = response as? HTTPURLResponse,
            (200 ..< 300).contains(response.statusCode),
            response.mimeType == "application/json"
            else { return}
        
        print("--------------------Get------------------------")
        print(response)
        
        guard let data = data else { return print("No Data") }
        
        guard
            let todo = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
            let todoID = todo["id"] as? Int,
            let todoTitle = todo["title"] as? String
            else { return }
        print("ID: ", todoID)
        print("title: " , todoTitle)
    }
    
    task.resume()
    
  }
  
  
  @IBAction func requestPost(_ sender: Any) {
    print("\n---------- [ Post Method ] ----------\n")
    let todoEndpoint = "https://jsonplaceholder.typicode.com/todos"
    
    guard let todosURL = URL(string: todoEndpoint) else { return }
    
    let newToDo: [String: Any] = ["title": "My ToDo", "userID": "20"]
    guard let jsonTodo = try? JSONSerialization.data(withJSONObject: newToDo, options: []) else { return }
    
    var urlRequest = URLRequest(url: todosURL)
    urlRequest.httpMethod = "Post"
    urlRequest.httpBody = jsonTodo
    
    let task = URLSession.shared.dataTask(with: urlRequest) {
        (data, response, error) in
        
    guard
        let data = data,
        let response = response,
        let newItem = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        else { return }
        
        print("--------------------Post------------------------")
        print(response)
//        print(newItem)
        
        if let id = newItem["id"] as? Int {
            print(id)
        }
    }
    task.resume()
    
  }
  
  @IBAction func requestDelete(_ sender: Any) {
    print("\n---------- [ Delete Method ] ----------\n")
    let todoEndpoint = "https://jsonplaceholder.typicode.com/todos/1"
    
    guard let todosURL = URL(string: todoEndpoint) else { return }
    
    
    var urlRequest = URLRequest(url: todosURL)
    urlRequest.httpMethod = "DELETE"
    
    let task = URLSession.shared.dataTask(with: urlRequest) {
        (data, response, error) in
        
    guard
        let data = data, let response = response else { return print("No Data") }
        
        
        print("--------------------DELETE------------------------")
        print(response)
        print("DELETE OK")
        
        if let res = response as? HTTPURLResponse {
            print(res.statusCode)
        }
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            print(data) // 2 bytes
            print(jsonObject) // [:]
        }
        
    }
    task.resume()
    
    
  }
}

