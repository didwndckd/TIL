//: [Previous](@previous)
/*:
 # Type Conversion
 */

let height = Int8(5)
let width = 10
//let area = height * width => 같은 Int 타입이지만 Int 와 Int8 로 다르기때문에 연산 불가
//print(area)


let h = Int8(12)
let x = 10 * h // x가 Int타입이 되기전 이기 때문에 x는 Int8타입의 h 와 같은 Int8로 타입이 정해진다
//print(x)

/*:
 ---
 ## Question
 - 8번째 라인 let area = height * width  부분은 에러가 발생하고
 - 13번째 라인 let x = 10 * h 에서는 에러가 발생하지 않는 이유는?
 ---
 */

let num = 10
let floatNum = Float(num)
type(of: floatNum)

let signedInteger = Int(floatNum) // 실수를 Int타입에 담을때는 소수점 부분은 짤리고 정수부분만 저장된다
type(of: signedInteger)

let str = String(num)
type(of: str)


let anInteger: Int = -15
let absNum = abs(anInteger)   // abs = 절대값으로 바꿔준다
type(of: absNum)


//: [Next](@next)
