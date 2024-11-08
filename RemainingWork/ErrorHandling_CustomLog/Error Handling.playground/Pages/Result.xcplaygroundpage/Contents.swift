//: [Previous](@previous)
import Foundation
/*:
 ---
 # Result
 - Swift 5.0 에서 추가
 ---
 */
// 에러 정의
enum NetworkError: Error {
  case badUrl
  case missingData
}

/*
 enum Result<Success, Failure> where Failure : Error {
   case success(Success)
   case failure(Failure)
 }
 */


// 이미지를 다운받는 request를 보낸다고 가정한 함수
func downloadImage(
  from urlString: String,
  completionHandler: (Result<String, NetworkError>) -> Void
)  {
  guard let url = URL(string: urlString) else {
    return completionHandler(.failure(.badUrl))
    // url 변환이 안되면 completionHandler의 매개변수는
    // Result의 failure case로 연관값은 NetworkError 타입으로 전달.
  }
  // 다운로드를 시도했다고 가정
  print("Download image from \(url)")
  
  
  let downloadedImage = "Dog"
//  let downloadedImage = "Missing Data"
  
  if downloadedImage == "Missing Data" {
    return completionHandler(.failure(.missingData))
    // Missing Data 이면 completionHandler의 매개변수는
    // Result의 failure case로 연관값은 NetworkError 타입으로 전달.
  } else {
    return completionHandler(.success(downloadedImage))
    // 데이터 유실이 없는 경우 completionHandler의 매개변수는
    // Result의 success case로 연관값은 String 타입으로 전달.
  }
}


/*:
 ### Result 활용 예시
 */
// 1) success, failure 결과 구분

let url = "https://loremflickr.com/320/240/dog"
//let url = "No Image Url"

downloadImage(from: url) { result in
  switch result {
  case .success(let data):
    print("\(data) image download complete")
  case .failure(let error):
    print(error.localizedDescription)
    
    // 에러를 구분해야 할 경우
//  case .failure(.badUrl): print("Bad URL")
//  case .failure(.missingData): print("Missing Data")
  }
}



// 2) get()을 통해 성공한 경우에만 데이터를 가져옴. 아니면 nil 반환

downloadImage(from: url) { result in
  if let data = try? result.get() {
    print("\(data) image download complete")
  }
}


// 3) Result를 직접 사용

let result = Result { try String(contentsOfFile: "ABC") }
print(try? result.get())




//: [Next](@next)
