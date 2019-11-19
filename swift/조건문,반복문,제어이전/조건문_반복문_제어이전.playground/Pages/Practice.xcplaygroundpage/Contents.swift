//: [Previous](@previous)
/*:
 # Practice
 */
/*:
 ---
 ## Conditional Statements
 ---
 */
/*
 - 학점을 입력받아 각각의 등급을 반환해주는 함수 (4.5 = A+,  4.0 = A, 3.5 = B+ ...)
 - 특정 달을 숫자로 입력 받아서 문자열로 반환하는 함수 (1 = "Jan" , 2 = "Feb", ...)
 - 세 수를 입력받아 세 수의 곱이 양수이면 true, 그렇지 않으면 false 를 반환하는 함수
   (switch where clause 를 이용해 풀어볼 수 있으면 해보기)
 */
func inputLevel (_ numbers : Double...){
    print("첫 번째 문제 성적 출력")
    for number in numbers {
        switch number {
        case let num where num >= 4.5 :
            print("A+")
        case let num where num >= 4.0 :
            print("A")
        case let num where num >= 3.5 :
            print("B+")
        case let num where num >= 3.0 :
            print("B")
        case let num where num >= 2.5 :
            print("C+")
        case let num where num >= 2.0 :
            print("C")
        default:
            print("F")
        }
    }
}
inputLevel(3,5.3,2.1,4.2,4.3)

func returnMonth ( num : Int) -> String{
    switch num {
    case let num where num == 1:
        return "1월"
    case let num where num == 2:
        return ":2월"
    case let num where num == 3:
        return "3월"
    case let num where num == 4:
        return "4월"
    case let num where num == 5:
        return "5월"
    case let num where num == 6:
        return "6월"
    case let num where num == 7:
        return "7월"
    case let num where num == 8:
        return "8월"
    case let num where num == 9:
        return "9월"
    case let num where num == 10:
        return "10월"
    case let num where num == 11:
        return "11월"
    case let num where num == 12:
        return "12월"
    default:
        return "뭐임?"
    }
}
print(returnMonth(num: 5))

func multiPl( a : Int , b : Int , c : Int) -> Bool {
    
    switch a*b*c {
    case  let numbers where numbers >= 0:
        return true
    default:
        
        return false
        
    }
    
}
print(multiPl(a: 1, b: 2, c: 3))

/*:
 ---
 ## Loops
 ---
 */
/*
 반복문(for , while , repeat - while)을 이용해 아래 문제들을 구현해보세요.
 - 자연수 하나를 입력받아 그 수의 Factorial 을 구하는 함수
   (Factorial 참고: 어떤 수가 주어졌을 때 그 수를 포함해 그 수보다 작은 모든 수를 곱한 것)
   ex) 5! = 5 x 4 x 3 x 2 x 1
 - 자연수 두 개를 입력받아 첫 번째 수를 두 번째 수만큼 제곱하여 반환하는 함수
   (2, 5 를 입력한 경우 결과는 2의 5제곱)
 - 자연수 하나를 입력받아 각 자리수 숫자들의 합을 반환해주는 함수
   (1234 인 경우 각 자리 숫자를 합치면 10)
 */
func factorial ( num : Int){
    
    var value : Int = 1
    for i in 1...num{
        value*=i
    }
    print(value)
}

factorial(num: 4)

func square (a : Int , b : Int) -> Int {
    
    var baseNumber : Int = 1
    let index : Int = a
    
    for _ in 1...b{
        baseNumber = baseNumber * index
        
    }
    return baseNumber
}
print(square(a: 2, b: 8))

let a : Double = 1567879
let v : Double = 10000000
print(a/v)

func totalAdd( a : Double) -> Int {

    var value : Int = 0
    var baseNumber : Double = a
    while baseNumber/10 >= 0.1 {
        value += Int(baseNumber.truncatingRemainder(dividingBy: 10))
        //print(baseNumber.truncatingRemainder(dividingBy: 10))
        baseNumber = Double(Int(baseNumber/10))
        print(value)
        
        
    }

    return value
}

print(totalAdd(a: 1234))
/*:
 ---
 ## Control Transfer
 ---
 */
/*
 - 자연수 하나를 입력받아 1부터 해당 숫자 사이의 모든 숫자의 합을 구해 반환하는 함수를 만들되,
   그 합이 2000 을 넘는 순간 더하기를 멈추고 바로 반환하는 함수
 - 1 ~ 50 사이의 숫자 중에서 20 ~ 30 사이의 숫자만 제외하고 그 나머지를 모두 더해 출력하는 함수
 */

func plus ( a : Int) -> Int{
    var value : Int = 0
    for i in 1...a{
        
        if value > 2000{
            return value
        }
        else{
            value += i
        }
        
    }
    return value
}

print(plus(a: 100))

print("===========")

func plusplus( a : Int = 50) -> Int{
    
    var value : Int = 0

    for i in 1...a{
        
        if (20...30 ~= i){
            print(i)
            continue
            
        }
        
        value += i
        
    }
    return value
}

print(plusplus())
//: [Next](@next)
