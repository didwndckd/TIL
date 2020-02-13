//: [Previous](@previous)
import Foundation
/*:
 ---
 # Escaping
 - 함수나 메서드의 파라미터 중 클로져 타입에 @escaping 키워드 적용
 - 해당 파라미터가 함수 종료(return) 이후 시점에도 어딘가에 남아 실행될 수 있음을 나타냄
   - outlives the lifetime of the function
 - 해당 파라미터가 함수 외부에 저장(stored)되거나 async(비동기)로 동작할 때 사용
 - self 키워드 명시 필요
 ---
 */

class Callee {
  deinit { print("Callee has deinitialized") }
  
  func noEscapingFunc(closure: () -> Void) {
    closure()
  }
  func escapingFunc(closure: @escaping () -> Void) { closure() }
}


class Caller {
  deinit { print("Caller has deinitialized") }
  let callee = Callee()
  var name = "James"
  
  func selfKeyword() {
    // self keyword (X)
    callee.noEscapingFunc { name = "Giftbot" }
    
    // self keyword  (O)
    callee.escapingFunc { self.name = "Giftbot" }
  }
  
  
  
  func asyncTask() {
    callee.noEscapingFunc {
      DispatchQueue.main.async {
        self.name = "Giftbot"
      }
    }
    callee.escapingFunc {
      DispatchQueue.main.async {
        self.name = "Giftbot"
      }
    }
  }
  
  
  func captureAsStrong() {
    callee.escapingFunc {
      print("-- delay 2seconds --")
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        self.name = "Giftbot"
        print(self.name)
      }
    }
  }
  
  func weakBinding() {
    callee.escapingFunc { [weak self] in
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        print("-- after 2seconds with weak self --")
        self?.name = "Giftbot"
        print(self?.name ?? "nil")
      }
    }

    
//    callee.escapingFunc { [weak self] in // 내부 변수에 담아 놓으면 바깥의 self가 소멸 되더라도 이 함수가 종료되기전 까지는 내부의 self 변수에 담겨있기때문에 사용이 가능하다
//      guard let `self` = self else { return print("Caller no exist") }
//      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//        print("-- after 2seconds with weak self --")
//        self.name = "Giftbot"
//      }
//    }
  }
  
  func unownedBinding() {
    callee.escapingFunc { [unowned self] in
//    let `self` = self
      DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
        print("-- after 2seconds with unowned self --")
        print("Oops!!")
        
        self.name = "Giftbot" // self에 접근하는순간 앱이 죽는다 -> self가 죽더라도 self에 대한 포인터 주소를 가지고 있지만 실제 그 주소에는 데이터가 없기 때문에 접근하는 순간 앱이 죽는다
        print(self.name)
      }
    }
  }
}


var caller: Caller? = Caller()
caller?.selfKeyword()
//caller?.asyncTask()
caller?.captureAsStrong()
//caller?.weakBinding()
//caller?.unownedBinding()

print("caller = nil")
caller = nil




//: [Next](@next)
