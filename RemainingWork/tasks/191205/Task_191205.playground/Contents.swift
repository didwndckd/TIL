import UIKit



//******************
//** Type Casting **
//******************
//[ 과제 ]
//1.
func addTwoValues(a: Int, b: Int) -> Int {
  return a + b
}
let task1: Any = addTwoValues(a: 2, b: 3)
//위와 같이 정의된 변수 task1이 있을 때 다음의 더하기 연산이 제대로 동작하도록 할 것
if let task1 = task1 as? Int {
   task1 + task1
}

type(of: task1)


//[ 도전 과제 ]
//1.

let task2: Any = addTwoValues
//과제 1번에 이어 이번에는 위와 같이 정의된 task2 변수에 대해
//두 변수의 더하기 연산이 제대로 동작하도록 할 것
//(addTwoValues의 각 파라미터에는 원하는 값 입력)
//task2 + task2

if let task = task2 as? (Int, Int) -> Int {
    
    let task2 = task(1,2)
    
    task2 + task2
    
    
}


//2.
class Car1 {
    let name = "kona"
}

let values: [Any] = [
  0,
  0.0,
  (2.0, Double.pi),
  Car1(),
  { (str: String) -> Int in str.count }
]
//위 values 변수의 각 값을 switch 문과 타입캐스팅을 이용해 출력하기
for value in values {
  switch value {
  case let a as Int:
    print("Int: \(a), \(type(of: a))")
  case let a as Double:
    print("Double: \(a)")
  case let a as (Double, Double) :
    print("Tuple: \(a)")
  case let a as Car1:
    print(a.name)
  case let a as (String) -> Int:
        print(a("123456"))
  default:
    print("default")
    
  }
}





//*****************
//** Initializer **
//*****************
//[ 과제 ]
//1. 생성자 구현
//- Vehicle 클래스에 지정 이니셜라이져(Designated Initializer) 추가
//- Car 클래스에 modelYear 또는 numberOfSeat가 0 이하일 때 nil을 반환하는 Failable Initializer 추가
//- Bus 클래스에 지정 이니셜라이져를 추가하고, maxSpeed를 100으로 기본 할당해주는 편의 이니셜라이져 추가
class Vehicle {
  let name: String
  var maxSpeed: Int
    init(name: String, maxSpeed: Int) {
        self.name = name
        self.maxSpeed = maxSpeed
    }
//    init() {
//        name = "sonata"
//        maxSpeed = 30
//    }
}
class Car: Vehicle {
  var modelYear: Int
  var numberOfSeats: Int
    init?(modelYear: Int, numberOfSeats: Int, name: String, maxSpeed: Int) {
        if modelYear <= 0 || numberOfSeats <= 0 {
            return nil
        }
        
        self.modelYear = modelYear
        self.numberOfSeats = numberOfSeats
        super.init(name: name, maxSpeed: maxSpeed)
    }
}

if let car = Car(modelYear: 0, numberOfSeats: 1, name: "kona", maxSpeed: 12) {
    car.name
    car.modelYear
    car.numberOfSeats
    car.maxSpeed
}


class Bus: Vehicle {
  let isDoubleDecker: Bool
    
    init(isDoubleDecker: Bool) {
        self.isDoubleDecker = isDoubleDecker
        super.init(name: "kona", maxSpeed: 20)
        
    }
    
    convenience init() {
        self.init(isDoubleDecker: true)
        self.maxSpeed = 100
    }
    
}

let bus2 = Bus(isDoubleDecker: true)

let bus = Bus()
bus.name
bus.isDoubleDecker
bus.maxSpeed



















