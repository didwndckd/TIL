//: [Previous](@previous)
/*:
 # Type Casting
 ---
 - as  : 타입 변환이 확실하게 가능한 경우(업캐스팅, 자기 자신 등) 에만 사용 가능. 그 외에는 컴파일 에러
 - as? : 강제 타입 변환 시도. 변환이 성공하면 Optional 값을 가지며, 실패 시에는 nil 반환
 - as! : 강제 타입 변환 시도. 성공 시 언래핑 된 값을 가지며, 실패 시 런타임 에러 발생
 ---
 */

import UIKit

class Shape {
  var color = UIColor.black
  
  func draw() {
    print("draw shape")
  }
}

class Rectangle: Shape {
  var cornerRadius = 0.0
  override var color: UIColor {
    get { return .white }
    set { }
  }
  
  override func draw() {
    print("draw rect")
  }
}

class Triangle: Shape {
  override func draw() {
    print("draw triangle")
  }
}

/*
 Shape
  - Rectangle
  - Triangle
  - Circle
 모두 draw() 오버라이드
 */



/*:
 ---
 ## Upcasting
 ---
 */
print("\n---------- [ Upcasting ] ----------\n")

/*
 업 캐스팅
 - 상속 관계에 있는 자식 클래스가 부모 클래스로 형 변환하는 것
 - 업캐스팅은 항상 성공하며 as 키워드를 사용
 (자기 자신에 대한 타입 캐스팅도 항상 성공하므로 as 키워드 사용)
*/


let rect = Rectangle()
rect.color
rect.cornerRadius

//(rect as Shape).color         // white -> 변환은 성공 했지만 실제로 사용하는 값은 자기자신의 값(오버라이드 했기 때문)
//(rect as Shape).cornerRadius  // 에러 -> 부모로 형변환을 했기때문에 Shape는 cornerRadius 프로퍼티가 없다
//(rect as Rectangle).color     // 자기자신
//(rect as Rectangle).cornerRadius // 자기자신



let upcastedRect: Shape = Rectangle()
type(of: upcastedRect)   //

upcastedRect.color        // white -> 인스턴스가 가지고 있는 값
//upcastedRect.cornerRadius // 에러 -> 접근이 안됨

(upcastedRect as Shape).color        // white Shape로 형변환을 해주었지만 가지고있는값은 인스턴스의 값
//(upcastedRect as Rectangle).color   // 오류 -> 부모클래스를 자식 클래스로 형 변환을 할때 as 불가
// 부모클래스 -> 자식클래스
// 자식클래스는 부모 클래스가 무조건 하나이기 때문에 자식클래스는 부모클래스가 정해져 있기때문에 접근 가능
// 부모클래스는 여러개의 자식 클래스를 가지고 있기 때문에 누구인지 알 수 없다.

/*:
 ---
 ## Downcasting
 ---
 */
print("\n---------- [ Downcasting ] ----------\n")

/*
 다운 캐스팅
 - 형제 클래스나 다른 서브 클래스 등 수퍼 클래스에서 파생된 각종 서브 클래스로의 타입 변환 의미
 - 반드시 성공한다는 보장이 없으므로 옵셔널. as? 또는 as! 를 사용
 */


let shapeRect: Shape = Rectangle()
var downcastedRect = Rectangle()

//downcastedRect = shapeRect // 에러 -> 자식타입에 부모타입을 넣을수 없다
//downcastedRect = shapeRect as Rectangle  // 에러 -> 동일한 이유
// 부모 -> 자식 (X)

//downcastedRect: Rectangle = shapeRect as? Rectangle
//에러 -> as?는 옵셔널 이기 때문에 현재 Rectangle 객체는 옵셔널 타입이 아니기 때문에
//
downcastedRect = shapeRect as! Rectangle  //강제로 변환 시도 그러나 타입이 다르면 런타임 에러 발생

//as? : 강제 타입 변환 시도. 변환이 성공하면 Optional 값을 가지며, 실패 시에는 nil 반환
//as! : 강제 타입 변환 시도. 성공 시 언래핑 된 값을 가지며, 실패 시 런타임 에러 발생



//Q. 아래 value 에 대한 Casting 결과는?
let value = 1
//(value as Float) is Float   //에러 -> as에서 발생하는 에러임 Int 는 Float와 관계없는 타입이다
(value as? Float) is Float// false -> value as? Float의 결과가 nil 이기 때문에 false
print( value as? Int)
//(value as! Float) is Float  // 런타임 에러 -> 강제로 형변환을 시도 했지만 실패해서 런타임 에러


/*:
 ---
 ## Type Check Operator
 ---
 */
let shape = Shape()
let rectangle = Rectangle()
let triangle = Triangle()

let list = [shape, rectangle, triangle]
type(of: list) // Array<Shape> 타입
/*:
 ---
 ### Question
 - 아래 for 문에 대한 실행 결과는?
 ---
 */
for elem in list {
  if elem is Shape {
    print("shape instance")
  } else if elem is Rectangle {
    print("rect instance")
  } else if elem is Triangle {
    print("triangle instance")
  }
}
// 세번다 "shape instance" 출력
// 최상위 부모 클래스가 Shape 이기 때문에 첫번째 조건에서 모두 true
for elem in list {
   if elem is Rectangle {
    print("rect instance")
  } else if elem is Triangle {
    print("triangle instance")
   }else{
    print("shape instance")
    }
}
//차례로 잘 나옴



print("\n---------- [ ] ----------\n")

// let list: [Shape] = [shape, rectangle, triangle]
for element in list  {
  element.draw()
}
// 각각 다른 결과 출력
// 오버라이드 되었기 때문에 각각의 인스턴스는 다른 결과를 출력함

//: [Next](@next)
