import Foundation

/*
 제네릭
 컴파일 단계에서 강력한 타입을 지정
 */
func addition<T: Numeric>(_ lhs: T, _ rhs: T) -> T {
    return lhs + rhs
}

let resultA = addition(1, 2) // Int
print(resultA) // 3
let resultB = addition(1.12, 2.3) // Double
print(resultB) // 3.42

/*
 some
 불투명 타입
 */
protocol Node {
    associatedtype Data
    var data: Data { get }
    var description: String { get }
}

struct IntNode: Node {
    let data: Int
    
    var description: String {
        return String(self.data) + " description"
    }
}

struct DoubleNode: Node {
    let data: Double
    
    var description: String {
        return String(self.data) + " description"
    }
}

// error!! Node 프로토콜 내부에 associatedtype이 있어서 나오는 타입을 정확히 알 수 없기에 에러
//func createNode(data: Int) -> Node {
//    return IntNode(data: data)
//}

// some 키워드로 내부 associatedtype은 가려져있지만 가능
func createNode(data: Int) -> some Node {
    return IntNode(data: data)
}

let node = createNode(data: 12)
let data = node.data
print(node.data) // 12
print(node.description) // 12 description


/*
 불투명 타입
 */

protocol Shape {
    func draw() -> String
}

struct Triangle: Shape {
    var size: Int
    
    func draw() -> String {
        var result: [String] = []
        for length in 1...self.size {
            result.append(String(repeating: "*", count: length))
        }
        return result.joined(separator: "\n")
    }
}

let smallTriangle = Triangle(size: 3)
print("smallTriangle")
print(smallTriangle.draw())

struct FlippedShape<T: Shape>: Shape {
    var shape: T
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}

let flippedTriangle = FlippedShape(shape: smallTriangle)
print("flippedTriangle")
print(flippedTriangle.draw())

struct JoinedShape<T: Shape, U: Shape>: Shape {
    var top: T
    var bottom: U
    func draw() -> String {
        return top.draw() + "\n" + bottom.draw()
    }
}

let joinedTriangles = JoinedShape(top: smallTriangle, bottom: flippedTriangle)
print("joinedTriangles")
print(joinedTriangles.draw())

struct Square: Shape {
    var size: Int
    func draw() -> String {
        let line = String(repeating: "*", count: self.size)
        let result = Array<String>(repeating: line, count: size)
        return result.joined(separator: "\n")
    }
}

// 사다리꼴
func makeTrapezoid() -> some Shape {
    let top = Triangle(size: 2)
    let middle = Square(size: 2)
    let bottom = FlippedShape(shape: top)
    let trapezoid = JoinedShape(top: top,
                                bottom: JoinedShape(top: middle, bottom: bottom))
    return trapezoid
}

let trapezoid = makeTrapezoid()
print("trapezoid")
print(trapezoid.draw())


// 제네릭 + some
func flip<T: Shape>(_ shape: T) -> some Shape {
    return FlippedShape(shape: shape)
}

func join<T: Shape, U: Shape>(_ top: T, _ bottom: U) -> some Shape {
    return JoinedShape(top: top, bottom: bottom)
}

let opaqueJoinedTriangles = join(smallTriangle, flip(smallTriangle))
print("opaqueJoinedTriangles")
print(opaqueJoinedTriangles.draw())

// 반환 타입은 단일이어야 함
//func invalidFlip<T: Shape>(_ shape: T) -> some Shape { // Error: Function declares an opaque return type 'some Shape', but the return statements in its body do not have matching underlying types
//    if shape is Square {
//        return shape
//    }
//    return FlippedShape(shape: shape)
//}

func `repeat`<T: Shape>(shape: T, count: Int) -> some Collection {
    return Array<T>(repeating: shape, count: count)
}

print("repeat")
print(`repeat`(shape: smallTriangle, count: 3))


//func protoFlip<T: Shape>(_ shape: T) -> Shape {
//    return FlippedShape(shape: shape)
//}

func protoFlip<T: Shape>(_ shape: T) -> Shape {
    if shape is Square {
        return shape
    }
    return FlippedShape(shape: shape)
}

print("protoFlip smallTriangle")
print(protoFlip(smallTriangle).draw())

print("protoFlip Square")
print(protoFlip(Square(size: 4)).draw())


//let protoFlippedTriangle = protoFlip(smallTriangle)
//let sameThing = protoFlip(smallTriangle)
//protoFlippedTriangle == sameThing // Error

protocol Container {
    associatedtype Item
    var count: Int { get }
    subscript(i: Int) -> Item { get }
}

extension Array: Container {}

//func makeProtocolContainer<T>(item: T) -> Container { // Error: Use of protocol 'Container' as a type must be written 'any Container'
//    return [item]
//}

//func makeProtocolContainer<T, C: Container>(item: T) -> C { // Error: Cannot convert return expression of type '[T]' to return type 'C'
//    return [item]
//}

func makeOpaqueContainer<T>(item: T) -> some Container {
    return [item]
}

let opaqueContainer = makeOpaqueContainer(item: 12)
let twelve = opaqueContainer[0]
print(type(of: twelve))

func foo<T: Equatable>(_ x: T, _ y: T) -> some Equatable {
    let condition = x == y // OK, x와 y는 같은 타입
    return condition ? 1738 : 679
}

let x = foo("apples", "bananas")
//let x = foo("apples", "apples")
let y = foo("apples", "some fruit nobody's ever heard of")
//let y = foo(1, 2) // 이거 쓰면 아래 에러: Binary operator '==' cannot be applied to operands of type 'some Equatable' (result of 'foo') and 'some Equatable' (result of 'foo')
print(x == y) // OK, x와 y는 같은 Opaque Type

protocol WrappedPrize {
    associatedtype Prize
    
    var wrapColor: String! { get } // 포장 색상
    var prize: Prize! { get } // 실제 상품
}

protocol Gundam {}
protocol Pokemon {}

struct WrappedGundam: WrappedPrize {
    var wrapColor: String!
    var prize: Gundam! // ! 붙이니까 되네?
}

struct WrappedPokemon: WrappedPrize {
    var wrapColor: String!
    var prize: Pokemon!
}

protocol GenericProtocol: Equatable {
    init()
}

struct GenericStruct: GenericProtocol {
    init() {}
}

struct GenericStruct2: GenericProtocol {
    init() {}
}

func generic<T: GenericProtocol>() -> T {
    return T.init()
}

let g1: GenericStruct = generic()
let g2: GenericStruct2 = generic()

//func reverseGeneric() -> <T: GenericProtocol> T {
//    return GenericStruct()
//}

func reverseGeneric() -> some GenericProtocol {
    return GenericStruct()
}

func reverseGeneric2() -> some GenericProtocol {
    return GenericStruct()
}

// 불투명 타입 반환 결과는 호출된 함수 정보도 가지고있는듯 ...
//let rg1 = reverseGeneric()
//let rg2 = reverseGeneric2()
//let rgResult = rg1 == rg2

func makeMeACollection<T>(with: T) -> some RangeReplaceableCollection & MutableCollection {
    return [with]
}

var c = makeMeACollection(with: 17)
c.append(c.first!)// ok RangeReplaceableCollection
c[c.startIndex] = c.first! // ok MutableCollection
print(c.reversed()) // ok Collection/Sequance


func foo<C: Collection>(_ c : C) {
    print(c)
}

foo(c)

var cc = [c]
cc.append(c)
var c2 = makeMeACollection(with: 38)
cc.append(c2)
var d = makeMeACollection(with: "seventeen")
//c = d // Error: Cannot assign value of type 'some MutableCollection & RangeReplaceableCollection' (result of 'makeMeACollection(with:)') to type 'some MutableCollection & RangeReplaceableCollection' (result of 'makeMeACollection(with:)')

func foo() -> some BinaryInteger {
    return 219
}

var fooResult = foo()
let i = 912
//fooResult = i // Error: Cannot assign value of type 'Int' to type 'some BinaryInteger'

if let x = foo() as? Int {
    print("It's an Int, \(x)")
} else {
    print("Guessed wrong")
}

func a() -> any Collection {
    return [1]
}

protocol P {}
extension Int: P {}
extension String: P {}

func f1() -> some P {
    return "opaque"
}

func f2(i: Int) -> some P {
    if i > 10 { return i }
    return 0
}

//func f2(flip: Bool) -> some P { // Error: Function declares an opaque return type 'some P', but the return statements in its body do not have matching underlying types
//    if flip { return 17 }
//    return "a string"
//}

//func f3() -> some P {
//    return 3.1419 // Error: Return type of global function 'f3()' requires that 'Double' conform to 'P'
//}

//func f4() -> some P {
//    let p: P = "hello"
//    return p // Error: Type 'any P' cannot conform to 'P'
//}

func f5() -> some P {
    return f1()
}

protocol Initializable {
    init()
}

func f6<T: P & Initializable>(_ : T.Type) -> some P {
    return T()
}

extension Int: Initializable {
    init() {
        self = 0
    }
}

print(f6(Int.self))

// 불투명 타입을 반환하는 함수는 재귀 호출이 허용되지만 같은 구체 타입을 반환해야 함, 그리고 구체 타입 리턴은 하나는 있어야 함 그래야 어떤 타입을 반환하는지 아니까
func f7(_ i: Int) -> some P {
    if i == 0 {
        return f7(1)
    } else if i < 0 {
//        let result: Int = f7(-i) // Error: Cannot convert value of type 'some P' to specified type 'Int'
        let result = f7(-i)
        return result
    } else {
        return 0
    }
}

struct Wrapper<T: P>: P {
    var value: T
}

// 이 경우는 재귀로 만들어진 불투명 타입을 반환 할 수 없음 무한 재귀 호출이라서 그런듯
func f8(_ i: Int) -> some P {
//    return Wrapper(value: f8(i + 1)) // Error: Function opaque return type was inferred as 'Wrapper<some P>', which defines the opaque type in terms of itself
    return Wrapper(value: f7(i)) // 이건 가능
}


// 불투명 타입 반환 함수는 무조건 리턴 해줘야 함 구체 타입 반환 함수는 fatalError 반환 가능함
func f9() -> some P {
    return 1
//    fatalError("not implemented") // Error: Return type of global function 'f9()' requires that 'Never' conform to 'P'
}

func f9Int() -> Int {
    fatalError("error")
}

let delayF9 = { f9() }

// fatalError 는 Never 타입 반환이라 Never에 해당 불투명 타입을 채택시키면 fatalError 반환 가능 하지만 위 구체 타입 반환 함수에서의 fatalError와는 다름
extension Never: P {}
func f9b() -> some P {
    return fatalError("not implement")
}

// Properties and subscripts

// 불투명 타입은 프로퍼티로도 사용 가능
//struct GameObject {
//    var shape: some Shape {
//        return Triangle(size: 1)
//    }
//
////    var shape: some Shape = Triangle(size: 1)
//}

let strings: some Collection = ["hello", "world"]

public protocol P2 {
    mutating func flip()
}

//struct Impl: P {}
//
//struct Vender {
//    private var storage: [Impl] = []
//
//    var count: Int {
//        return self.storage.count
//    }
//
//    subscript(index: Int) -> some P {
//        get {
//            return self.storage[index]
//        }
//        set(newValue) {
//            self.storage[index] = newValue
//        }
//    }
//}

// Associated type inference

// 함수 결과로 불투명 타입 변수에 할당 할 수 있지만 타입의 이름을 지정 할 수 없다?
let vf1 = f1() // type of vf1 is the opaque result type of f1()

protocol GameObject {
    associatedtype ObjectShape: Shape
    var shape: ObjectShape { get }
}

struct Player: GameObject {
    var shape: some Shape {
        return Triangle(size: 1)
    }
}

let pos: Player.ObjectShape
pos = Player().shape // Player.ObjectShape
let pos2 = Player().shape // some Shape

//protocol P3 {
//    associatedtype A: P3
//    func foo<T: P3>(x: T) -> A
//}

//struct Foo: P3 {
//    func foo<T: P3>(x: T) -> some P3 {
//        return x
//    }
//}

// Detailed design

// Grammar of opaque result types
// some 키워드 뒤에 오는 타입은 의미상 클래스 또는 실존 유형 타입으로 제한됨 Any, AnyObject, 프로토콜, 클래스 등으로만 구성되어야 하고 & 사용 가능

// Restrictions on opaque result types

func f(flip: Bool) -> (some P)? {
    if flip {
        return 1
    } else {
//        return nil
        return 0
    }
}

let fResult = f(flip: true)


protocol Q {
    // 프로토콜 요구사항에는 불투명 타입을 사용할 수 없음
//    func f() -> some P // Error: some' type cannot be the return type of a protocol requirement; did you mean to add an associated type?
}

class C {
    func f() -> some P {
        return 0
    }
    
    func g() -> P {
        return "0"
    }
}

class D: C {
    // 불투명 타입을 반환하는 함수는 오버라이드 불가 부모 클래스와 같은 유형을 반환하도록 제한
//    override func f() -> some P { // Error: Method does not override any method from its superclass
//        return 2
//    }
    
    override func g() -> P {
        return 2
    }
}

// Uniqueness of opaque result types

func makeOpaque<T>(_ : T.Type) -> some Any {
    return 1
}

var xx = makeOpaque(Int.self)
//xx = makeOpaque(Double.self) // Error: Cannot assign value of type 'some Any' (result of 'makeOpaque') to type 'some Any' (result of 'makeOpaque')

extension Array where Element: Comparable {
    func opaqueSorted() -> some Sequence {
        return self.sorted()
    }
}

var xxx = [1, 2, 3].opaqueSorted()
//xxx = ["a", "b", "c"].opaqueSorted() // Error: Cannot convert value of type 'String' to expected element type 'Int'
xxx = [3, 4, 5].opaqueSorted()

// Opaque type aliases

//typealias LazyCompactMapCollection<Elements, ElementOfResult> -> <C: Collection> C where C.Element == ElementOfResult = LazyMapSequence<LazyFilterSequence<LazyMapSequence<Elements, ElementOfResult?>>,ElementOfResult>


import SwiftUI

//var body: HStack<TupleView<(Text, Text, Text)>> {
//    HStack {
//        Text("A")
//        Text("B")
//        Text("C")
//    }
//}

//var body: some View {
//    HStack {
//        Text("A")
//        Text("B")
//        Text("C")
//    }
//}

let hstack = HStack {
    Text("A")
    Text("B")
    Text("C")
}

protocol Test {
    associatedtype Item
    var item: Item { get }
}



struct FlippedShape2: Shape {
    var shape: Shape
    func draw() -> String {
        let lines = shape.draw().split(separator: "\n")
        return lines.reversed().joined(separator: "\n")
    }
}
let flippedTriangle2 = FlippedShape(shape: smallTriangle)
print(flippedTriangle2.draw())
