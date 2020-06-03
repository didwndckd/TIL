//: [Previous](@previous)
import Foundation

// 키노트 문제 참고
/*:
 ---
 ## Practice 1
 ---
 */
print("\n---------- [ Practice 1 ] ----------\n")

struct Pet {
  enum PetType {
    case dog, cat, snake, pig, bird
  }
  var type: PetType
  var age: Int
}

let myPet = [
  Pet(type: .dog, age: 13),
  Pet(type: .dog, age: 2),
  Pet(type: .dog, age: 7),
  Pet(type: .cat, age: 9),
  Pet(type: .snake, age: 4),
  Pet(type: .pig, age: 5),
]


let sortedMyPet = myPet.sorted(by: {(first: Pet, second: Pet) in
    return first.age < second.age
})

myPet
sortedMyPet


// 1번
func sumDogAge(pets: [Pet]) -> Int {
    
//   let totalAge = pets.filter({(pet: Pet) in
//        pet.type == .dog
//    }).reduce(0, {(result: Int, pet: Pet) in
//        result + pet.age
//    })
    
    let totalAge = pets.filter {$0.type == .dog}.reduce(0, {$0 + $1.age})
    
    return totalAge
    
}
sumDogAge(pets: myPet)

// 2번
func oneYearOlder(of pets: [Pet]) -> [Pet] {
    
//    let value = pets.map({(pet: Pet) in
//        Pet(type: pet.type, age: pet.age + 1)
//    })
    
    let value = pets.map {
       return Pet(type: $0.type, age: $0.age + 1)
    }
    
  return value
}

myPet
oneYearOlder(of: myPet)



/*:
 ---
 ## Practice 2
 ---
 */
print("\n---------- [ Practice 2 ] ----------\n")

let immutableArray = Array<Int>(1...40)

func multiplication(index: Int , value: Int) -> Int {
    return index * value
}

func even(num: Int ) -> Bool {
    return num & 1 == 0 // num & 1 -> 비트 연산자로
}

func addition(first: Int , second: Int) -> Int {
    return first + second
}

//let value = immutableArray.enumerated()
//    .map { multiplication(index: $0, value: $1) }
//    .filter { even(num: $0) }
//    .reduce(0) { addition(first: $0, second: $1) }

let value = immutableArray.enumerated()
    .map(*)
    .filter({$0 & 1 == 0})
    .reduce(0, +)


print(value)

//: [Next](@next)
