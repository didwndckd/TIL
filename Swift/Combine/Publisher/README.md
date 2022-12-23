# Publisher

`Publisher`는 하나 이상의 `Subscriber` 인스턴스에 값을 전달 할 수 있는 프로토콜이다.

``` swift
public protocol Publisher<Output, Failure> {
    associatedtype Output
    associatedtype Failure : Error

    func receive<S>(subscriber: S) where S : Subscriber, Self.Failure == S.Failure, Self.Output == S.Input
}
```

- `Output` : `Subscriber`에게 전달될 데이터 타입
- `Failure` : `Subscriber`에게 전달될 실패 타입, `Error`를 채택하고 있어야 함
- `receive(subscriber:)` : `Subscriber`를 전달받아 구독을 수락하는 함수
  - `Publisher` 를 구독하게되면 `receive(subscriber:)` 함수가 호출되고 내부에서 `Subscriber`와의 연결이 시작됨



## Publisher를 채택하는 타입

> `Publisher` 프로토콜을 채택하는 만들어져있는 타입

### Just

- `Just`는 구독이 시작되면 저장된 값을 방출하는 단순한 퍼블리셔이다
- 에러 타입은 항상  `Never`타입이다

``` swift
Just(1)
    .sink(
        receiveCompletion: { completion in
        print("completion: \(completion)")
    }, receiveValue: { value in
        print(value)
    })

// 1
// completion: finished
```



