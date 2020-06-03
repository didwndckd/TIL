import UIKit

//1. 다음과 같은 속성(Property)과 행위(Method)를 가지는 클래스 만들어보기.
//   구현 내용은 자유롭게
//
// ** 강아지 (Dog)
// - 속성: 이름, 나이, 몸무게, 견종
// - 행위: 짖기, 먹기
//
class Dog {
    var name : String
    var age : Int
    var weight : Int
    var type : String
    
    init(name : String , age : Int , weight : Int , type : String) {
        self.name = name
        self.age = age
        self.weight = weight
        self.type = type
    }
    func eat (){
        print("쿰척쿰척")
    }
    func bark () {
        print("멍!멍!")
    }
}

// ** 학생 (Student)
// - 속성: 이름, 나이, 학교명, 학년
// - 행위: 공부하기, 먹기, 잠자기
//

class Student {
    var name : String
    var age : Int
    var school : String
    var grade : Int
    
    init(name : String , age : Int , school : String , grade : Int) {
        self.name = name
        self.age = age
        self.school = school
        self.grade = grade
    }
    func study () {
        print("공부중 ...")
    }
    func eat () {
        print("냠냠 짭짭")
    }
    func sleep() {
        print("Zzzz")
    }
    
}

// ** 아이폰(IPhone)
// - 속성: 기기명, 가격, faceID 기능 여부(Bool)
// - 행위: 전화 걸기, 문자 전송
class IPhone {
    var name : String
    var price : Int
    var version : Int
    var havefaceID : Bool
    init(name : String , price : Int , version : Int ) {
        self.name = name
        self.price = price
        self.version = version
        if version > 9 {
            havefaceID = true
        }else {
            havefaceID = false
        }
    }
    
    func call (phoneNum : String) {
        print("\(phoneNum) 에 전화 연결중")
    }
    func sendMessage(reciver : String , text : String){
        print("""
        받는사람 : \(reciver)
        내용 : \(text)
        """)
    }
    
}
// ** 커피(Coffee)
// - 속성: 이름, 가격, 원두 원산지\

class Coffee {
    var name : String
    var price : Int
    var country : String
    
    init(name : String , price : Int , country : String) {
        self.name = name
        self.price = price
        self.country = country
    }
}

//2. 계산기 클래스를 만들고 다음과 같은 기능을 가진 Property 와 Method 정의해보기
//
// ** 계산기 (Calculator)
// - 속성: 현재 값
// - 행위: 더하기, 빼기, 나누기, 곱하기, 값 초기화
//
// ex)
// let calculator = Calculator() // 객체생성
//
// calculator.value  // 0
// calculator.add(10)    // 10
// calculator.add(5)     // 15
//
// calculator.subtract(9)  // 6
// calculator.subtract(10) // -4
//
// calculator.multiply(4)   // -16
// calculator.multiply(-10) // 160
//
// calculator.divide(10)   // 16
// calculator.reset()      // 0

class Calculator {
    var value : Int = 0
    
    func add(_ a: Int ) -> Int {
        value += a
        return value
    }
    func subtract(_ a: Int ) -> Int {
        value -= a
        return value
    }
    func multiply(_ a: Int ) -> Int {
        value *= a
        return value
    }
    func divide(_ a: Int ) -> Int {
        value /= a
        return value
    }
    func reset () {
        value = 0
    }
}

 let calculator = Calculator() // 객체생성

 calculator.value  // 0
 calculator.add(10)    // 10
 calculator.add(5)     // 15

 calculator.subtract(9)  // 6
 calculator.subtract(10) // -4

 calculator.multiply(4)   // -16
 calculator.multiply(-10) // 160

 calculator.divide(10)   // 16
 calculator.reset()      // 0
calculator.value



//3. 첨부된 그림을 참고하여 각 도형별 클래스를 만들고 각각의 넓이, 둘레, 부피를 구하는 프로퍼티와 메서드 구현하기

class Square {
    var s: Int
    init(s: Int ) {
        self.s = s
    }
    func A() -> Int {
       return s*s
    }
    func P() -> Int {
       return 4*s
    }
}

let squ = Square(s: 3)
squ.A()
squ.P()

class Rectangle {
    var w: Int
    var l: Int
    init(w: Int , l: Int) {
        self.w = w
        self.l = l
    }
    func A() -> Int {
        return w*l
    }
    func P() -> Int {
        return (2*l) + (2*w)
    }
}
let rect = Rectangle(w: 4, l: 2)
rect.A()
rect.P()

class Cirde {
    let pie = 3.14
    var r: Double
    
    init(r: Double) {
        self.r = r
    }
    
    func A() -> Double {
        return pie * (r*r)
    }
    func P() -> Double {
        return (2*pie)*r
    }
}
let cir = Cirde(r: 10)
cir.A()
cir.P()

class Triangle {
    var b: Double
    var h: Double
    
    init(b: Double , h: Double ) {
        self.b = b
        self.h = h
    }
    
    func A() -> Double {
        return (b*h)/2
    }
}

let tri = Triangle(b: 2, h: 4)
tri.A()

class Trapezoid {
    var b: Double
    var h: Double
    var a: Double
    
    init(b: Double, h: Double, a: Double) {
        self.b = b
        self.h = h
        self.a = a
    }
    func A() -> Double {
        return (h*(a+b))/2
    }
}

let tra = Trapezoid(b: 2, h: 4, a: 8)
tra.A()

class Cube {
    var s: Int
    init(s: Int ) {
        self.s = s
    }
    func V() -> Int {
        return s*s*s
    }
}

let cub = Cube(s: 4)
cub.V()

class RectangularSolid {
    var w: Int
    var h: Int
    var l: Int
    init(w: Int , h: Int , l: Int ) {
        self.w = w
        self.l = l
        self.h = h
    }
    func V() -> Int {
        return w*l*h
    }
}

let rectSol = RectangularSolid(w: 2, h: 3, l: 4)
rectSol.V()

class CircularCylinder {
    var r: Double
    var h: Double
    let pie = 3.14
    
    init(r: Double , h: Double) {
        self.r = r
        self.h = h
    }
    func V() -> Double {
        return pie*r*r*h
    }
}

let circularCylinder = CircularCylinder(r: 2, h: 4)
circularCylinder.V()

class Sphere {
    var r: Double
    let pie = 3.14
    
    init(r: Double) {
        self.r = r
    }
    func V() -> Double {
        return (4/3)*pie*(r*r*r)
    }
}

let sphere = Sphere(r: 2)
sphere.V()

class Cone {
    var r: Double
    var h: Double
    let pie = 3.14
    
    init(r: Double, h: Double) {
        self.r = r
        self.h = h
    }
    func V() -> Double {
        return (1/3)*pie*(r*r)*h
    }
}

let cone = Cone(r: 2, h: 4)
cone.V()














