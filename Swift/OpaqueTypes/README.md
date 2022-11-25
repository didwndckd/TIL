# Opaque Types

> 불투명 타입

- **불투명 타입(Opaque Types)**은 구체적인 타입을 숨기고 해당 타입이 채택하고 있는 프로토콜 관점에서 함수의 반환값이나 프로퍼티를 사용하게 함
- 반환값의 기본 타입이 비공개로 유지되어 모듈과 모듈을 호출하는 코드 사이의 경계에서 타입 정보를 숨기는 것이 유용함
- 프로토콜 타입을 반환하는것과 달리 불투명 타입은 **타입 정체성(ID)**을 보존함
  - 컴파일러는 타입 정보에 접근이 가능하지만 모듈의 클라이언트는 접근 불가
  - 불투명 타입은 하나의 구체적 타입만 참조함

- `some` 키워드는 리턴 타입을 자동으로 그리고 빠르게 추론할 수 있는 스위치 기능
- 이를 통해 유연하고 간결한 코드를 작성할 수 있다
- Swift5.1의 새로운 기능임



## 불투명한 타입이 해결하는 문제

예를 들어 ASCII 그림을 그리는 모듈을 작성했다고 가정하자. ASCII 그림을 그리는 타입은 `Shape` 프로토콜을 채택 한다. 그리고 `Shape` 프로토콜의 요구 사항은 ASCII 문자열을 반환하는 `draw() -> String` 함수이다. 

``` swift
protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    func draw() -> String {
        var result: [String] = []
        for length in 1...size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}
let smallTriangle = Triangle(size: 3)
print(smallTriangle.draw())
// *
// **
// ***
```

여기까지는 일반적인 프로토콜을 채택한 구조체이다. 하지만 어떤 `Shape`를 채택하는 타입을 받아서 `draw()` 함수를 통해 그것을 수직으로 뒤집는 타입이 있다고 가정했을 때 이 접근방식에는 정확한 제네릭 타입을 노출해야하는 제한이 있다.

- 사실 지금의 경우에는 제네릭을 쓰지 않고도 구현은 가능함 `Shape`가 `associatedtype`이나 `Self`를 사용하면 제네릭을 필수로 써야함

``` swift
struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}
let flippedTriangle = FlippedShape(shape: smallTriangle)
print(flippedTriangle.draw())
// ***
// **
// *
```

아래 코드처럼 두개의 모양을 수직으로 결합하는 타입 `JoinedShape<T: Shape, U: Shape>`을 정의하고 `FlippedShape`를 넣어 모양을 만든다고 가정하면 `JoinedShape<FlippedShape<Triangle>, Triangle>`와 같은 복잡한 타입을 생성하게된다.

``` swift
struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}
let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle) // JoinedShape<FlippedShape<Triangle>, Triangle>
print(joinedTriangles.draw())
// *
// **
// ***
// ***
// **
// *
```

위 코드의 경우 `JoinedShape` 타입의 내부 `T`, `U` 타입을 명시 해야하고 이는 모듈 내 공개되지않은 타입을 모듈 외부에 노출시킬 수 있다.

모듈 내부에서는 다양한 방법으로 같은 모양을 구현할 수 있으며 모듈 외부에서는 이러한 세부 구현 정보를 알 필요가 없다. 이를 알게된다는것은 정확한 반환 유형에 의존하게 된다는 의미이고 해당 모듈의 작성자가 추후에 내용을 변경하려는 경우 문제가 될 수 있음.



## 불투명 타입 반환

불투명 타입 반환은 제네릭과 반대라고 볼 수 있다. 제네릭은 호출자에 의해 타입이 정해지는 반면 불투명 타입은 내부 구현부에서 반환 타입이 정해진다.

그러니까 제네릭은 함수 내부에서 추상화된 타입을 사용하고 불투명 타입은 함수 회부에서 추상적인 타입을 사용하게된다.

아래 코드는 제네릭 사용의 예제이다. 이 함수의 반환 타입은 매개변수 `x`, `y`의 타입에 따라 반환 타입 `T`가 정해진다. 따라서 함수 내부에서 추상적인 타입이 사용되고, 외부에서 정확한 타입 지정이 이루어진다고 볼 수 있다.

``` swift
func max<T>(_ x: T, _ y: T) -> T where T: Comparable { ... }
```

불투명 타입 반환은 제네릭 타입 반환과 반대로 이루어진다 제네릭 타입 반환은 호출자에 의해 반환 타입이 정해지는 반면 불투명 타입 반환은 함수 내부에서 추상화된 방식으로 반환되는 타입을 정하게 된다.

아래 예제를 보면 `makeTrapezoid()` 함수는 정확한 타입을 노출하지않고 사다리꼴을 반환한다. `some Shape`로 반환 타입을 선언하고 내부에서 `Shape` 프로토콜을 준수하는 특정 구체적 타입의 값을 반환한다. 이렇게 구현하게 되면 현재 `makeTRapezoid()` 함수는 내부에 삼각형, 사각형, 뒤집힌 삼각형 등의 조합으로 이루어져있는데 모듈 외부에서는 함수의 구체적인 반환 타입에 의존적이지 않기때문에 추후 수정에 용이함

``` swift
struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(
        top: top,
        bottom: JoinedShape(top: middle, bottom: bottom)
    )
    return trapezoid
}
let trapezoid = makeTrapezoid()
print(trapezoid.draw())
// *
// **
// **
// **
// **
// *
```

불투명 반환 타입은 제네릭과 결합해 사용할 수 있음

``` swift
func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}
func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    JoinedShape(top: top, bottom: bottom)
}

let opaqueJoinedTriangles = join(smallTriangle, flip(smallTriangle))
print(opaqueJoinedTriangles.draw())
// *
// **
// ***
// ***
// **
// *
```



## 불투명 타입 반환 제약 조건

불투명 반환 타입을 가진 함수가 여러 위치에서 반환하는 경우 모든 반환 값은 동일한 타입을 반환해야 한다. 

아래 예제는 함수 내에서 조건에 따라 다른 타입을 반환 하는데 이는 불투명 타입 반환 제약 조건에 부합하지 않음

``` swift
// Error: Function declares an opaque return type 'some Shape', but the return statements in its body do not have matching underlying types
func invalidFlip<T: Shape>(_ shape: T) -> some Shape {
    if shape is Square {
        return shape
    }
    return FlippedShape(shape: shape)
}
```

항상 단일 타입을 반환해야 한다고 해서 불투명 타입 반환에 제네릭 사용을 막지는 않는다. 다음 예제에서는 매개변수 타입에 따라 다른 타입을 반환 하지만 호출 할 때마다 항상 `[T]` 타입을 반환 하는것은 똑같기에 단일 타입을 반환한다는 제약 조건은 성립한다.

``` swift
func `repeat`<T: Shape>(shape: T, count: Int) -> some Collection {
    return Array<T>(repeating: shape, count: count)
}
```



## 불투명 타입과 프로토콜의 차이점

불투명 타입을 반환하는 것과 프로토콜 타입을 반환하는것의 차이는 **타입 정체성**을 유지하느냐 안하느냐의 차이에 있다. 사실 불투명 타입 반환에서 단일 타입을 반환해야 하는 이유도 여기에 있다. **타입 정체성**을 보장해야 하기에 단일 타입을 반환해야 하는것이다.

불투명 타입은 하나의 특정 타입을 참조하지만 함수 호출자는 어떤 타입인지 볼 수 없고 프로토콜 타입은 프로토콜을 준수하는 모든 타입을 참조할 수 있다. 일반적으로 프로토콜 타입은 저장하는 값의 **기본 타입에 대해 더 많은 유연성을 제공**하고 불투명 타입은 **기본 타입에 대해 더 강력한 보증**을 할 수 있다.

### 프로토콜

프로토콜 타입을 반환하는것은 타입 정체성을 지우고 유연성을 제공한다. 아래 코드를 보면 불투명 타입과 달리 `Shape` 프로토콜을 채택한 타입은 뭐든 반환 가능하다.

``` swift
func protoFlip<T: Shape>(_ shape: T) -> Shape {
    if shape is Square {
        return shape
    }

    return FlippedShape(shape: shape)
}
```

위 함수는 구체적 타입이 아닌 프로토콜 타입으로 반환하기에 구체적 타입에 대한 정보를 알 수 없다. 그 예로 비교 연산자를 사용할 수 없음. `Shape`가 `Equatable` 프로토콜을 채택하고있더라도 문제는 `Equatable`은 내부에 `Self`를 사용하기때문에 위의 `protoFlip(_:)` 함수에서 `Shape` 타입으로의 반환이 불가능하다.

``` swift
let protoFlippedTriangle = protoFlip(smallTriangle)
let sameThing = protoFlip(smallTriangle)
protoFlippedTriangle == sameThing  // Error: Binary operator '==' cannot be applied to two 'any Shape' operands
```



### 불투명 타입

불투명 타입은 타입 정체성을 유지하고 기본 타입에 대해 더 강력한 보증을 한다. 아래 `Container` 프로토콜은 내부에 `Item`이라는 연관 타입을 사용한다.

``` swift
protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}
extension Array: Container { }
```

`associatedtype`을 사용하는 프로토콜은 함수의 반환 타입으로 사용할 수 없다.

``` swift
// Error: Use of protocol 'Container' as a type must be written 'any Container'
func makeProtocolContainer<T>(item: T) -> Container {
    return [item]
}

// Error: Cannot convert return expression of type '[T]' to return type 'C'
func makeProtocolContainer<T, C: Container>(item: T) -> C {
    return [item]
}
```

하지만 반환 타입으로 `some Container`를 사용하면 가능하며 여기서 `twelve`의 타입은 `Int`로 유추되고 이는 불투명 타입이 타입 추론이 동작한다는 것을 보여준다.

``` swift
func makeOpaqueContainer<T>(item: T) -> some Container {
    return [item]
}
let opaqueContainer = makeOpaqueContainer(item: 12)
let twelve = opaqueContainer[0]
print(type(of: twelve)) // "Int"
```

만약 불투명 타입이 연관 타입을 노출하고 있다면 이 연관 타입에 대한 정보도 유지한다. 아래 `x`와 `y`는 같은 `String` 타입을 인자로 넣은 `foo(_:, _:)` 함수를 호출하여 반환 받은 `some Equatable` 타입이기 때문에 같은 타입임을 보장하고 그에 따라 비교가 가능하다. 하지만 `stringResult`와 `intResult`는 서로 다른 타입을 인자로 넣은 함수 호출 결과이기에 같은 타입임을 보장하지않는다. 때문에 비교가 불가능하다.

``` swift
func foo<T: Equatable>(x: T, y: T) -> some Equatable {
  let condition = x == y
  return condition ? 1738 : 679
}

let x = foo("apples", "bananas")
let y = foo("apples", "some fruit nobody's ever heard of")

print(x == y) // true

let stringResult = foo(x: "A", y: "B")
let intResult = foo(x: 1, y: 2)
print(stringResult == intResult) // Error : Binary operator '==' cannot be applied to operands of type 'some Equatable' (result of 'ContentView.foo(x:y:)') and 'some Equatable' (result of 'ContentView.foo(x:y:)')
```



### 참조

- https://bbiguduk.gitbook.io/swift/language-guide-1/opaque-types

- https://github.com/apple/swift-evolution/blob/main/proposals/0244-opaque-result-types.md

- https://jcsoohwancho.github.io/2019-08-24-Opaque-Type-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0/

- https://protocorn93.github.io/2019/12/12/Opaque-Types-in-Swift/

  
