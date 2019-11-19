//: [Previous](@previous)
//: - - -
//: # Abstraction
//: - - -

protocol Human { // 프로토콜로 추상화를 한다
  var name: String { get }  // 읽기가 가능해야함
  var age: Int { get }
  var gender: String { get }
  var height: Double { get }
  
  func sleep()
  func eat()
  func walk()
}

//class User: Human {
//}



protocol Jumpable {
  var canJump: Bool { get set } // 읽기 쓰기가 가능해야함
  var jumpHeight: Double { get } // 쓰기가 가능해도되고 안해도 되지만 읽기는 무조건 가능해야 함
}

class Cat: Jumpable {
//  let canJump = true  // get  읽기, 쓰기가 모두 가능해야 하기 때문에 let을 사용할 수 없다
  var canJump = true  // get set
  
  private var _jumpHeight = 30.0
  var jumpHeight: Double {
    get { _jumpHeight }
//    set { _jumpHeight = newValue } // 프로토콜이 get 이기 때문에 get은 무조건 해줘야 하지만 set은 해도되고 안해도된다
  }
}

let cat = Cat()
if cat.canJump {
  print(cat.jumpHeight)
}


/*:
 ---
 ### Question
 추상화 적용해보기 (Protocol 로 표현)
 - 사람(Human)을 표현하는 속성과 동작 정의
 - 레스토랑을 운영하는 오너(Owner)의 속성과 동작 정의
 - 요리사(Chef)의 속성과 동작 정의
 - 손님(Customer)의 속성과 동작 정의
 ---
 */
enum Gender {
    case male , female
}

protocol People {
    
    var name : String {get set}
    var job : String {get set}
    var gender : Gender {get}
    var nationalyti : String {get}
    
    func selfIntroduce ()
}

protocol Owner {
    
    var currentMoney : Int {get set}
    var howManySlave : Int {get set}
    var name : String {get set}
    
    func gabJil ()
    
}





/*:
 ---
 ### Answer
 ---
 */

// 사람을 표현하는 속성과 동작 정의
protocol Human1 {
  var name: String { get }
  var age: Int { get }
  var gender: String { get }
  var height: Double { get }
  
  func sleep()
  func eat()
  func walk()
}

// 레스토랑을 운영하는 오너의 속성과 동작 정의
protocol Owner1 {
  var name: String { get }
  
  func promote()
  func hire()
  func fire()
}


// 요리사의 속성과 동작 정의
protocol Chef1 {
  var position: String { get }
  
  func cook()
  func decorate()
  func buyFoodIngredients()
}

// 손님의 속성과 동작 정의
protocol Customer1 {
  var money: Int { get }
  
  func order()
  func eat()
  func rateRestaurant()
}


//: [Next](@next)
