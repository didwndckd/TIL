//: [Previous](@previous)
import Foundation


/*
 [ 실습1 ]
 다음 주소를 통해 얻은 json 데이터(국제정거장 위치 정보)를 파싱하여 출력하기
 http://api.open-notify.org/iss-now.json
 */

func practice1() {
  
    let urlString = "http://api.open-notify.org/iss-now.json"
    guard let url = URL(string: urlString) else { return }
    
    let session = URLSession.shared
    let task = session.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print(error.localizedDescription)
            return
        }else {
            guard let data = data else { return }
            
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { return }
//            print(jsonObject)
            guard
                let timeStamp = jsonObject["timestamp"] as? Int,
                let issPosition = jsonObject["iss_position"] as? [String: String],
                let message = jsonObject["message"] as? String
            else { return }
            
            guard let latitude = issPosition["latitude"], let longitude = issPosition["longitude"] else { return }
            print("--------------------station-------------------------------")
            print("timeStamp:", timeStamp)
            print("latitude:", latitude, "longitude:", longitude)
            print("message:", message)
            
        }
    }
    task.resume()
    
}
practice1()


/*
 [ 실습2 ]
 User 구조체 타입을 선언하고
 다음 Json 형식의 문자열을 User 타입으로 바꾸어 출력하기
 
 e.g.
 User(id: 1, firstName: "Robert", lastName: "Schwartz", email: "rob23@gmail.com")
 User(id: 2, firstName: "Lucy", lastName: "Ballmer", email: "lucyb56@gmail.com")
 User(id: 3, firstName: "Anna", lastName: "Smith", email: "annasmith23@gmail.com")
 */

let jsonString2 = """
{
"users": [
{
"id": 1,
"first_name": "Robert",
"last_name": "Schwartz",
"email": "rob23@gmail.com"
},
{
"id": 2,
"first_name": "Lucy",
"last_name": "Ballmer",
"email": "lucyb56@gmail.com"
},
{
"id": 3,
"first_name": "Anna",
"last_name": "Smith",
"email": "annasmith23@gmail.com"
},
]
}
"""

struct User {
    let id: Int
    let firstName: String
    let lastName: String
    let email: String
}

func practice2() {
    var userList: [User] = []
    
    guard let data = jsonString2.data(using: .utf8) else { return }
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: [[String: Any]]]
        else { return }
    
    guard let users = jsonObject["users"] else { return }
    for user in users {
        guard
            let id = user["id"] as? Int,
            let firstName = user["first_name"] as? String,
            let lastName = user["last_name"] as? String,
            let email = user["email"] as? String
            else { return }
        userList.append(User(id: id, firstName: firstName, lastName: lastName, email: email))
    }
    for user in userList {
        print("-------------------user------------------------")
        print("id:", user.id)
        print("firstName:", user.firstName)
        print("lastName:", user.lastName)
        print("email:", user.email)
        
    }
  
}
practice2()



/*
 [ 실습3 ]
 Post 구조체 타입을 선언하고
 다음 주소를 통해 얻은 JSON 데이터를 파싱하여 Post 타입으로 변환한 후 전체 개수 출력하기
 https://jsonplaceholder.typicode.com/posts
 */

struct Post {
  let userId: Int
  let id: Int
  let title: String
  let body: String
}

func practice3() {
    
    let urlString = "https://jsonplaceholder.typicode.com/posts"
    guard let url = URL(string: urlString) else { return }
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        guard error == nil else { return print(error!.localizedDescription) }
        guard let data = data else { return }
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]]
            else { return }
        
        print("--------------------------Posts Count-------------------------------")
        
        let posts: [Post] = jsonObject.compactMap({
            guard
            let userId = $0["userId"] as? Int,
            let id = $0["id"] as? Int,
            let title = $0["title"] as? String,
            let body = $0["body"] as? String
            else { return nil }
        return Post(userId: userId, id: id, title: title, body: body)
        })
        
        print(posts.count)
    }
    task.resume()
    
}

practice3()




//: [Table of Contents](Contents) | [Previous](@previous) | [Next](@next)


