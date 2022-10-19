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
