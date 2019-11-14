import UIKit

//optionalStr ?? "This is a nil value" 를 3항 연산자로 바꿔보기

let defaultStr : String = "This is a nil value"
var optionalStr : String? = nil

let answer = optionalStr != nil ? optionalStr! : defaultStr


/*
2개의 정수를 입력받아 Modulo 연산(%)의 결과를 반환하는 함수를 만들되
2번째 파라미터와 결과값의 타입은 옵셔널로 정의.
두 번째 파라미터 입력값으로 nil 이나 0이 들어오면 결과로 nil을 반환하고, 그 외에는 계산 결과 반환

func calculateModulo(op1: Int, op2: Int?) -> Int? {
}
*/

func calculateModulo(op1: Int, op2: Int?) -> Int? {
    
    if let element = op2 , element != 0 {
        return op1%element
    }else{
        return nil
    }
    
}

calculateModulo(op1: 423, op2: 10)



//
//[ 과제 ]
//1. 옵셔널 타입의 문자열 파라미터 3개를 입력받은 뒤, 옵셔널을 추출하여 Unwrapped 된 하나의 문자열로 합쳐서 반환하는 함수
//func combineString(str1: String?, str2: String?, str3: String?) -> String {
//  // code
//}
//// 입력 예시 및 결과
//combineString1(str1: "AB", str2: "CD", str3: "EF")   // "ABCDEF"
//combineString1(str1: "AB", str2: nil, str3: "EF")    // "ABEF"

func combineString(str1 : String? , str2 : String?, str3 : String?) -> String {
            
    guard let st1 = str1, let st2 = str2 , let st3 = str3 else{return "nil값이 포함되어 있음"}
            
    
    return st1+st2+st3
}

combineString(str1: "AB", str2: "CD", str3: "EF")

//2. 사칙연산(+, -, *, /)을 가진 enum 타입 Arithmetic과 2개의 자연수를 입력 파라미터로 받아 (파라미터 총 3개) 해당 연산의 결과를 반환하는 함수 구현
//enum Arithmetic {
//  case addition, subtraction, multiplication, division
//}

enum Arthmetic {
    case addition
    case subtraction
    case multiplocation
    case division
    
    func artmetic (a : Int , b : Int ) -> Int {
        
        switch self {
        case .addition :
            return a+b
        case .division :
            return a/b
        case .subtraction :
            return a-b
        case .multiplocation :
            return a*b
        }
        
    }
    
}

let arthmetic : Arthmetic = .multiplocation

arthmetic.artmetic(a: 3, b: 4)


//[ 도전 과제 ]
//1. celcius, fahrenheit, kelvin 온도 3가지 케이스를 가진 enum 타입 Temperature 를 정의
//각 케이스에는 Double 타입의 Associated Value 를 받도록 함
//추가로 Temperature 타입 내부에 각 온도를 섭씨 온도로 변환해주는 toCelcius() 함수를 구현
//섭씨 = (화씨 - 32) * 5 / 9
//섭씨 = 켈빈 + 273
//
//enum Temperature {
//  // 코드
//}

enum Temperature {
    case celcius , fahrenheit, kelvin
    
    func toCelcius(temperanture : Double) -> Double {
        
        switch self {
        case .fahrenheit:
            return (temperanture - 32) * 5/9
        case .kelvin:
            return temperanture - 273
        default:
            return temperanture
        }
        
    }
    
}

Temperature.fahrenheit.toCelcius(temperanture: 35)
Temperature.celcius.toCelcius(temperanture: 23)
Temperature.kelvin.toCelcius(temperanture: 34)


//2. 다음 ArithmeticExpression 의 각 케이스별로 연산을 수행하고 그 값을 반환하는 evaluate 함수 구현

enum ArithmeticExpression {
  case number(Int)
  indirect case addition(ArithmeticExpression, ArithmeticExpression)
  indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
}
let five = ArithmeticExpression.number(5)
let four = ArithmeticExpression.number(4)
let sum = ArithmeticExpression.addition(five, four)
let product = ArithmeticExpression.multiplication(sum, sum)
func evaluate(_ expression: ArithmeticExpression) -> Int {
  // 코드
    switch expression {
    case .number(let x):
        return x
    case .addition(let x, let y):
        // 더하기 연산
        switch (x,y) {
        case (let x , let .number(y)):
            return evaluate (x) + y
        case (let .number(x) , let y):
            return x + evaluate(y)
        case (let x , let y):
            return evaluate(x) + evaluate(y)
        }// 더하기 연산
        
    case .multiplication(let x, let y):
        // 곱하기 연산
        switch (x, y) {
        case (let x , let .number(y)):
            return evaluate(x) * y
        case (let .number(x) , let y):
            return x * evaluate(y)
        case (let x , let y):
            return evaluate(x) * evaluate(y)
        
        }// 곱하기 연산
    }
    
}
    
evaluate(five)    // 결과 : 5
evaluate(sum)     // 결과 : 9
evaluate(product) // 결과 : 18

