//: [Previous](@previous)
import Foundation
/*:
 ---
 ## Array
 - Ordered Collection
 - Zero-based Integer Index
 ---
 */

/*:
 ### Mutable, Immutable
 */

var variableArray = [1, 2]
variableArray = []

let constantArray = [1, 2]
//constantArray = []


/*:
 ### Array Type
 */

var arrayFromLiteral = [1, 2, 3]
//arrayFromLiteral = []
arrayFromLiteral.append(12)
dump(arrayFromLiteral)

//let emptyArray = []

//let emptyArray: [String] = []


/*:
 ### Initialize
 */

// Type Annotation
let strArray1: Array<String> = ["apple", "orange", "melon"]
let strArray2: [String] = ["apple", "orange", "melon"]

// Type Inference
let strArray3 = ["apple", "orange", "melon"]
let strArray4 = Array<String>(repeating: "iOS", count: 5)
strArray4[3]

// Error
//let strArray5 = ["apple", 3.14, 1]


/*:
 ---
 ### Question
 - String 타입과 Int 타입으로 각각 자료가 없는 상태인 빈 배열을 만들어보세요.
 - Double 타입은 Type Annotation, Bool 타입은 Type Inference 방식으로 각각 임의의 값을 넣어 배열을 만들어보세요.
 ---
 */
var strArray : [String] = []
var intArray : Array<Int> = Array<Int>()
var doubleArray : [Double] = [1.2, 2.3, 3.1]

/*:
 ### Number of Elements
 */
print("\n---------- [ Number of Elements ] ----------\n")

let fruits = ["Apple", "Orange", "Banana"]
let countOfFruits = fruits.count

if !fruits.isEmpty {
  print("\(countOfFruits) element(s)")
} else {
  print("empty array")
}


/*:
 ### Retrieve an Element
 */
//              0        1         2
// fruits = ["Apple", "Orange", "Banana" , endindex]

fruits[0]
fruits[2]
//fruits[123]

fruits.startIndex
fruits.endIndex  //endindex는 마지막 인덱스가 아니라 마지막인덱스의 다음 인덱스에 있음

fruits[fruits.startIndex]
fruits[fruits.endIndex - 1]


fruits.startIndex == 0
fruits.endIndex - 1 == 2


/*:
 ### Searching
 */
print("\n---------- [ Searching ] ----------\n")

let alphabet = ["A", "B", "C", "D", "E"]

if alphabet.contains("A") { //값이 있는지 확인하여 Bool타입으로 반환한다
  print("contains A")
}

if alphabet.contains(where: { str -> Bool in
  // code...
  return str == "A"
}) {
  print("contains A")
}

if let index = alphabet.firstIndex(of: "D") { //값의 인덱스를 확인한다
  print("index of D: \(index)")
}

//let idx1 = alphabet.firstIndex(of: "D")
//print(idx1)

//let idx2 = alphabet.firstIndex(of: "Q")
//print(idx2)


/*:
 ### Add a new Element
 */

//var alphabetArray: Array<String> = []
//var alphabetArray: [String] = []
//var alphabetArray = [String]()

var alphabetArray = ["A"]
alphabetArray.append("B") // 맨뒤에 추가
alphabetArray += ["C"] // append랑 같은 결과 이지만 다르게 기존 배열에 새로운 배열을 합하는 것임
alphabetArray

var alphabetArray2 = ["Q", "W", "E"]
alphabetArray + alphabetArray2

//alphabetArray.append(5.0)
//alphabetArray + 1

alphabetArray.insert("S", at: 0)
alphabetArray.insert("F", at: 3)
alphabetArray

/*:
 ### Change an Existing Element
 */

alphabetArray = ["A", "B", "C"]
alphabetArray[0] = "Z"
alphabetArray


1...5
1..<5
1...

alphabetArray = ["A", "B", "C", "D", "E", "F"]
alphabetArray[2...] = ["Q", "W", "E", "R"]
alphabetArray

alphabetArray[2...] = ["Q", "W"] // 넘어가는 애들은 삭제됨
alphabetArray   // 결과?


/*:
 ### Remove an Element
 */
alphabetArray = ["A", "B", "C", "D", "E"]

let removed = alphabetArray.remove(at: 0) // remove한 값을 반환 받을 수 있다
alphabetArray

alphabetArray.removeAll()


// index 찾아 지우기
alphabetArray = ["A", "B", "C", "D", "E"]

if let indexC = alphabetArray.firstIndex(of: "C") { // C값을 가진 첫번째 인덱스를 찾는다
  alphabetArray.remove(at: indexC)                  // 찾은 인덱스로 지운다
}
alphabetArray


/*:
 ### Sorting
 */

alphabetArray = ["A", "B", "C", "D", "E"]
alphabetArray.shuffle() // 자기자신이 섞이는것이고
alphabetArray.shuffled() // 자기자신은 바뀌지 않고 바뀐것을 반환하는것

alphabetArray.sort()  // 자기자신을 정렬 하는것
//alphabetArray.sorted() // 자기자신은 정렬 하지 않고 정렬한 값을 반환하는것
alphabetArray


// shuffle vs shuffled
// sorted vs sort

//func sorted() -> [Element]
//mutating func sort()

alphabetArray.shuffle()

var sortedArray = alphabetArray.sorted()
sortedArray
alphabetArray



// sort by closure syntax

sortedArray = alphabetArray.sorted { $0 > $1 }
alphabetArray.sorted(by: >= )
sortedArray


/*:
 ### Enumerating an Array
 */
print("\n---------- [ Enumerating an Array ] ----------\n")

// 배열의 인덱스와 내용을 함께 알고 싶을 때

let array = ["Apple", "Orange", "Melon"]

for value in array {
  if let index = array.firstIndex(of: value) {
    print("\(index) - \(value)")
  }
}


for tuple in array.enumerated() { // enumerated - 튜플로 들어옴
  print("\(tuple.0) - \(tuple.1)")
//  print("\(tuple.offset) - \(tuple.element)")
}

for (index, element) in array.enumerated() { // 튜플에 인덱스와 엘리먼트가 들어오고 차례로 진행
  print("\(index) - \(element)")
}


for (index, element) in array.reversed().enumerated() { //배열을 리버스 하고 튜플로 값을 받음
  print("\(index) - \(element)")
}


/*:
 ---
 ### Question
 ---
 */
/*
 - ["p", "u", "p", "p", "y"] 라는 값을 가진 배열에서 마지막 "p" 문자 하나만 삭제하기
 - 정수 타입의 배열을 2개 선언하고 두 배열의 값 중 겹치는 숫자들로만 이루어진 배열 만들기
 - 정수 타입의 배열을 선언하고 해당 배열 요소 중 가장 큰 값을 반환하는 함수
 */
strArray = ["p", "u", "p", "p", "y"]
if let lastindex = strArray.lastIndex(of: "p"){
    strArray.remove(at: lastindex)
}
strArray
// 2번 문제
// ex) [1, 2, 4, 8, 9, 12, 13] , [2, 5, 6, 9, 13]  -->  [2, 9, 13]

var intArray1 : [Int] = [1, 2, 4, 8, 9, 12, 13]
var intArray2 : [Int] = [2, 5, 6, 9, 13]
var intArray3 : [Int] = []
for i in intArray1 {
   
    for j in intArray2{
        if i == j {
            intArray3.append(i)
        }
    }
}
intArray3

// 3번 문제
// ex) [50, 23, 29, 1, 45, 39, 59, 19, 15] -> 59
let arr : [Int] = [50, 23, 29, 1, 45, 39, 59, 19, 15]
arr.max() // 가장 큰 값 반환





/*:
 ---
 ### Answer
 ---
 */

print("\n---------- [ Answer ] ----------\n")

/*
 ["p", "u", "p", "p", "y"] 라는 배열에서 마지막 "p" 문자 하나만 삭제하기
 */

var puppy = ["p", "u", "p", "p", "y"]
if let lastIndexOfP = puppy.lastIndex(of: "p") {
  puppy.remove(at: lastIndexOfP)
}
puppy


/*
 정수 타입의 배열을 2개 선언하고 두 배열의 값 중 겹치는 숫자들로만 이루어진 배열 만들기
 ex) [1, 2, 4, 8, 9, 12, 13] , [2, 5, 6, 9, 13]  -->  [2, 9, 13]
 */

let firstArray = [1, 2, 4, 8, 9, 12, 13]
let secondArray = [2, 5, 6, 9, 13]

var result: [Int] = []
for i in firstArray {
  for j in secondArray {
    if i == j {
      result.append(j)
    }
  }
}

result



/*
 정수 타입의 배열을 선언하고 해당 배열 요소 중 가장 큰 값을 반환하는 함수 만들기
 ex) [50, 23, 29, 1, 45, 39, 59, 19, 15] -> 59
 */

// 1) Swift 에서 제공하는 기본 함수인 max() 를 이용하는 방법
var arr2 = [50, 23, 29, 1, 45, 39, 59, 19, 15]
arr2.max()


// 2) 두 수 중 높은 값을 반환하는 max 를 이용하거나, 3항 연산자를 이용하는 방법
func maximumValue(in list: [Int]) -> Int {
  var maxValue = Int.min
  for number in list {
    maxValue = max(maxValue, number)
    
    // 위 함수는 다음의 3항 연산자와 동일
    // maxValue = maxValue < number ? number : maxValue
  }
  return maxValue
}

maximumValue(in: [50, 23, 29, 1, 45, 39, 59, 19, 15])
maximumValue(in: [10, 20, 30, 80, 50, 40])
maximumValue(in: [-6, -5, -4, -3, -2, -1])



//: [Next](@next)
