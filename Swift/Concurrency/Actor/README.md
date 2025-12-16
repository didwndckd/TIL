# Actor

## Actor란?

Actor는 **동시성 환경에서 안전하게 사용할 수 있는 참조 타입**이다. 컴파일러가 두 개 이상의 코드가 동시에 actor의 데이터에 접근하는 것을 원천적으로 차단한다.

## 주요 특징

- `actor` 키워드로 생성
- **참조 타입** (class처럼 상태 공유에 유용)
- 프로퍼티, 메서드, 이니셜라이저, 서브스크립트 지원
- 프로토콜 준수 가능, 제네릭 지원
- **상속 불가** → `convenience init`, `final`, `override` 사용 불가
- 모든 actor는 자동으로 `Actor` 프로토콜 준수

## 외부에서 접근 시 await 필요

Actor 외부에서 가변 프로퍼티를 읽거나 메서드를 호출할 때는 반드시 `await`를 사용해야 한다.

```swift
actor User {
    var score = 10

    func printScore() {
        print("My score is \(score)")  // 내부 접근: await 불필요
    }

    func copyScore(from other: User) async {
        score = await other.score  // 다른 actor 접근: await 필요
    }
}

let user = User()
print(await user.score)  // 외부 접근: await 필요
```

## 동작 원리

- Actor는 내부적으로 **메시지 큐(inbox)** 를 운영
- 요청을 순서대로 하나씩 처리 (task priority로 우선순위 조정 가능)
- 한 번에 하나의 코드만 가변 상태에 접근 가능 → **Actor Isolation**
- 상수(`let`) 프로퍼티는 `await` 없이 접근 가능
- 외부에서 프로퍼티 **쓰기는 불가** (`await` 여부와 무관)

## 왜 필요한가?

- **특정 객체에 대한 접근을 한 번에 하나의 task로 제한**해야 할 때 유용
- 예: UI 작업(메인 스레드), 데이터베이스 접근(SwiftData의 model actor)
- **Data Race 방지**: 동시 접근으로 인한 예측 불가능한 결과를 원천 차단

## 참고

- Actor 함수는 **재진입(reentrant)** 가능 → 하나의 task가 실행 중일 때 다른 task가 시작될 수 있음
- Actor 인스턴스 생성 비용은 class와 동일
- 보호된 상태 접근 시에만 task 일시 중단이 발생할 수 있음

## 사용 예시

### 기본 사용법

1. `actor` 키워드로 타입 생성
2. 외부에서 프로퍼티/메서드 접근 시 `await` 사용

```swift
actor AuthenticationManager {
    // Actor 내부의 가변 상태 - 외부에서 직접 접근 불가
    var token: String?

    // 연산 프로퍼티도 actor isolation 적용
    var isAuthenticated: Bool {
        token != nil
    }

    // 네트워크 요청을 통한 인증 처리
    func authenticate(username: String, password: String) async throws {
        let url = URL(string: "https://example.com/auth")!
        // async 작업 수행 - actor 내부에서 await 사용 가능
        let (data, _) = try await URLSession.shared.data(from: url)
        // actor 내부에서 자신의 프로퍼티 수정 - await 불필요
        token = String(decoding: data, as: UTF8.self)
    }
}

// Actor 인스턴스 생성 - class와 동일한 비용
let manager = AuthenticationManager()

// 첫 번째 Task: 로그인 시도
Task {
    // actor의 메서드 호출 - await 필요
    try await manager.authenticate(username: "user", password: "pass")
    // actor의 프로퍼티 읽기 - await 필요
    if let token = await manager.token {
        print("Token: \(token)")
    }
}

// 두 번째 Task: 인증 상태 확인 (동시에 실행되어도 안전)
Task {
    // 연산 프로퍼티 접근도 await 필요
    let authenticated = await manager.isAuthenticated
    print("Authenticated: \(authenticated)")
}
```

### Data Race 문제 해결 예시

**Class 사용 시 문제점 (Data Race 발생 가능)**

```swift
class BankAccount {
    var balance: Decimal

    func transfer(amount: Decimal, to other: BankAccount) {
        // 문제 1: 잔액 확인과 차감 사이에 다른 스레드가 끼어들 수 있음
        guard balance >= amount else { return }
        // 문제 2: 여러 스레드가 동시에 이 줄을 실행할 수 있음
        balance = balance - amount
        // 문제 3: other도 동시에 접근될 수 있음
        other.deposit(amount: amount)
    }
}
```

두 개의 `transfer()` 호출이 동시에 실행되면:
1. 첫 번째 호출: 잔액 확인 → 충분함
2. 두 번째 호출: 잔액 확인 → 아직 충분함 (첫 번째가 아직 차감 안 함)
3. 둘 다 차감 실행 → **마이너스 잔액 발생!**

**Actor로 해결**

```swift
actor BankAccount {
    // Actor가 보호하는 가변 상태
    var balance: Decimal

    init(initialBalance: Decimal) {
        balance = initialBalance
    }

    // 내부 메서드 - 자신의 balance 접근 시 await 불필요
    func deposit(amount: Decimal) {
        balance = balance + amount
    }

    // 다른 actor와 상호작용하므로 async 필요
    func transfer(amount: Decimal, to other: BankAccount) async {
        // Actor isolation: 이 검사와 차감이 원자적으로 실행됨
        guard balance > amount else { return }
        balance = balance - amount
        // 다른 actor의 메서드 호출 - await 필요
        // other의 메시지 큐에 요청이 들어감
        await other.deposit(amount: amount)
    }
}

// Actor 인스턴스 생성
let first = BankAccount(initialBalance: 500)
let second = BankAccount(initialBalance: 0)

// Actor의 메서드 호출 - await 필요
await first.transfer(amount: 500, to: second)
```

Actor를 사용하면 한 번에 하나의 요청만 처리되므로 Data Race가 원천 차단된다.

## Actor 초기화

Actor는 자체 executor에서 실행되지만, **초기화 중에는 executor가 아직 준비되지 않은 상태**이다.

### async 이니셜라이저의 특징

- 모든 프로퍼티가 초기화되면 자동으로 actor의 executor로 전환됨
- 초기화 전후로 **다른 스레드에서 실행될 수 있음** (암시적 actor hop 발생)

```swift
actor Actor {
    var name: String

    // async 이니셜라이저
    init(name: String) async {
        // 이 시점: actor executor 준비 안 됨 (임의의 스레드)
        print(name)

        // 프로퍼티 초기화 완료
        self.name = name

        // 이 시점: actor executor로 전환됨 (다른 스레드일 수 있음)
        print(name)
    }
}

// async init 호출 - await 필요
let actor = await Actor(name: "Meryl")
```

> 두 `print()` 호출이 서로 다른 스레드에서 실행될 수 있다.

## Executor

**Executor**는 actor의 코드가 실행되는 **실행 컨텍스트**이다.

### 개념

- 각 actor 인스턴스는 자체 **serial executor**를 가짐
- Serial executor는 작업을 **한 번에 하나씩** 순차적으로 실행
- `DispatchQueue`와 유사하지만, 우선순위 기반 스케줄링 지원 (FIFO가 아님)

### 기본 동작

```swift
actor Counter {
    var count = 0

    // 이 메서드는 Counter의 executor에서 실행됨
    func increment() {
        count += 1
    }
}
```

- 일반 actor: Swift 런타임이 제공하는 기본 executor 사용
- `@MainActor`: 메인 스레드의 executor 사용
- Custom executor: `SerialExecutor` 프로토콜 구현으로 직접 정의 가능 (SE-0392)

## Actor Hop

**Actor hop**은 실행 컨텍스트가 한 actor에서 다른 actor로 전환되는 것을 의미한다.

### 발생 시점

```swift
actor ActorA {
    func doWork() async {
        // ActorA의 executor에서 실행 중

        let b = ActorB()
        await b.process()  // Actor hop 발생! → ActorB의 executor로 전환

        // 다시 ActorA의 executor로 복귀
        print("Back to A")
    }
}

actor ActorB {
    func process() {
        // ActorB의 executor에서 실행
        print("Processing in B")
    }
}
```

### 특징

- `await` 키워드가 있는 곳에서 hop이 발생할 수 있음
- Hop은 **suspension point** (일시 중단 지점)
- Hop 전후로 actor의 상태가 변경되었을 수 있음 → **재진입(reentrancy)** 주의

### 성능 고려사항

- Actor hop에는 컨텍스트 스위칭 비용이 발생
- 동일 actor 내에서는 hop 없이 직접 호출 가능
- 빈번한 hop은 성능에 영향을 줄 수 있음

## isolated 파라미터

`isolated` 키워드를 사용하면 **외부 함수를 특정 actor에 격리**시킬 수 있다. 이를 통해 actor 내부처럼 `await` 없이 프로퍼티에 직접 접근 가능하다.

### 사용법

```swift
actor DataStore {
    var username = "Anonymous"
    var friends = [String]()
    var highScores = [Int]()
    var favorites = Set<Int>()

    init() {
        // 데이터 로드
    }

    func save() {
        // 데이터 저장
    }
}

// isolated 키워드로 함수를 actor에 격리
func debugLog(dataStore: isolated DataStore) {
    // await 없이 직접 접근 가능!
    print("Username: \(dataStore.username)")
    print("Friends: \(dataStore.friends)")
    print("High scores: \(dataStore.highScores)")
    print("Favorites: \(dataStore.favorites)")

    // 쓰기도 가능
    dataStore.username = "NewName"
}

let data = DataStore()
// 함수 자체가 actor에서 실행되므로 await 필요
await debugLog(dataStore: data)
```

### 특징

- 함수 전체가 해당 actor의 executor에서 실행됨
- Actor의 안전성은 그대로 유지됨 (한 번에 하나의 스레드만 접근)
- `async`로 선언하지 않아도 호출 시 `await` 필요
- 함수 전체가 하나의 suspension point가 됨 (개별 접근이 아닌)
- **두 개의 isolated 파라미터는 불가** → 어떤 actor에서 실행할지 모호해짐

### 일반 함수 vs isolated 함수

```swift
// 일반 함수: 각 접근마다 await 필요
func normalLog(dataStore: DataStore) async {
    print(await dataStore.username)  // await 필요
    print(await dataStore.friends)   // await 필요
}

// isolated 함수: await 없이 직접 접근
func isolatedLog(dataStore: isolated DataStore) {
    print(dataStore.username)  // await 불필요
    print(dataStore.friends)   // await 불필요
}
```

## nonisolated

`nonisolated` 키워드를 사용하면 actor의 메서드나 연산 프로퍼티를 **격리에서 제외**할 수 있다. 이를 통해 외부에서 `await` 없이 호출 가능하다.

### 사용법

```swift
import CryptoKit
import Foundation

actor User {
    // 상수 프로퍼티 - 기본적으로 외부 접근 허용
    let username: String
    let password: String

    // 가변 프로퍼티 - 격리됨
    var isOnline = false

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }

    // nonisolated 메서드 - 외부에서 await 없이 호출 가능
    nonisolated func passwordHash() -> String {
        // 상수 프로퍼티(password)만 접근 가능
        let passwordData = Data(password.utf8)
        let hash = SHA256.hash(data: passwordData)
        return hash.compactMap { String(format: "%02x", $0) }.joined()
    }
}

let user = User(username: "twostraws", password: "s3kr1t")
// await 없이 직접 호출!
print(user.passwordHash())
```

### 규칙

- `nonisolated` 메서드/연산 프로퍼티는 **다른 nonisolated 멤버만 접근 가능**
- 상수(`let`) 프로퍼티는 기본적으로 nonisolated처럼 동작
- **저장 프로퍼티에는 nonisolated 사용 불가** (연산 프로퍼티만 가능)
- 격리된 상태에 접근하려면 `await` 사용 필요

### 연산 프로퍼티에 적용

```swift
actor User {
    let firstName: String
    let lastName: String

    // nonisolated 연산 프로퍼티
    nonisolated var fullName: String {
        // 상수 프로퍼티만 접근
        "\(firstName) \(lastName)"
    }
}

let user = User(firstName: "Paul", lastName: "Hudson")
print(user.fullName)  // await 불필요
```

### 주의사항

- `Codable`, `Equatable` 등 동기 프로토콜 준수 시에는 도움이 안 됨
- 격리된 상태가 필요한 프로토콜 메서드는 여전히 문제가 될 수 있음

## 참조 문서

- [SE-0306: Actors](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0306-actors.md) - Actor 기본 제안서
- [SE-0327: Actor Initializers](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0327-actor-initializers.md) - Actor 초기화 관련
- [SE-0392: Custom Actor Executors](https://forums.swift.org/t/accepted-se-0392-custom-actor-executors/64817) - Custom Executor 제안서
