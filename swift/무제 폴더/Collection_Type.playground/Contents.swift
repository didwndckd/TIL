import UIKit


// [ 실습 문제 ]
// <1>
// [보기] 철수 - apple, 영희 - banana, 진수 - grape, 미희 - strawberry
// 위 보기처럼 학생과 좋아하는 과일을 매칭시킨 정보를 Dictionary 형태로 만들고
// 스펠링에 'e'가 들어간 과일을 모두 찾아 그것과 매칭되는 학생 이름을 배열로 반환하는 함수

func returnStudent(alphabet :Character) -> Array<String> {
    let studentsFavoritFruit : Dictionary<String, String> = ["철수" : "apple", "영희" : "banana", "진수" : "grape" , "미희" : "strawberry"]
    var students : Array<String> = []
    for (key, value) in studentsFavoritFruit {
        for char in value {
            if char == alphabet {
                students.append(key)
                break
            }
        }
    }
        return students
}
returnStudent(alphabet: "b")


// <2>
// 임의의 정수 배열을 입력받았을 때 홀수는 배열의 앞부분, 짝수는 배열의 뒷부분에 위치하도록 구성된 새로운 배열을 반환하는 함수
// ex) [2, 8, 7, 1, 4, 3] -> [7, 1, 3, 2, 8, 4]

func reRage (array : Array<Int>) -> Array<Int> {
    var firstArray : Array<Int> = []
    var secondArray : Array<Int> = []
    for i in array {
        if i%2 != 0 {
            firstArray.append(i)
        }else {
            secondArray.append(i)
        }
    }
    
    
    return firstArray+secondArray
    
}
var result : Array<Int> = reRage(array: [2, 8, 7, 1, 4, 3])


// <3>
// 0 ~ 9 사이의 숫자가 들어있는 배열에서 각 숫자가 몇 개씩 있는지 출력하는 함수
// 입력 : [1, 3, 3, 3, 8]
// 결과 : "숫자 1 : 1개, 숫자 3 : 3개, 숫자 8 : 1개"

func howManyNumbers (array : Array<Int>) {

    var numbers : Dictionary<Int, Int> = Dictionary()
    
    for num in array {
        if numbers[num] == nil {
            numbers[num] = 1
        }else {
            numbers[num] = numbers[num]! + 1
        }
    }
    
    for (num , count) in numbers {
        print("\(num) -> \(count)")
    }

}

howManyNumbers(array: [1, 3, 3, 3, 8,8,8,8,8,8,8,8,8,8,8,8])





//[ 과제 ]
//- 자연수를 입력받아 원래 숫자를 반대 순서로 뒤집은 숫자를 반환하는 함수
//  ex) 123 -> 321 , 10293 -> 39201

func reverse (number : Int) -> Int {
    
    
    let num : String = String(number)
    var reverseNum : String = ""
    for char in num.reversed() {
        reverseNum = reverseNum+String(char)
    }

    return Int(reverseNum)!

}
reverse(number: 123456)


//- 100 ~ 900 사이의 숫자 중 하나를 입력받아 각 자리의 숫자가 모두 다른지 여부를 반환하는 함수
//  ex) true - 123, 310, 369   /  false - 100, 222, 770

print("----------------------------------------------------")
func queryDifferent ( num : Int) -> Bool {
    
    var arr : Array<Int> = []
    var number : Int = num
    while number > 0 {
        arr.append(number%10)
        number /= 10
    }
    
    var set : Set<Int> = []
    print(arr)
    for i in arr {
        let result : Bool = set.insert(i).inserted
        if !result {
            return false
        }
    }
    return true
        
}
var num = 123456712
print("입력값 \(num) 결과 \(queryDifferent(num: num))")

//[ 도전 과제 ]
//- 주어진 문자 배열에서 중복되지 않는 문자만을 뽑아내 배열로 반환해주는 함수
//  ex) ["a", "b", "c", "a", "e", "d", "c"]  ->  ["b", "e" ,"d"]

func onlyOneAlphbet (arr : Array<Character>) -> Array<Character> {
    
    var finalArray : Array<Character> = []
    
    for firstIndex in 0..<arr.count {
        
        var boolen : Bool = true
        
        for secondIndex in 0..<arr.count {
            if firstIndex == secondIndex {
                continue
            }
            
            if arr[firstIndex] == arr[secondIndex] {
                boolen = false
            }
        }
        if boolen {
            finalArray.append(arr[firstIndex])
        }
    }
    return finalArray
}

onlyOneAlphbet(arr: ["a", "b", "c", "a", "e", "d", "c", "b"])

//- 별도로 전달한 식육목 모식도 라는 자료를 보고 Dictionary 자료형에 맞도록 중첩형태로 데이터를 저장하고
//  + 해당 변수에서 표범 하위 분류를 찾아 사자와 호랑이를 출력하기

var animals : Dictionary<String, Dictionary<String, Array<String> > > = [:]

animals = [ "개과" :["개" : ["자칼", "늑대", "북미산 이리"],"여우" : ["아메리카 여우" , "유럽 여우"],],
            "고양이과" : ["고양이" : ["고양이","살쾡이"] , "표범" : ["사자", "호랑이"]] ]


print(animals["고양이과"]!["표범"]![0])
print(animals["고양이과"]!["표범"]![1])





