//: [Previous](@previous)
//: - - -
//: # Strong, Unowned, Weak
//: - - -

class Teacher {
  var student: Student?
  deinit {
    print("Teacher is being deinitialized")
  }
}

class Student {
  // strong, unowned, weak
//  let teacher: Teacher  // count = 2
  unowned let teacher: Teacher // count = 1 / 카운트가 올라가지 않음
//  weak var teacher: Teacher?
  
  init(teacher: Teacher) {
    self.teacher = teacher
  }
  deinit {
    print("Student is being deinitialized")
  }
}

var teacher: Teacher? = Teacher()
var student: Student? = Student(teacher: teacher!)
teacher?.student = student // 강한참조 선언시 count = 2 약한참조 선언시 count = 1


print("\n---------- [ teacher release ] ----------\n")
teacher = nil // 약한 참조 선언시 -> tracher count = 0 / student count = 1

print("\n---------- [ student release ] ----------\n")
student = nil // count = 0





/***************************************************
 1) strong  : 명시적으로 nil 대입 필요. teacher?.student = nil
 2) unowned : 자동으로 deinit. nil 처리 된 속성에 접근하면 런타임 에러 발생
 3) weak    : 자동으로 deinit. nil 처리 된 속성에 접근하면 nil 반환
 ***************************************************/


//: [Next](@next)
