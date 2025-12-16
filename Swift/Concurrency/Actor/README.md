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

### Cooperative Thread Pool

Swift는 **cooperative thread pool**이라는 스레드 그룹을 관리한다.

- CPU 코어 수만큼 스레드 생성 → thread explosion 방지
- Actor는 어떤 스레드에서 실행되는지 신경 쓰지 않음
- 시스템 자원 균형을 위해 자동으로 스레드 간 이동

### Main Actor와 Cooperative Pool 간 Hop

**문제**: Main actor는 cooperative thread pool에 포함되지 않음

- Cooperative pool 내 hop: 빠름 (자동 처리)
- Main actor ↔ Cooperative pool hop: **context switch 발생** (성능 비용)

**문제가 되는 패턴**

```swift
actor NumberGenerator {
    var lastNumber = 1

    func getNext() -> Int {
        defer { lastNumber += 1 }
        return lastNumber
    }

    // @MainActor이므로 main actor에서 실행
    @MainActor func run() async {
        for _ in 1...100 {
            // getNext()는 cooperative pool에서 실행
            // 매 반복마다 main actor ↔ cooperative pool hop 발생!
            let nextNumber = await getNext()
            print("Loading \(nextNumber)")
        }
    }
}
```

**실제 앱에서의 예시**

```swift
// 데이터베이스 actor - cooperative pool에서 실행
actor Database {
    func loadUser(id: Int) -> User {
        User(id: id)
    }
}

// UI 업데이트를 위해 @MainActor - main actor에서 실행
@Observable @MainActor
class DataModel {
    var users = [User]()
    var database = Database()

    // 비효율적: 매 반복마다 actor hop 발생
    func loadUsers() async {
        for i in 1...100 {
            // main actor → cooperative pool → main actor (매번 반복)
            let user = await database.loadUser(id: i)
            users.append(user)
        }
    }
}
```

### 해결책: 배치 처리

**한 번의 hop으로 여러 작업을 처리**하면 context switch 횟수를 줄일 수 있다.

```swift
actor Database {
    // 여러 사용자를 한 번에 로드
    func loadUsers(ids: [Int]) -> [User] {
        ids.map(User.init)
    }
}

@Observable @MainActor
class DataModel {
    var users = [User]()
    var database = Database()

    // 효율적: 단 한 번의 hop
    func loadUsers() async {
        let ids = Array(1...100)

        // main actor → cooperative pool (1번)
        let newUsers = await database.loadUsers(ids: ids)

        // cooperative pool → main actor (1번)
        users.append(contentsOf: newUsers)
    }
}
```

> 배치 크기가 2만 되어도 context switch 횟수가 절반으로 줄어든다.

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

## @MainActor

`@MainActor`는 **메인 스레드에서 실행되는 global actor**이다. UI 업데이트가 항상 메인 스레드에서 실행되도록 보장한다.

### 타입에 적용

```swift
// @Observable 클래스에 적용
@Observable @MainActor
class AccountViewModel {
    // 모든 프로퍼티와 메서드가 메인 스레드에서 실행됨
    var username = "Anonymous"
    var isAuthenticated = false
}

// ObservableObject에 적용
@MainActor
class LegacyViewModel: ObservableObject {
    @Published var username = "Anonymous"
    @Published var isAuthenticated = false
}
```

### SwiftUI와의 관계

- **Xcode 16+**: `View`를 준수하는 모든 struct가 자동으로 main actor에서 실행
- 그러나 observable 클래스에는 여전히 `@MainActor` 명시 권장
- 특정 메서드를 main actor에서 제외하려면 `nonisolated` 사용

> Observable 객체에는 일반 `actor`가 아닌 `@MainActor`를 사용해야 함. UI 업데이트는 반드시 main actor에서 실행되어야 하기 때문.

### MainActor.run()

어디서든 메인 스레드에서 코드를 실행할 수 있다.

```swift
func couldBeAnywhere() async {
    // 메인 스레드에서 실행
    await MainActor.run {
        print("This is on the main actor.")
    }
}

// 값 반환도 가능
func fetchAndUpdate() async {
    let result = await MainActor.run {
        // UI 업데이트 로직
        return 42
    }
    print(result)
}
```

### Task에서 @MainActor 사용

동기 컨텍스트에서 main actor로 작업을 보낼 때 유용하다.

```swift
func couldBeAnywhere() {
    // 방법 1: MainActor.run() 사용
    Task {
        await MainActor.run {
            print("This is on the main actor.")
        }
    }

    // 방법 2: Task 클로저에 @MainActor 적용
    Task { @MainActor in
        print("This is on the main actor.")
    }

    // 다른 작업 계속 실행
}
```

### 실행 순서 주의

```swift
@MainActor @Observable
class ViewModel {
    func runTest() async {
        print("1")

        await MainActor.run {
            print("2")

            // Task는 다음 run loop까지 대기
            Task { @MainActor in
                print("3")
            }

            print("4")
        }

        print("5")
    }
}

let model = ViewModel()
await model.runTest()
// 출력: 1, 2, 4, 5, 3
```

- `MainActor.run()`: 이미 main actor면 **즉시 실행**
- `Task { @MainActor in }`: 항상 **다음 run loop까지 대기**

### 주의사항

- `@MainActor` 클래스의 메서드라도 내부에서 백그라운드 작업이 실행될 수 있음
  - 어디까지나 `Swift Concurrency`내에서 보장, `DispatchQueue` 사용시 적용 안됨

- 예: Face ID의 `evaluatePolicy()` 완료 핸들러는 백그라운드 스레드에서 호출됨
- 완전한 보호가 아니므로 필요시 명시적으로 `MainActor.run()` 사용

## 코드가 실행되는 Actor 결정

async 함수가 어떤 actor에서 실행될지는 **호출하는 쪽이 아닌 함수 자체가 결정**한다.

### 흔한 오해

```swift
Task { @MainActor in
    // 이 클로저의 동기 코드는 main actor에서 실행됨
    await downloadData()  // 하지만 이 함수는 어디서 실행될까?
}
```

`downloadData()`가 main actor에서 실행될 것이라고 생각할 수 있지만, 실제로는 **함수 정의에 따라 달라진다**.

### 함수 정의에 따른 실행 위치

```swift
// 경우 1: actor 지정 없음 → Swift가 자유롭게 선택 (대부분 백그라운드)
func downloadData() async {
    // main actor에서 실행되지 않을 가능성 높음
}

// 경우 2: @MainActor 명시 → 항상 main actor에서 실행
@MainActor
func downloadData() async {
    // 반드시 main actor에서 실행
}

// 경우 3: @MainActor 타입의 메서드 → 항상 main actor에서 실행
@MainActor
class DataFetcher {
    func downloadData() async {
        // 반드시 main actor에서 실행
    }
}
```

### @MainActor in의 실제 의미

```swift
Task { @MainActor in
    print("1 - main actor")       // main actor에서 실행
    await downloadData()           // downloadData() 정의에 따라 다름
    print("2 - main actor")       // main actor에서 실행
}
```

`@MainActor in`은 **클로저 본문의 동기 코드**만 main actor에서 실행하도록 보장한다. `await`로 호출하는 async 함수는 해당 함수의 정의에 따라 실행 위치가 결정된다.

### 핵심 규칙

> **async 함수는 호출 방식과 무관하게 자신이 실행될 위치를 스스로 결정한다.**

- `await`는 potential suspension point (잠재적 일시 중단 지점)
- suspension point에서 Swift는 실행을 필요한 곳으로 자유롭게 이동시킴
- 함수가 특정 actor에서 실행되길 원하면 **함수 정의에 명시**해야 함

## Global Actor Inference

Global actor inference는 특정 규칙에 따라 `@MainActor`가 **자동으로 추론**되는 기능이다.

> 💡**Swift 6 언어 모드에서는 비활성화됨**. Swift 5.5 ~ 5.10에서만 적용.

### 5가지 추론 규칙

#### 1. 클래스 상속

`@MainActor` 클래스를 상속하면 서브클래스도 자동으로 `@MainActor`.

```swift
@MainActor
class Parent { }

// Child도 자동으로 @MainActor
class Child: Parent { }
```

#### 2. 메서드 오버라이드

`@MainActor` 메서드를 오버라이드하면 해당 메서드도 자동으로 `@MainActor`.

```swift
class Parent {
    @MainActor func update() { }
}

class Child: Parent {
    // 자동으로 @MainActor
    override func update() { }
}
```

#### 3. Property Wrapper

`@MainActor`를 wrapped value에 적용하는 property wrapper 사용 시 해당 타입 전체가 `@MainActor`.

```swift
// SwiftUI의 @StateObject, @ObservedObject가 이에 해당
struct ContentView: View {
    @StateObject var viewModel = ViewModel()  // View 전체가 @MainActor
}
```

#### 4. 프로토콜의 @MainActor 메서드

프로토콜의 `@MainActor` 메서드를 구현할 때, **준수와 구현을 동시에** 하면 자동 추론.

```swift
protocol DataStoring {
    @MainActor func save()
}

// 준수와 구현을 동시에 → 자동 @MainActor
extension DataStore1: DataStoring {
    func save() { }  // 자동으로 @MainActor
}

// 준수와 구현을 분리 → 명시 필요
struct DataStore2: DataStoring { }

extension DataStore2 {
    @MainActor func save() { }  // 명시적으로 @MainActor 필요
}
```

#### 5. @MainActor 프로토콜 준수

`@MainActor` 프로토콜을 **타입 선언과 동시에** 준수하면 타입 전체가 `@MainActor`.

```swift
@MainActor protocol DataStoring {
    func save()
}

// 타입 선언과 동시에 준수 → 타입 전체가 @MainActor
struct DataStore1: DataStoring {
    func save() { }  // 타입 전체가 @MainActor
}

// 별도 extension에서 준수 → 메서드만 @MainActor
struct DataStore2 { }  // 이 타입은 @MainActor 아님

extension DataStore2: DataStoring {
    func save() { }  // 이 메서드만 @MainActor
}
```

### 왜 이런 구분이 있는가?

외부 라이브러리(Apple 타입 등)에 `@MainActor` 프로토콜 준수를 추가할 때, 해당 타입 전체를 `@MainActor`로 만들면 기존 동작이 깨질 수 있다. 따라서 **extension으로 준수를 추가하면 메서드만** `@MainActor`가 된다.

## 참조 문서

- [SE-0306: Actors](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0306-actors.md) - Actor 기본 제안서
- [SE-0327: Actor Initializers](https://github.com/swiftlang/swift-evolution/blob/main/proposals/0327-actor-initializers.md) - Actor 초기화 관련
- [SE-0392: Custom Actor Executors](https://forums.swift.org/t/accepted-se-0392-custom-actor-executors/64817) - Custom Executor 제안서
