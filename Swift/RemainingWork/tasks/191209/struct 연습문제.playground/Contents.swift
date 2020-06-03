import UIKit

struct User {
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

struct FriendList {
    func addFriend(name: String, user: User) -> User {
    // 호출 시 해당 이름의 친구를 friends 배열에 추가
        var userDefault = user
        let friend = Friends(name: name)
        
        if user.friends.firstIndex(of: friend) == nil {
            userDefault.friends.append(friend)
            return userDefault
        }else {
            return userDefault
        }
  }
  
    func blockFriend(name: String, user: User) -> User {
    // 호출 시 해당 이름의 친구를 blocks 배열에 추가
    // 만약 friends 배열에 포함된 친구라면 friends 배열에서 제거
        var userDefault = user
        let friend = Friends(name: name)
        
        if userDefault.blocks.firstIndex(of: friend) == nil {
            if let index = userDefault.friends.firstIndex(of: friend) {
                userDefault.friends.remove(at: index)
                userDefault.blocks.append(friend)
                return userDefault
            }
        }
    
    return user
  }
}


//

var user = User()

var friendList = FriendList()
user = friendList.addFriend(name: "원빈", user: user)
user = friendList.addFriend(name: "장동건", user: user)
user = friendList.addFriend(name: "정우성", user: user)
user.friends   // 원빈, 장동건, 정우성

user = friendList.blockFriend(name: "정우성", user: user)
user.friends   // 원빈, 장동건
user.blocks    // 정우성


