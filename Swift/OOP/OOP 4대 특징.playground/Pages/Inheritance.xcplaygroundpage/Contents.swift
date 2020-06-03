//: [Previous](@previous)
/*:
 ---
 # Inheritance
 ---
 */

class Cat {
  let leg = 4
  func cry() {
    print("miaow")
  }
}

class KoreanShortHair: Cat {}

let cat = Cat()
print(cat.leg)
cat.cry()

let koshort = KoreanShortHair()
print(koshort.leg)
koshort.cry()


/*:
 ---
 ### Question
 Person, Student, University Student 클래스 구현하고 관련 속성 및 메서드 구현
 - 상속을 하지 않고 각각 개별적으로 만들면 어떻게 구현해야 하는지 확인
 - 상속을 적용하면 어떻게 바뀌는지 확인
 ---
 */
class Person {
    var name: String
    var age: Int
    func eat() {
        print("냠냠 짭짭")
    }
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class Student: Person {
    var grade: Int
    init(name: String ,age: Int , grade: Int) {
        self.grade = grade
        super.init(name: name, age: age)
    }
    func study(){
        print("공부중 ....")
    }
}

class UniversityStudent: Student {
    
    var major : String
    
    init(name: String ,age: Int , grade: Int ,major: String) {
        self.major = major
        super.init(name: name, age: age, grade: grade)
    }
    func goMT() {
        print("엠티 가자")
    }
    
    
    
}

let person = Person(name: "사람", age: 28)
let studen = Student(name: "학생", age: 29, grade: 2)
let adert = UniversityStudent(name: "대학생", age: 30, grade: 2, major: "메이저")


/*:
 ## final
 */
print("\n---------- [ Final ] ----------\n")

class Shape {
}

final class Circle: Shape {
}

//class Oval: Circle {
//}



/*:
 ---
 ### Answer
 ---
 */

class Person1 {
  let name = "홍길동"
  let age = 20
  
  func eat() {
    print("eat")
  }
}


print("\n---------- [ Without Subclassing ] ----------\n")

//class Student1 {
//  let name = "홍길동"
//  let age = 20
//  let grade = "A"
//
//  func eat() {
//    print("eat")
//  }
//  func study() {
//    print("study")
//  }
//}
//
//class UniversityStudent1 {
//  let name = "홍길동"
//  let age = 20
//  let grade = "A"
//  let major = "Computer Science"
//
//  func eat() {
//    print("Eat")
//  }
//  func study() {
//    print("Study")
//  }
//  func goMT() {
//    print("Go membership training")
//  }
//}


print("\n---------- [ Subclassing ] ----------\n")

class Student1: Person1 {
  let grade = "A"
  
  func study() {
    print("study")
  }
}

class UniversityStudent1: Student1 {
  let major = "Computer Science"
  
  func goMT() {
    print("Go membership training")
  }
}



//: [Next](@next)
