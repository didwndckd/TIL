//: [Previous](@previous)
import Foundation
/*:
 # Capture Example
 */

final class Person: CustomStringConvertible {
  let name: String
  init(name: String) {
    self.name = name
    print("\(self) has entered a chat room")
  }
  var description: String { "\(name)" }
  deinit { print("\(self) has exited!\n") }
}



func withoutBinding() {
  print("\n---------- [ Without Binding ] ----------\n")
  var person = Person(name: "James")
  
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    print("- After 2 seconds -")
    print("\(person) is still in a chat room")
  }
  
  person = Person(name: "Doppelganger")
} // 캡쳐를 하지 않았기 때문에 person이 바뀌면 바깥에 있는 person을 사용하기 때문에 같은 객체가 나온다

//withoutBinding()


func captureBinding() {
  print("\n---------- [ Binding ] ----------\n")
  var person = Person(name: "James")
  
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    [doppelganger = person] in
    print("- After 2 seconds -")
    print("\(doppelganger) is still in a chat room")
  }
  person = Person(name: "Doppelganger")
}// 캡쳐를 하게되면 doppelganger변수에 person객체를 담아놓고있기 때문에 바깥의 person객체를 바꿔도 내부에서는 doppelganger가 기존 객체를 참조하고 있기 때문에 바뀌기 전 객체가 나온다.

//captureBinding()


func equivalentToBinding() {
  print("\n---------- [ Equivalent to Binding ] ----------\n")
  var person = Person(name: "James")
  
  let doppelganger = person
  DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    print("- After 2 seconds -")
    print("\(doppelganger) is still in a chat room")
  }
  person = Person(name: "Doppelganger")
}// doppelganger에 person을 넣고 person에 새로운 Person객체를 넣어서 바꿔치기

equivalentToBinding()



func makeIncrementer(forIncrement amount: Int) -> () -> Int {
  print("\n---------- [ makeIncrementer ] ----------\n")
  var runningTotal = 0
  
  // 함수 형태. 중첩 함수는 클로저의 한 종류
  func incrementer() -> Int {
    runningTotal += amount
    return runningTotal
  }
  
  // 클로저 형태
//  let incrementer: () -> Int = {
//    runningTotal += amount
//    return runningTotal
//  }
  return incrementer
}


let incrementer = makeIncrementer(forIncrement: 7)
incrementer()
incrementer()
incrementer()


//: [Next](@next)
