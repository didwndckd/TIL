# Opaque Types

> 불투명 타입

- **불투명 타입(Opaque Type) **는 구체적인 타입을 숨기고 해당 타입이 채택하고 있는 프로토콜 관점에서 함수의 반환값이나 프로퍼티를 사용하게 함
- 반환값의 기본 타입이 비공개로 유지되어 모듈과 모듈을 호출하는 코드 사이의 경계에서 타입 정보를 숨기는 것이 유용함
- 프로토콜 타입을 반환하는것과 달리 불투명 타입은 타입 정체성을 보존함(컴파일러는 타입 정보에 접근이 가능하지만 모듈의 클라이언트는 접근 불가) 
- `some` 키워드는 리턴 타입을 자동으로 그리고 빠르게 추론할 수 있는 스위치 기능
- 이를 통해 유연하고 간결한 코드를 작성할 수 있다
- Swift5.1의 새로운 기능임



### 참조

- https://bbiguduk.gitbook.io/swift/language-guide-1/opaque-types#the-problem-that-opaque-types-solve
- https://jcsoohwancho.github.io/2019-08-24-Opaque-Type-%EC%82%B4%ED%8E%B4%EB%B3%B4%EA%B8%B0/
- https://github.com/apple/swift-evolution/blob/main/proposals/0244-opaque-result-types.md
