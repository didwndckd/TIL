import UIKit





//[ 과제 - 알고리즘 ]
//1. 정수 하나를 입력받은 뒤, 해당 숫자와 숫자 1사이에 있는 모든 정수의 합계 구하기
//e.g.  5 -> 1 + 2 + 3 + 4 + 5 = 15,   -2 -> -2 + -1 + 0 + 1 = -2

func pullShot (num: Int)-> Int {
    
    
    
    switch num {
        
    case var number where number > 1:
        
        for i in 1..<number {
            number += i
        }
        return number
    
    case var number where number < 1:
        for i in number+1...1 {
            number += i
        }
        return number
    
    default:
        return num
    }
    
}

pullShot(num: -3)



//2. 숫자를 입력받아 1부터 해당 숫자까지 출력하되, 3, 6, 9가 하나라도 포함되어 있는 숫자는 *로 표시
//e.g.  1, 2, *, 4, 5, *, 7, 8, *, 10, 11, 12, *, 14, 15, * ...

func game(num: Int){
    
    for i in 1...num {
        
        let number = String(i)
        if number.contains("3") || number.contains("6") || number.contains("9")
        {
            print("*")
    
        }else{
            print(i)
        }
        
    }
    
    
}

game(num: 19)

//3. 2개의 정수를 입력했을 때 그에 대한 최소공배수와 최대공약수 구하기
//e.g.  Input : 6, 9   ->  Output : 18, 3
// 최대공약수
// 1) 두 수 중 큰 수를 작은 수로 나눈 나머지가 0이면 최대 공약수
// 2) 나머지가 0이 아니면, 큰 수에 작은 수를 넣고 작은 수에 나머지 값을 넣은 뒤 1) 반복
// 최소 공배수
// - 주어진 두 수의 곱을 최대공약수로 나누면 최소공배수

let num1 = 6
let num2 = 9

func arithmetic (a: Int , b: Int ) -> (Int , Int ) {

    var greatest : Int  // 최대 공약수
    var LCM: Int  // 최소 공배수
    var rest: Int  // 나머지

    if a>b {
        if a%b == 0 {
            greatest = b
            LCM = (num1*num2)/greatest
            return (greatest, LCM)

        }else{
            rest = a%b
            print(rest)
           return arithmetic(a: b, b: rest)
        }
    }
    else if b>a {
        if b%a == 0 {
            greatest = b
            LCM = (num1*num2)/greatest
            return (greatest, LCM)
        }else{
            rest = b%a
           return arithmetic(a: a, b: rest)
        }
    }
    else {
        return (a,b)
    }


}

print("-----------------------------------------------")

arithmetic(a: num1, b: num2)
