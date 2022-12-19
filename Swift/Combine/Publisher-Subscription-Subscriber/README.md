# Combine basic (Publisher-Subscription-Subscriber)

> `Combine`기본 사용

`Combine` 프레임워크는 시간 경과에 따라 값을 처리하기 위한 선언적 Swift API를 제공한다. 이러한 값들은 많은 종류의 비동기 이벤트를 나타낼 수 있다.

`Combine`은  `Publisher`가 시간이 지남에 따라 변경될 수 있는 값을 노출하도록 선언하고 `Subscriber`가 `Publisher`로부터 해당 값을 수신하도록 선언한다.



## Publisher

`Publisher`는 하나 이상의 `Subscriber` 인스턴스에 값을 전달 할 수 있는 프로토콜

``` swift
public protocol Publisher<Output, Failure> {
    associatedtype Output
    associatedtype Failure : Error

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}
```

### 제약 조건

- `Output` : `Subscriber`에게 전달될 데이터 타입
- `Failure` : `Subscriber`에게 전달될 실패 타입, `Error`를 채택하고 있어야 함
- `receive(subscriber:)` : `Subscriber`를 전달받아 구독을 수락하는 함수

### 활용

- `Publisher` 를 구독하게되면 `receive(subscriber:)` 함수가 호출되고 내부에서 `Subscriber`와의 연결이 시작됨
- 애플에서 미리 정의해놓은 `Publisher`들이 있음
  - `Deferred`, `Empty`, `Fail`, `Future`, `Just`, `Record`등
- `Publisher`의 확장 기능으로 이벤트 처리 체인을 만들기 위해 구성하는 다양한 연산자들이 정의되어있다.
  - 대부분 `Publishers`의 확장으로 정의되어있음.

## Subscriber

## Subscription



