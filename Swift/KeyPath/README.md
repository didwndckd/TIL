# KeyPath

> 키 경로

- 어떤 **프로퍼티의 위치** 참조
- 간접적으로 특정 타입의 어떤 값을 가리켜야 할지 미리 지정해두고 사용



## AnyKeyPath

> 모든 루트 유형에서 결과 값 유형까지 유형이 지워진 키 경로

[공식문서](https://developer.apple.com/documentation/swift/anykeypath)

- 키 경로 타입의 최상위 클래스

- Equatable, Hashable 프로토콜을 채택하고있어서 비교, `Dictionaty`의 `Key`값으로 사용이 가능함

- 타입 프로퍼티로 `rootType: Any.Type`, `valueType: Any.Type`이 있으나 사용하려 하면 메서드를 반드시 override 해야한다며 `Fatal Error` 발생

  ![AnyKeyPath.rootValue](assets/AnyKeyPath.rootValue.png)

  - 유형이 지워진 키 경로라는 말이 이뜻인듯?

- `_AppendKeyPath` 프로토콜을 채택하여 `appending(path: AnyKeyPath) -> AnyKeyPath?` 함수를 사용하여 `KeyPath` 추가 가능

  - 내부적으로 프로토콜 확장을 통해 타입별로 `KeyPath` 추가 함수를 구현하고 있음

- 사용

  - 키 경로는 역슬래시(\\)와 타입, 마침표(.) 경로로 구성됨

    `\타입이름.경로.경로.경로`

    ``` swift
    // String타입의 count 프로퍼티 경로
    let anyKeyPath: AnyKeyPath = \String.count
    
    let str = "Joong Chang Yang"
    
    // AnyKeyPath를 사용하여 접근하게되면 Any? 타입으로 나옴
    let count = str[keyPath: anyKeyPath] 
    print("count: \(count)")
    
    /*
    출력 결과
    count: Optional(16)
    */
    ```
  
    

## PartialKeyPath\<Root\>

> 구체적 루트 유형에서 결과값 유형까지 부분적으로 유형이 지워진 키 경로

[공식문서](https://developer.apple.com/documentation/swift/partialkeypath)

- `AnyKeyPath` 클래스를 상속받음

- 루트 타입을 명시 하기에 타입 프로퍼티 `rootType: AnyType`을 사용하면 값이 나올줄 알았는데  `AnyKeyPath`와 같이 `Fatal Error` 발생함

- 사용

  - 사용 방법은 `AnyKeyPath`와 동일하다

    ```swift
    // Root 타입이 명시되어있어 String 하위 경로만 사용 가능
    let anyKeyPath: PartialKeyPath<String> = \String.count 
    
    let str = "Joong Chang Yang"
    
    // AnyKeyPath와는 달리 Root 타입 정보가 명시되어있어서 해당하는 하위 경로가 있다는걸 보장 하기에 Any 타입이 나옴
    let count = str[keyPath: anyKeyPath] 
    print("count: \(count)")
    
    /*
    출력 결과
    count: 16
    */
    ```

