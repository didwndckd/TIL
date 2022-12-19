# Combine basic (Publisher-Subscription-Subscriber)

> `Combine`기본 사용

`Combine` 프레임워크는 시간 경과에 따라 값을 처리하기 위한 선언적 Swift API를 제공한다. 이러한 값들은 많은 종류의 비동기 이벤트를 나타낼 수 있다.

`Combine`은  `Publisher`가 시간이 지남에 따라 변경될 수 있는 값을 노출하도록 선언하고 `Subscriber`가 `Publisher`로부터 해당 값을 수신하도록 선언한다.



## Publisher

- `Publisher`는 하나 이상의 `Subscriber` 인스턴스에 값을 전달 할 수 있다.
- `Input`, `Output: Error` 두개의 연관 타입(associated type)을 가지기에 `Publisher` 프로토콜을 채택하게되면 두 타입을 정의해 주어야 한다.
- `receive(subscriber:)` 함수를 구현하여 `Subscriber`를 accept 한다.

``` swift
public protocol Publisher<Output, Failure> {
    associatedtype Output
    associatedtype Failure : Error

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}
```



## Subscriber

## Subscription



