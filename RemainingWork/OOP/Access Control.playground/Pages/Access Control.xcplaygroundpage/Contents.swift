//: [Previous](@previous)
/*:
 ---
 ## Access Levels
 * open
 * public
 * internal
 * fileprivate
 * private
 ---
 */
//: [공식 문서](https://docs.swift.org/swift-book/LanguageGuide/AccessControl.html)

/***************************************************
 Open / Public
 ***************************************************/

open class SomeOpenClass { //오픈 접근 제어자 : 모두 접근할 수 있고 상속받아서 사용이 가능하다
  open var name = "name"
  public var age = 20
}

public class SomePublicClass { // 퍼블릭 접근 제어자 : 모두 접근할 수 있다
  public var name = "name"
  /*open*/ var age = 20 //접근제어자를 정의한 클래스 내에서는 더 넓은 개념의 제어자를 접근할 수 없다
}

let someOpenClass = SomeOpenClass()
someOpenClass.name
someOpenClass.age

let somePublicClass = SomePublicClass()
somePublicClass.name
somePublicClass.age

//: ---
/***************************************************
 Internal
 ***************************************************/

class SomeInternalClass { // 스위프트의 디폴트 : 같은 모듈에서 접근 가능(프로젝트)
  internal var name = "name"
  internal var age = 0
}

//class SomeInternalClass {
//  var name = "name"
//  var age = 0
//}


let someInternalClass = SomeInternalClass()
someInternalClass.name
someInternalClass.age

//: ---
/***************************************************
 fileprivate
 ***************************************************/

class SomeFileprivateClass { // 해당 파일에서만 사용 가능
  fileprivate var name = "name"
  fileprivate var age = 0
}

let someFileprivateClass = SomeFileprivateClass()
someFileprivateClass.name
someFileprivateClass.age


//: ---

class SomePrivateClass { // 클래스 또는 함수 , 구조체 등의 내부에서만 접근이 가능하다
  private var name = "name"
  private var age = 0
  
  func someFunction() {
    print(name)
  }
}

let somePrivateClass = SomePrivateClass()
somePrivateClass.someFunction()
//somePrivateClass.name
//somePrivateClass.age



/***************************************************
 1. Command Line Tool 로 체크
 2. UIViewController, Int 등 애플 프레임워크의 접근 제한자 확인
 ***************************************************/


/*:
 ---
 ## Nested Types
 * Private  ->  Fileprivate
 * Fileprivate  ->  Fileprivate
 * Internal  ->  Internal
 * Public  ->  Internal
 * Open  ->  Internal
 ---
 */
//class 의 접근제어자를 설정하면 내부 프로퍼티의 접근제어는 위의 Nested Types와 같다

// 예시
open class AClass {
  // 별도로 명시해주지 않으면 someProperty 는 Internal 레벨
  var someProperty: Int = 0
}


//: [Next](@next)
