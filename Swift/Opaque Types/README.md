# Opaque Types

> 불투명 타입

- **불투명 타입(Opaque Types) **는 구체적인 타입을 숨기고 해당 타입이 채택하고 있는 프로토콜 관점에서 함수의 반환값이나 프로퍼티를 사용하게 함
- 반환값의 기본 타입이 비공개로 유지되어 모듈과 모듈을 호출하는 코드 사이의 경계에서 타입 정보를 숨기는 것이 유용함
- 프로토콜 타입을 반환하는것과 달리 불투명 타입은 타입 정체성**(ID)**을 보존함
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

- 사실 지금의 경우에는 제네릭을 쓰지 않고도 구현은 가능함 `Shape`가 `associatedtype`을 가지면 제네릭을 필수로 써야함

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

아래 예제를 보면 `makeTrapezoid()` 함수는 정확한 타입을 노출하지않고 사다리꼴을 반환한다.

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





### 참조

- https://bbiguduk.gitbook.io/swift/language-guide-1/opaque-types

- https://github.com/apple/swift-evolution/blob/main/proposals/0244-opaque-result-types.md

- https://jcsoohwancho.github.io/2019-08-24-Opaque-Type-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0/

  
