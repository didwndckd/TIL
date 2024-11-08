//: [Previous](@previous)
/*:
 # Equatable, Identical
 */

// 동등 연산자
1 == 1
2 == 1
"ABC" == "ABC"


class Person {
  let name = "이순신"
  let age = 30
}

let person1 = Person()
let person2 = Person()

//person1 == "이순신"    //
//person1 == person2   //


/*:
 ---
 ### Question
 - 왜 비교 연산자를 사용할 수 없을까요?
 ---
 */

/*:
 ---
 ### Equatable Protocol
 ---
 */
//비교할때 쓰이는 프로토콜
class User: Equatable {
  var name = "이순신"
  let age = 30
  
  static func ==(lhs: User, rhs: User) -> Bool {
    return lhs.name == rhs.name
  }  // 비교하는 메서드를 그냥 만드는 느낌
}

let user1 = User()
var user2 = User()
user1 == user2


/*:
 ---
 ### Identical
 ---
 */

user1.name
user2.name
user1 == user2
//user2 = user1
user1 === user2 // 식별 연산자: === -> 주소값 비교(스택)


/*
 let x = 5 // 스텍
 let y = User() // 스텍 -> 주소 // 힙 -> 실제 값
 let z = User()
 
           x   y        z
 [ Stack ] | 5 | 0x5F17 | 0x2C90 |
                   |        |
                   ---------|----------
           ------------------         |
           |                          |
         0x2C90          0x5F16     0x5F17
 [ Heap ]  | z's user data | SomeData | y's user data |
 
 --- in Memory ---
 값 타입(Value Type) - Stack
 참조 타입(Reference Type) - Stack -> Heap
 */


user1.name = "홍길동"
user1.name   //
user2.name   //
user1 == user2
user1 === user2


user2 = user1

// user1 -> 0x00001  <- user2       0x00002

//user1.name
//user2.name
//user1 == user2    //
//user1 === user2   //
//
//user2.name = "세종대왕"
//user2.name
//user1.name


/*
 Identity Operators
 === : 두 상수 또는 변수가 동일한 인스턴스를 가르키는 경우 true 반환
 */

//스택에 저장되는 값들은 식별 연산자(===)를 사용할 수 없다 
//1 === 1
//"A" === "A"

// 5 == 5


//: [Next](@next)
