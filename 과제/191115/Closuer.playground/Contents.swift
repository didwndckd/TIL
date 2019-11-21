import UIKit

var str = "Hello, playground"


//[ 과제 ]
//1. 객체 지향 프로그래밍 (Object-Oriented Programming) 에 대해 예습하기
//[ 도전 과제 ]
//1. 아래 두 클로저를 Syntax Optimization을 이용하여 최대한 줄여보기
var someClosure: (String, String) -> Bool = { (s1: String, s2: String) -> Bool in
  let isAscending: Bool
  if s1 > s2 {
    isAscending = true
  } else {
    isAscending = false
  }
  return isAscending
}

someClosure = {$0 > $1}

someClosure("c", "b")

//파라미터로 들어간 배열의 길이

func otherFunction (arr: [Int] , closer: ([Int]) -> Int) -> Int{
    closer(arr)
}

func a() {
    
}

func b() {
    
}

let x = 100

x % 2 == 0 ? print("A") : print("B")

let otherClosure: ([Int]) -> Int = { (values: [Int]) -> Int in
  var count: Int = 0
  for _ in values {
    count += 1
  }
  return count
}

print(otherFunction(arr : [1,2,3,4,5]) { $0.count })






