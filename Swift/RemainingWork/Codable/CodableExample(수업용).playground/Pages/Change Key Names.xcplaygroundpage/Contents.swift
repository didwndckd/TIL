//: [Previous](@previous)
import Foundation

let jsonData = """
{
  "user_name": "James",
  "user_email": "abc@xyz.com",
  "gender": "male",
}
""".data(using: .utf8)!


struct User: Decodable {
  let name: String
  let email: String
  let gender: String
  
  private enum CodingKeys: String, CodingKey { // key가 다를 경우 사용 // 타입 이름 꼭 CodingKeys를 사용해야 함
    case name = "user_name"
    case email = "user_email"
    case gender
  }
    
}


let decoder = JSONDecoder()
let user = try decoder.decode(User.self, from: jsonData)
print(user)


//: [Table of Contents](Contents) | [Previous](@previous) | [Next](@next)
