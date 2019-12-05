//: [Previous](@previous)
/*:
 # Type Check
 */

/*:
 ---
 ## 타입 확인 - type(of: )
 ---
 */
print("\n---------- [ type(of:) ] ----------\n")

type(of: 1)
type(of: 2.0)
type(of: "3")


// Any
let anyArr: [Any] = [1, 2.0, "3"]
type(of: anyArr[0])
type(of: anyArr[1])
type(of: anyArr[2])


// Generic
// 타입을 미리 정하는게 아니고 값이 들어오는 순간에 타입을 결정하는것
func printGenericInfo<T>(_ value: T) {
  let types = type(of: value)
  print("'\(value)' of type '\(types)'")
}
printGenericInfo(1)
printGenericInfo(2.0)
printGenericInfo("3")



/*:
 ---
 ## 타입 비교 - is
 ---
 */
print("\n---------- [ is ] ----------\n")

/***************************************************
 객체 is 객체의 타입 -> Bool (true or false)
 ***************************************************/

let number = 1
number == 1    // 값 비교
number is Int  // 타입 비교
number is String // 타입 비교

let strArr = ["A", "B", "C"]

if strArr[0] is String {
  "String"
} else {
  "Something else"
}


if strArr[0] is Int {
  "Int"
}


let someAnyArr: [Any] = [1, 2.0, "3"]

for data in someAnyArr {
  if data is Int {
    print("Int type data :", data)
  } else if data is Double {
    print("Double type data : ", data)
  } else {
    print("String type data : ", data)
  }
}



/*:
 ---
 ## 상속 관계
 ---
 */
print("\n---------- [ Subclassing ] ----------\n")

class Human {
  var name: String = "name"
}
class Baby: Human {
  var age: Int = 1
}
class Student: Human {
  var school: String = "school"
}
class UniversityStudent: Student {
  var univName: String = "Univ"
}

let student = Student()
student is Human //true
student is Baby  // false
student is Student // true

let univStudent = UniversityStudent()
student is UniversityStudent // false
univStudent is Student      // true


/***************************************************
 자식 클래스 is 부모 클래스  -> true
 부모 클래스 is 자식 클래스  -> false
 ***************************************************/


let babyArr = [Baby()]
type(of: babyArr)  // Array<Baby>


// Q. 그럼 다음 someArr 의 Type 은?

let someArr = [Human(), Baby(), UniversityStudent()]
type(of: someArr)
// Array<Human> -> 모두 Human클래스 이거나 Human클래스를 상속받기 때문에 최상위 부모 클래스의 타입으로 결정됨


someArr[0] is Human    //ture
someArr[0] is Student  //false
someArr[0] is UniversityStudent  //false
someArr[0] is Baby     //false

someArr[1] is Human    //true
someArr[1] is Student  //false
someArr[1] is UniversityStudent  //false
someArr[1] is Baby     //true

someArr[2] is Human    //true
someArr[2] is Student  //true
someArr[2] is UniversityStudent  //true
someArr[2] is Baby     //false


var human: Human = Student()// 컴파일 단계에서는 Human타입으로 인식 하지만 런타임에서는 Student타입으로 바뀜
type(of: human) //Student
// 해당 변수의 타입 vs 실제 데이터의 타입 student

// Q. human 변수의 타입, name 속성의 값, school 속성의 값은?
human.name    // -> "name"이 나온다
//human.school  // -> 에러발생 -> 컴파일 단계이기 때문에 Human타입으로 인식한다
              //그런데 Human타입에는 school 프로퍼티가 없기 때문에 에러가 발생한다



// Q. Student의 인스턴스가 저장된 human 변수에 다음과 같이 Baby의 인스턴스를 넣으면?
human = Baby()
type(of: human) // Baby 타입
human = UniversityStudent()
type(of: human)  // UniversityStudent 타입

var james = Student() //Student타입
james = UniversityStudent() // UniversityStudent 타입
//james = Baby()    // 에러발생 -> Baby타입은 Student타입과 형제관계이기 때문

// Q. 다음 중 james 가 접근 가능한 속성은 어떤 것들인가
james.name     // Human -> 속성 접근가능
//james.age      // Baby -> 속성 접근 불가
james.school   // Student -> 속성 접근 가능
//james.univName // UniversityStudent -> 속성 접근 불가



// Q. 그럼 james 객체가 univName을 사용할 수 있도록 하려면 뭘 해야 할까요
// 타입 캐스팅
// 

//: [Next](@next)
