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

위 코드의 경우 



### 참조

- https://bbiguduk.gitbook.io/swift/language-guide-1/opaque-types

- https://github.com/apple/swift-evolution/blob/main/proposals/0244-opaque-result-types.md

- https://jcsoohwancho.github.io/2019-08-24-Opaque-Type-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0/

  
