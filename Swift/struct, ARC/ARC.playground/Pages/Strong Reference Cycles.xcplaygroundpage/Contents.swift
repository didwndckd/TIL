//: [Previous](@previous)
/*:
 ---
 # Strong Reference Cycles
 ---
 */

class Person {
  var pet: Dog?
  func doSomething() {}
  deinit {
    print("Person is being deinitialized")
  }
}

class Dog {
  var owner: Person?
  func doSomething() {}
  deinit {
    print("Dog is being deinitialized")
  }
}



var giftbot: Person! = Person()
var tory: Dog! = Dog()

giftbot.pet = tory
tory.owner = giftbot

giftbot.doSomething()
tory.doSomething()


/*:
 ---
 ### Question
 - 두 객체를 메모리에서 할당 해제하려면 어떻게 해야 할까요?
 ---
 */
//giftbot = nil
//tory = nil
// 강한순환 참조가 발생 두 객체가 모두 count를 2 가지고있기 때문에
//기존 변수에 nil 을 넣어도 heap에서 count를 1씩 가지고 있기 때문에
//heap에서는 그대로 가지고 있다




/*:
 ---
 ### Answer
 ---
 */
// 순서 주의

giftbot.pet = nil
tory.owner = nil

giftbot = nil
tory = nil




//: [Next](@next)
