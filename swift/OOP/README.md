# class


## 클래스의 기본 정의


```swift
/*
 Value Type => struct, enum  (Stack 에 저장)
 Reference Type => class  (Heap 에 저장)
 */
// code , data, stack, heap

/*
 let x = 5  // stack -> 해당값이 그대로 저장
 let y = User()  //  -> stack에 값이 들어있는 힙의 주소 위치를 포인터로 저장 // heap에 실제 데이터 저장
 let z = User()  //  -> User의 데이터 사이즈에 따라 저장되는 크기도 다르다
 
         x   y        z
 [Stack] | 5 | 0x5F17 | 0x2C90 |
 
        0x2C90          0x5F16     0x5F17
 [Heap] | z's user data | SomeData | y's user data |
 
 --- in Memory ---
 값 타입(Value Type) - Stack
 참조 타입(Reference Type) - Stack -> Heap
 */


/*
 class <#ClassName#>: <#SuperClassName#>, <#ProtocolName...#> {
   <#PropertyList#>
   <#MethodList#>
 }
 
 let <#objectName#> = <#ClassName()#>
 objectName.<#propertyName#>
 objectName.<#functionName()#>
 */


class Dog {
  var color = "White"
  var eyeColor = "Black"
  var height = 30.0
  var weight = 6.0
  
  func sit() {
    print("sit")
  }
  func layDown() {
    print("layDown")
  }
  func shake() {
    print("shake")

  }
}


let bobby: Dog = Dog()
bobby.color  // "White"
bobby.color = "Gray"
bobby.color // "Gray"
bobby.sit() // "sit"

let tory = Dog()
tory.color = "Brown"
tory.layDown() //"layDown"

```



## initialize(생성자)를 이용한 초기화

```swift

/*
 모든 저장 프로퍼티 (Stored Properties)에 초기값이 설정된 경우 Init 메서드 작성 불필요
 객체 생성시 단순히 ClassName() 만으로 생성 가능
 */

class Dog1 {
  let name = "Tory"
  let color = "Brown"
  
  func bowwow() {
    print("Dog1 Bowwow!")
  }
}

let tory = Dog1()
// let tory = Dog1.init()
tory.bowwow()



/*
 초기화 메서드가 필요한 경우 - 저장 프로퍼티 중 하나 이상이 초기값 미설정
 ==> init 메서드를 통해 설정
 */

// 파라미터 없는 경우

class Dog2 {
  let name: String
  let color: String
  
  init() {
    name = "Tory"
    color = "Brown"
  }
  
  func bowwow() {
    print("Dog2 Bowwow!")
  }
}

let tory2 = Dog2()
tory2.bowwow()




// 파라미터를 통해 설정하는 경우

class Dog3 {
  let name: String
  let color: String

  init(name: String) {
    self.name = name
    color = "Brown"
  }
  init(name: String, color: String) {
    self.name = name
    self.color = color
  }
  
  func bowwow() {
    print("Dog3 Bowwow!")
  }
}

var tory3 = Dog3(name: "Tory")
var tory4 = Dog3(name: "Tory", color: "White")

tory3.name//"Tory"
tory3.color//"Brown"

tory4.name  //"Tory"
tory4.color //"White"

```


##Property

### Stored Property 
- class O | Structre O | Enumeration X


```swift
class StoredProperty {
  var width = 0.0
  var height = 0.0
}

let stored = StoredProperty()
stored.width = 123
stored.height = 456
stored.width  //123
stored.height	 // 456	
```


### Lazy Stored Property

- 초기값이 인스턴스의 생성이 완료 될 때까지도 알 수 없는 외부 요인에 의존 할 때
- 초기값이 복잡하거나 계산 비용이 많이 드는 설정을 필요로 할 때
- 필요한 경우가 제한적일 때
- class O | Structure O | Enumeration X

```swift
class BasicStoredProperty {
  var width = 10.0
  var height = 20.0
  
  var area = 200.0
//  var area = self.width * self.height // 초기화가 끝나지 않은 상태에서는 self를 사용할 수 없다
}

let basicStored = BasicStoredProperty()
basicStored.area
basicStored.width = 30
basicStored.area



class LazyStoredProperty {
  var width = 10.0
  var height = 20.0
  
  // 1. 외부 요인이나 다른 설정에 기반
//  var area = self.width * self.height  //
  lazy var area = width * height    // lazy 가 붙은 경우 area변수가 최초 호출이 될때 정의된다 (지연생성)
  
  // 2. 계산 비용이 많이 드는 상황 당장 필요하지 않은 작업인데 사용자를 기다리게 할 이유가 없다
//  var hardWork = "실행하면 약 10초 이상 걸려야 하는 작업"
  
  // 3. 필요한 경우가 제한적인 상황
//  func ifStatement() {
//    if true {   // 10%
//      print(area)
//    } else {    // 90%
//      print(width)
//    }
//  }
}

let lazyStored = LazyStoredProperty()
lazyStored.width = 30
lazyStored.area


// 순서 주의 : 최초 호출할 때 정의하고나서 따로 값을 바꿔주지 않으면 따로 바뀌지 않는다
let lazyStored1 = LazyStoredProperty()
lazyStored1.area //200
lazyStored1.width = 30
lazyStored1.area //200

```


### Computed Property

- 자료를 저장하지 않고 매번 호출할 때 마다 새로 계산
- class O | Structure O | Enumeration O

```swift
/*
  var <#variable name#>: <#type#> {
      get {
          <#statements#>
      }
      set {
          <#variable name#> = newValue
      }
  }
 */


print("\n---------- [ Computed Property ] ----------\n")

class ComputedProperty {
  var width = 5.0
  var height = 5.0
  
  lazy var lazyArea = width * height
  var area: Double {
    return width * height
  }
  
  // Stored + Computed get(read), set(write)
  private var _koreanWon = 0.0
  var wonToDollar: Double {
    get {
      return _koreanWon / 1136.5
    }
    set {
      _koreanWon = newValue
    }
  }
}

var computed = ComputedProperty()
computed.area   //25
computed.lazyArea//25

computed.width = 10
computed.area       //50
computed.lazyArea //25

computed.lazyArea = 50.0
computed.lazyArea //50

computed.width = 20
computed.height = 20
computed.area       // 400
computed.lazyArea // 50

computed.wonToDollar // 0
computed.wonToDollar = 10000
computed.wonToDollar //8.7989441...


```

### Property Observer

- class O | Structure O | Enumeration O

```swift
/*
 var <#variable name#>: <#type#> = <#value#> {
     willSet {
         <#statements#>
     }
     didSet {
         <#statements#>
     }
 }
 */

print("\n---------- [ Property Observer ] ----------\n")

class PropertyObserver {
  var height = 0.0
  
  var width = 0.0 {
    willSet {// 값이 변경되기 직전에 호출 newValue -> 새로 들어올 값
      print("willSet :", width, "->", newValue)
    }
    didSet {// 값이 변경된 후에 호출 oldValue -> 바뀌기 전 값
      print("didSet :", oldValue, "->", width)
      height = width / 2
    }
  }
}

var obs = PropertyObserver()
obs.height = 456
obs.width = 123
obs.height //61.5
```

### Type Property

- Shared
- Lazily Initialized
- class O | Structure O | Enumeration O

```swift
/*
 선언 - static let(var) <#propertyName#>: <#Type#>
       class var <#propertyName#>: <#Type#> { return <#code#> }
 사용 - <#TypeName#>.<#propertyName#>
 
 static: override 불가
 class: 클래스에서만 사용 가능하고 computed property 형태로 사용. 서브클래스에서 override 가능
 */

print("\n---------- [ Type Property ] ----------\n")

class TypeProperty {
  static var unit: String = "cm"
  var width = 5.0
}

let square = TypeProperty()
square.width // 5

let square1 = TypeProperty()
square1.width = 10.0
square1.width //10

TypeProperty.unit
print("\(square.width) \(TypeProperty.unit)") // 5.0
print("\(square1.width) \(TypeProperty.unit)") // 10.0

TypeProperty.unit = "m"
print("\(square.width) \(TypeProperty.unit)") // 5.0
print("\(square1.width) \(TypeProperty.unit)") // 10.0


```
















