# KVC

> Key-Value-Coding

- 객체의 값을 **직접** 가져오지않고, Key 또는 `KeyPath`를 이용하여 **간접적으로** 데이터를 가져오거나 수정하는 방법
- Swift에서는 `KeyPath`를 사용함
  - 어떤 **프로퍼티의 위치** 참조
  - 루트 위치부터 경로로 찾아감 `\Root.path.path`
  - 간접적으로 특정 타입의 어떤 값을 가리켜야 할지 미리 지정해두고 사용




## AnyKeyPath

> 모든 루트 유형에서 결과 값 유형까지 유형이 지워진 키 경로

[공식문서](https://developer.apple.com/documentation/swift/anykeypath)

- 키 경로 타입의 최상위 클래스

- Equatable, Hashable 프로토콜을 채택하고있어서 비교, `Dictionaty`의 `Key`값으로 사용이 가능함

- 타입 프로퍼티로 `rootType: Any.Type`, `valueType: Any.Type`이 있으나 접근하려 하면 메서드를 반드시 override 해야한다며 `Fatal Error` 발생

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
    
    let str = "Yang Jungchang"
    
    // AnyKeyPath를 사용하여 접근하게되면 Any? 타입으로 나옴
    let count = str[keyPath: anyKeyPath] 
    print("count: \(count)")
    
    /*
    출력 결과
    count: Optional(14)
    */
    ```
  
    

## PartialKeyPath\<Root\>

> 구체적 루트 유형에서 결과값 유형까지 부분적으로 유형이 지워진 키 경로

[공식문서](https://developer.apple.com/documentation/swift/partialkeypath)

- `AnyKeyPath` 클래스를 상속

- Root 타입은 명시를 하고 Value 타입은 명시하지 않기에 Root 빼고 지워져 있다는듯...

- Root 타입을 명시 하기에 타입 프로퍼티 `rootType: Any.Type`에 접근하면 값이 나올줄 알았는데  `AnyKeyPath`와 같이 `Fatal Error` 발생 (왜일까...)

- 사용

  ```swift
  // Root 타입이 명시되어있어 String 하위 경로만 사용 가능
  let anyKeyPath: PartialKeyPath<String> = \String.count 
  
  let str = "Yang Jungchang"
  
  // AnyKeyPath와는 달리 Root 타입 정보가 명시되어있어서 해당하는 하위 경로가 있다는걸 보장 하기에 Any 타입이 나옴
  let count = str[keyPath: anyKeyPath] 
  print("count: \(count)")
  
  /*
  출력 결과
  count: 14
  */
  ```



## KeyPath\<Root, Value\>

> 특정 루트 유형에서 특정 결과 값 유형까지의 키 경로

[공식문서](https://developer.apple.com/documentation/swift/keypath)

- `PartialKeyPath` 클래스 상속

- **Read-only** 

- Root 타입과 Value 타입을 명시 하며 타입 프로퍼티 `rootType: Any.Type`과 `valueType: Any.Type`에 접근해 타입 값을 가져올 수 있음

  ``` swift
  print("Root: \(KeyPath<String, Int>.rootType)")
  print("Value: \(KeyPath<String, Int>.valueType)")
  
  /*
  출력 결과
  Root: String
  Value: Int
  */
  ```

- 사용

  ```swift
  struct Person {
      let name: String
      let address: Address
  }
  
  struct Address {
      let town: String
  }
  
  // Root와 Value 타입이 명시되어있어 Person의 하위 프로퍼티이면서 String 타입의 프로퍼티만 할당 가능
  let nameKeyPath: KeyPath<Person, String> = \Person.name
  
  let yjc = Person(name: "Yang Jungchang", address: Address(town: "서울"))
  
  let name = yjc[keyPath: nameKeyPath]
  print("name: \(name)") // name: Yang Jungchang
  
  // 경로를 따라 Person -> address -> town 프로퍼티까지 접근
  // 해당 프로퍼티가 상수라서 KeyPath<Person, String>으로 타입 추론됨
  let townKeyPath = \Person.address.town
  
  let town = yjc[keyPath: townKeyPath]
  print("town: \(town)") // town: 서울
  
  ```

  

