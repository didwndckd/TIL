//: [Previous](@previous)
/*:
 # Control Transfer Statement
 - 특정 코드에서 다른 코드로 제어를 이전하여 코드 실행 순서를 변경하는 것
 - Swift 에는 5가지 키워드 사용
   - continue
   - break
   - fallthrough
   - return
   - throw
 */
/*
 continue - 현재 반복문의 작업을 중단하고 다음 반복 아이템에 대한 작업 수행
 break - break가 포함된 해당 제어문의 흐름을 즉각 중단 (반복문, switch 문)
 fallthrough - switch 문에서 매칭된 case 의 실행이 종료된 후 그 다음의 case 까지 실행
 return - 함수를 즉시 종료하고, return type에 해당하는 자료를 반환
 */


print("---------- [ continue ] ----------\n")

for num in 0...15 {
  if num % 2 == 0 {
    continue
    
  }
  print(num)
}

// 결과값은?



print("\n---------- [ return ] ----------\n")

func isEven(num: Int) -> Bool {
  if num % 2 == 0 {
    return true
  }
  return false
}

isEven(num: 1)
isEven(num: 2)



func returnFunction() -> Int {
  var sum = 0
  
  for _ in 1...100 {
    sum += 20
    return sum
//    return 5
  }
  return 7
}

print(returnFunction())

// 결과값은?



for i in 1...100 {
  print(i)
  break
}

// 결과값은?

//for i in 1...100 {
//  print(i)
//  return
//}

// 결과값은?


print("\n---------- [ break 1 ] ----------\n")

for num in 0...8 {
  if num % 2 == 0 {
    break
  }
  print(num)
}

// 결과값은?


print("\n---------- [ break 2 ] ----------\n")

for i in 0...3 {
  for j in 0...3 {
    if i > 1 {
      break
    }
    print("  inner \(j)")
  }
  print("outer \(i)")
}

// 결과는? 각각의 실행 횟수와 순서를 생각해보세요.
// inner 0123
//outer 0
// inner 0123
//outer 1
// outer 2
// outer 3



/*:
 ---
 ## Labeled Statements
 ---
 */
print("\n---------- [ labeled ] ----------\n")

OUTER: for i in 0 ... 3 { // for 문에 이름을 지정 해 줄 수 있다
  INNER: for j in 0...3 {
    if i > 1 {
//      print("j :", j)
//      continue INNER
      break OUTER  // OUTER 종료
    }
    print("  inner \(j)")
  }
  print("outer \(i)")
}

// 결과를 예상해보고 직접 break 와 continue, INNER 와 OUTER 를 바꿔가며
// 실제로 어떤 결과를 출력하는지 확인해보세요.
//inner 0123
//outer 0
// inner 0123
// outer 1

//: [Next](@next)
