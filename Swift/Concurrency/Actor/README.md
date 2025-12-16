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
