# Publisher

`Publisher`는 하나 이상의 `Subscriber` 인스턴스에 값을 전달 할 수 있는 프로토콜이다.

``` swift
public protocol Publisher<Output, Failure> {
    associatedtype Output
    associatedtype Failure : Error

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}
```

## 제약 조건

- `Output` : `Subscriber`에게 전달될 데이터 타입
- `Failure` : `Subscriber`에게 전달될 실패 타입, `Error`를 채택하고 있어야 함
- `receive(subscriber:)` : `Subscriber`를 전달받아 구독을 수락하는 함수

## 추가 설명

- `Publisher` 를 구독하게되면 `receive(subscriber:)` 함수가 호출되고 내부에서 `Subscriber`와의 연결이 시작됨
- 애플에서 미리 정의해놓은 `Publisher`들이 있음
  - `Deferred`, `Empty`, `Fail`, `Future`, `Just`, `Record`등
- `Publisher`의 확장 기능으로 이벤트 처리 체인을 만들기 위해 구성하는 다양한 연산자들이 정의되어있다.
  - 대부분 `Publishers`의 확장으로 정의되어있음.