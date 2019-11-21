import UIKit

var str = "Hello, playground"



print("이름과 나이를 입력 받아 자신을 소개하는 글을 출력하는 함수")

func selfIntroduce(name : String , age : Int) -> Void{
    print("안녕하세요 제이름은 \(name)이고 나이는 \(age)살 입니다")
}

var name : String = "양중창"
var age : Int = 28

selfIntroduce(name: name, age: age)

print(" ")
print("정수를 하나 입력받아 2의 배수 여부를 반환하는 함수")

func evenNum(num : Int) -> Bool{
    return num % 2 == 0
}

var a : Bool = evenNum(num: 5)

print(evenNum(num: 4))

print(" ")
print("정수를 두 개 입력 받아 곱한 결과를 반환하는 함수 (파라미터 하나의 기본 값은 10)")

func multiPlication( a : Int , b : Int = 10 ) -> Int{
    return a * b
}

print("기본값 사용\(multiPlication(a: 2 ))")
print("설정값 사용\(multiPlication(a: 2 , b : 3))")


print("4과목의 시험 점수를 입력받아 평균 점수를 반환하는 함수")

func average( meth : Int , korean : Int , science : Int , society : Int) -> Int{
        return (meth + korean + science + society)/4
}

print("평균 \(average(meth: 90, korean: 70, science: 23, society: 56))")


print("점수를 입력받아 학점을 반환하는 함수 만들기 (90점 이상 A, 80점 이상 B, 70점 이상 C, 그 이하 F)")

func getPoint ( credit : Int) -> String {
    if credit >= 90 {
        return "A"
    }else if credit >= 80 {
        return "B"
    }else if credit >= 70 {
        return "C"
    }else{
        return "F"
    }
}

var point : Int = 55
print("잆력값 \(point) 결과값 \(getPoint(credit: point))")



print("가변 인자 파라미터를 이용해 점수를 여러 개 입력받아 평균 점수에 대한 학점을 반환하는 함수 (90점 이상 A, 80점 이상 B, 70점 이상 C, 그 이하 F)")

func variableParam(_ numbers : Int...) -> String{
    var total : Int = 0
    var i :Int = 1
    for num in numbers {
        total += num
        print("과목-\(i) : \(num) ")
        i += 1
    }
    
    let credit : Int = total/numbers.count
    print("과목 갯수 \(numbers.count)")
    if credit >= 90 {
        return "A"
    }else if credit >= 80 {
        return "B"
    }else if credit >= 70 {
        return "C"
    }else{
        return "F"
    }
    
}

print(variableParam(70, 80, 77, 89, 80, 96))


