//: [Previous](@previous)
import Foundation
//: # MemoryLeak

print("\n---------- [ Lazy var closure ] ----------\n")
// Dog instance = has brack property
//     ⬆️              ⬇️
// bark property has Dog instance

final class Dog {
  let name: String = "토리"
  
  lazy var bark: () -> () = { //[unowned self] in // 약한참조를 사용해서 메모리 릭을 막아준다.
    print(self.name + "가 짖습니다.", terminator: " ")
  }
  deinit { print("이 문장 보이면 아님 ->", terminator: " ") }
}

var dog: Dog? = Dog()
dog?.bark()
dog = nil
print("메모리 릭!\n")



print("\n---------- [ weak capture ] ----------\n")

// Caller instance = has Callee instance
//     ⬆️              ⬇️
// Callee property has Caller instance

final class Callee {
  deinit { print("🔫🔫 응. 아니야.") }
  var storedProperty: (() -> ())?
  
  func noEscapingFunc(closure: () -> Void) {
//    self.storedProperty = closure    // Compile Error
  }
  func escapingFunc(closure: @escaping () -> Void) {
    self.storedProperty = closure
  }
}


final class Caller {
  let callee = Callee()
  var name = "James"
    
    deinit {
        print("Caller deinitialized")
    }
  
  func memoryLeak() {
    // 1)
    callee.escapingFunc {
      self.name = "Giftbot"
    }
    
    // 2)
//    callee.escapingFunc { [weak self] in
//      self?.name = "Giftbot"
//    }
  }
  
  func anotherLeak() {
    // 1)
//    callee.escapingFunc {
//      DispatchQueue.main.async { }
//    }
    
    // 2)
//    callee.escapingFunc {
//      DispatchQueue.main.async { [weak self] in
//        self?.name = "Giftbot"
//      }
//    }

    // 3)
    callee.escapingFunc { [weak self] in
      DispatchQueue.main.async {
        self?.name = "Giftbot"
      }
    }
  }
}

print("버그??? 🐛🐛🐛", terminator: "  ")

var caller: Caller? = Caller()
caller?.memoryLeak()
//caller?.anotherLeak()


DispatchQueue.main.asyncAfter(deadline: .now() + 1.1) {
  caller = nil
}



//: [Next](@next)
