import UIKit




protocol LinkedListStack {
  var size: Int { get }     // 전체 개수
  var isEmpty: Bool { get } // 노드가 있는지 여부
  func push(node: Node)     // 데이터 삽입
  func pop() -> String?     // 데이터 추출
  func peek() -> String?    // 마지막 데이터 확인
}

final class Node {
    var value: String?
    var next: Node?
    var pre: Node?
    init(value: String? = nil) {
        self.value = value
    }
    
}

final class SingleLinkedList: LinkedListStack {
    
    var size: Int = 0 {
        didSet {
            isEmpty = head.next == nil ? true : false
        }
    }
    
    var isEmpty: Bool = true
    
    let head = Node()
    
    func push(node: Node) {
        
        
        var currentNode = head
        
        while let next = currentNode.next {
            currentNode = next
        }
        
        currentNode.next = node
        size += 1
        
        
    }
    
    func pop() -> String? {
        
        var currentNode = head
        
        while let next = currentNode.next?.next {
            currentNode = next
        }
        
        currentNode.next = nil
        
            size -= 1
        
        return currentNode.value ?? "empty"
            
        
    }
    
    func peek() -> String? {
        
        var currentNode = head
        
        while let next = currentNode.next {
            currentNode = next
        }
        
        return currentNode.value ?? "empty"
        
    }
}

let singleList = SingleLinkedList()

singleList.peek()
singleList.isEmpty

singleList.push(node: Node(value: "A"))
singleList.push(node: Node(value: "B"))
singleList.push(node: Node(value: "C"))
singleList.peek()
singleList.pop()
singleList.peek()
dump(singleList)

singleList.isEmpty


/***************************************************
class Node { }
- deinit 메서드 구현할 것
class DoubleLinkedList { }
- 다음의 프로퍼티와 메서드 구현
 [ 프로퍼티 ]
 // private
 private var head: Node?
 private weak var tail: Node?
 // internal
 var isEmpty: Bool - 노드 존재 여부
 var count: Int    - 노드 전체 개수
 var first: Node?  - 첫번째 노드 반환
 var last: Node?   - 마지막 노드 반환
 
 [ 메서드 ]
 scanValues()  - 현재 저장된 모든 노드의 값 출력
 removeAll()   - 모든 노드 제거
 removeNode(by value: String) -> Bool      - 밸류를 이용해 노드 제거 후 성공 여부
 removeNode(at index: Int) -> String?      - 인덱스를 이용해 노드 제거 후 삭제한 노드의 밸류 반환
 node(by value: String) -> Node?           - 지정한 값을 지닌 노드를 찾아 반환
 insert(node newNode: Node, at index: Int) - 특정 위치에 노드 삽입
 append(node: Node)                        - 마지막 부분에 노드 삽입
 ***************************************************/

protocol doubleLinckdListProtocol{
   func scanValues()
    func removeAll()
    func removeNode(by value: String) -> Bool
    func removeNode(at index: Int) -> String?
    func node(by value: String) -> Node?
    func insert(node newNode: Node, at index: Int)
    func append(node: Node)
}

class DoubleLinkedList: doubleLinckdListProtocol {
    
    private var head: Node?
    private weak var tail: Node?
    
    var isEmpty: Bool = true
    var count: Int = 0
    
    var first: Node?
    var last: Node?
    
    
    func scanValues() {
        <#code#>
    }
    
    func removeAll() {
        <#code#>
    }
    
    func removeNode(by value: String) -> Bool {
        <#code#>
    }
    
    func removeNode(at index: Int) -> String? {
        <#code#>
    }
    
    func node(by value: String) -> Node? {
        <#code#>
    }
    
    func insert(node newNode: Node, at index: Int) {
        <#code#>
    }
    
    func append(node: Node) {
        <#code#>
    }
    
                        
}











