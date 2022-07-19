//: [Previous](@previous)
/*:
 # Class
 */
/*
 Value Type => struct, enum  (Stack 에 저장)
 Reference Type => class  (Heap 에 저장)
 */
// code , data, stack, heap

/*
 let x = 5  // stack -> 해당값이 그대로 저장
 let y = User()  //  -> stack에 값이 들어있는 힙의 주소 위치를 포인터로 저장 // heap에 실제 데이터 저장
 let z = User()  //  -> User의 데이터 사이즈에 따라 저장되는 크기도 다르다
 
         x   y        z
 [Stack] | 5 | 0x5F17 | 0x2C90 |
 
        0x2C90          0x5F16     0x5F17
 [Heap] | z's user data | SomeData | y's user data |
 
 --- in Memory ---
 값 타입(Value Type) - Stack
 참조 타입(Reference Type) - Stack -> Heap
 */


/*
 class <#ClassName#>: <#SuperClassName#>, <#ProtocolName...#> {
   <#PropertyList#>
   <#MethodList#>
 }
 
 let <#objectName#> = <#ClassName()#>
 objectName.<#propertyName#>
 objectName.<#functionName()#>
 */


class Dog {
  var color = "White"
  var eyeColor = "Black"
  var height = 30.0
  var weight = 6.0
  
  func sit() {
    print("sit")
  }
  func layDown() {
    print("layDown")
  }
  func shake() {
    print("shake")

  }
}


let bobby: Dog = Dog()
bobby.color  // "White"
bobby.color = "Gray"
bobby.color // "Gray"
bobby.sit() // "sit"

let tory = Dog()
tory.color = "Brown"
tory.layDown() //"layDown"


/*:
 ---
 ### Question
 - 자동차 클래스 정의 및 객체 생성하기
 ---
 */
/*
 자동차 클래스
 - 속성: 차종(model), 연식(model year), 색상(color) 등
 - 기능: 운전하기(drive), 후진하기(reverse) 등
 */

class Car2 {
    var model : String = "코나"
    var modelYear : Int = 2018
    var color : String = "흰색"
    
    func drive () {
        print("운전하기")
    }
    func reverse () {
        print("후진")
    }
}


let kona : Car2 = Car2()
kona.model
kona.color
kona.color = "검정색"
kona.color
kona.modelYear
kona.reverse()
kona.drive()



/*:
 ---
 ### Answer
 ---
 */
class Car {
  let model = "Palisade"
  let modelYear = 2019
  let color = "Cream White"
  
  func drive() {
    print("전진")
  }
  func reverse() {
    print("후진")
  }
}

let car = Car()
car.drive()
car.reverse()



//: [Next](@next)
