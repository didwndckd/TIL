//: [Previous](@previous)
/*
 싱글톤 방식으로 해보기 전에
 아래에 주어진 코드를 이용해 User에 친구 추가하기
 */

class User {
  var friends: [Friends] = []
  var blocks: [Friends] = []
}

struct Friends: Equatable {
  let name: String
}

/*
 ↑ User와 Friends 타입은 수정 금지
 ↓ FriendList 타입은 수정 허용
 */

class FriendList {
    func addFriend(name: String, user: User) {
    // 호출 시 해당 이름의 친구를 friends 배열에 추가
       let friend = Friends(name: name)
        user.friends.append(friend)
  }
  
    func blockFriend(name: String, user: User) {
    // 호출 시 해당 이름의 친구를 blocks 배열에 추가
    // 만약 friends 배열에 포함된 친구라면 friends 배열에서 제거
        let friend = Friends(name: name)
        user.blocks.append(friend)
        
        for i in 0..<user.friends.count {
            if user.friends[i].name == name {
                user.friends.remove(at: i)
            }
        }
  }
    
}


//

let user = User()

var friendList = FriendList()
friendList.addFriend(name: "원빈" , user: user)
friendList.addFriend(name: "장동건" , user: user)
friendList.addFriend(name: "정우성" , user: user)
user.friends   // 원빈, 장동건, 정우성

friendList.blockFriend(name: "정우성" , user: user)
user.friends   // 원빈, 장동건
user.blocks    // 정우성
let friend = Friends(name: "양중창")
let firend2 = Friends(name: "aa")
friend == firend2
//: [Next](@next)
