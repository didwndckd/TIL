# Task

- 모든 비동기 함수는 명시적으로 요청하지 않더라도 Task의 일부로 실행된다.

## 🧵 Swift Concurrency: Tasks & TaskGroups 요약 정리

### 1. Tasks와 TaskGroups란?

#### ✔ Task
- 하나 또는 소수의 독립적인 작업을 즉시 실행할 때 사용.
- async/await 자체는 순차 실행 → **Task가 실제 동시성 제공**.
- 모든 async 함수는 내부적으로 Task 안에서 실행됨.
- `async let`은 Task를 생성하는 문법 설탕(sugar).

#### ✔ TaskGroup
- 하나의 큰 작업을 **여러 병렬 작업으로 분할**하고 싶을 때 사용.
- 동일 타입을 반환할 때 가장 간편.
- 타입이 달라도 가능하지만 추가 처리 필요.

---

### 2. Task 우선순위 (Priority)

- high → medium → low → background
- 중요한 작업이 덜 중요한 작업보다 먼저 CPU 점유.
- QoS 대응:
  - high ≈ userInitiated  
  - low ≈ utility
- 기존 userInteractive는 이제 UI 전용 (직접 사용할 수 없음).

---

### 3. Task 생성 및 실행

Task는 생성 즉시 실행되며 fire-and-forget 용도로도 사용 가능.

#### 📌 예시: 두 Task 동시 실행

``` swift
struct NewsItem: Decodable {
    let id: Int
    let title: String
    let url: URL
}

struct HighScore: Decodable {
    let name: String
    let score: Int
}

func fetchUpdates() async {
    print("function start")
    
    print("newsTask 생성")
    
    let newsTask = Task {
        // Task 생성 즉시 작업 시작
        print("newTask 시작")
        let url = URL(string: "https://hws.dev/headlines.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([NewsItem].self, from: data)
    }
    
    print("newsTask 생성 완료")

    
    print("highScoreTask 생성")
    
    let highScoreTask = Task {
        // Task 생성 즉시 작업 시작
        print("highScoreTask 시작")
        let url = URL(string: "https://hws.dev/scores.json")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([HighScore].self, from: data)
    }
    
    print("highScoreTask 생성 완료")

    print("Task await")
    do {
        let news = try await newsTask.value
        let highScores = try await highScoreTask.value
        print("Latest news loaded with \(news.count) items.")

        if let topScore = highScores.first {
            print("\(topScore.name) has the highest score with \(topScore.score), out of \(highScores.count) total results.")
        }
    } catch {
        print("There was an error loading user data.")
    }
    
    print("function end")
}

Task {
    await fetchUpdates()
}

/*
 function start
 newsTask 생성
 newTask 시작
 newsTask 생성 완료
 highScoreTask 생성
 highScoreTask 시작
 highScoreTask 생성 완료
 Task await
 Latest news loaded with 20 items.
 Sophie has the highest score with 497, out of 100 total results.
 function end
 */

```

---

### 4. SwiftUI에서 Task 활용

버튼 액션은 sync → async 호출하려면 Task 필요.

#### 📌 SwiftUI 예제

``` swift
struct Message: Decodable, Identifiable {
    let id: Int
    var from: String
    var text: String
}

struct ContentView: View {
    // @State는 어디서 실행 하든 메인 스레드에서 업데이트됨.
    @State private var messages = [Message]()

    var body: some View {
        NavigationStack {
            Group {
                if messages.isEmpty {
                    Button("Load Messages") {
                        // UI 동작은 메인 스레드에서 실행되기 때문에 Task도 메인에서 생성
                        Task {
                            await loadMessages()
                        }
                    }
                } else {
                    List(messages) { message in
                        VStack(alignment: .leading) {
                            Text(message.from)
                                .font(.headline)

                            Text(message.text)
                        }
                    }
                }
            }
            .navigationTitle("Inbox")
        }
    }

    // SwiftUI에 속한 비동기 함수 이므로 메인에서 실행, View가 @MainActor라서 그런듯?
    func loadMessages() async {
        do {
            let url = URL(string: "https://hws.dev/messages.json")!
            
            // UI가 멈추는것을 피하기 위해 자체 네트워킹 스레드에서 실행
            let (data, _) = try await URLSession.shared.data(from: url)
            // 메인 스레드로 돌아옴
          	
            messages = try JSONDecoder().decode([Message].self, from: data)
        } catch {
            messages = [
                Message(id: 0, from: "Failed to load inbox.", text: "Please try again later.")
            ]
        }
    }
}

```



## 🧵 Task vs Task.detached

### 1. 핵심 차이 요약

#### 🔸 Task
- 생성 즉시 실행
- **priority 상속**
- **task local values 상속**
- **actor context(격리) 상속**
- SwiftUI(MainActor)에서 UI 업데이트 가능
- 대부분의 상황에서 가장 권장되는 방식

#### 🔸 Task.detached
- 생성 즉시 실행
- **상속되는 정보 없음 (priority / task local / actor context 모두 ❌)**
- MainActor에서 벗어나므로 UI 업데이트 불가
- actor 내부 접근 시 `await self.xxx` 반드시 필요
- 병렬 성능은 뛰어나지만 사용해야 할 상황은 극히 제한적
- Swift 공식 문장: **“Task.detached most of the time should not be used at all.”**

---

### 2. Task vs Detached Task 상세 차이 표

| 구분                      | Task        | Task.detached         |
| ------------------------- | ----------- | --------------------- |
| 실행 시점                 | 즉시        | 즉시                  |
| Priority 상속             | ✔️           | ❌                     |
| Task Local Values 상속    | ✔️           | ❌                     |
| Actor Context 상속        | ✔️           | ❌                     |
| MainActor에서 UI 업데이트 | ✔️ 가능      | ❌ 불가                |
| Actor 메서드 접근         | 자연스러움  | 제한됨 (`await self`) |
| 병렬 실행 능력            | 보통        | 높음                  |
| 일반적 사용 권장          | 👍 거의 항상 | ⚠️ 최후의 수단         |

---

### 3. SwiftUI에서 Task는 가능하지만 Detached Task는 불가한 이유

#### ✔️ Task는 MainActor 컨텍스트를 상속 → UI 변경 안전

```swift
struct ContentView: View {
    @State private var name = "Anonymous"

    var body: some View {
        VStack {
            Text("Hello, \(name)!")

            Button("Authenticate") {
                // Task는 MainActor 상속 → UI 업데이트 안전
                Task {
                    name = "Taylor"   // ✅ 안전
                }
            }
        }
    }
}
```

#### ❌ Detached Task는 MainActor가 아님

``` swift
Button("Authenticate") {
    Task.detached {
        // 🚫 Detached Task는 MainActor가 아님
        // 🚫 @State 경고, [Main actor-isolated property 'name' can not be mutated from a nonisolated context]
        name = "Taylor"
    }
}
```

---

### 4. Actor 내부에서의 동작 차이

#### ✔️ Task는 actor 격리를 상속 → 동기 접근 가능

``` swift
actor User {
    func authenticate(user: String, password: String) -> Bool {
        // Actor 내부의 보호된 상태 접근
        return true
    }

    func login() {
        Task {
            // actor 컨텍스트 상속 → await 없이 접근 가능
            if authenticate(user: "tester", password: "pw123") {
                print("Logged in")   // 👍 정상 동작
            }
        }
    }
}
```

#### ❌ Detached Task는 actor 컨텍스트 없음 → 반드시 await 필요

``` swift
actor User {
    func authenticate(user: String, password: String) -> Bool {
        return true
    }

    func login() {
        Task.detached {
            // Detached는 actor에 고립되지 않음 → actor hop 필요
            if await self.authenticate(user: "tester", password: "pw123") {
                print("Logged in")   // ⚠️ 접근은 가능하지만 hop 발생
            }
        }
    }
}
```

---

### 5. Detached Task가 유용한 유일한 순간 — 병렬성 강제

#### ❌ 일반 Task는 SwiftUI(MainActor) 때문에 순차 실행됨

``` swift
func doWork() {
    Task {
        // MainActor → 순차 실행
        for i in 1...10_000 {
            print("In Task 1: \(i)")
        }
    }

    Task {
        for i in 1...10_000 {
            print("In Task 2: \(i)")
        }
    }
}
```

#### ✔️ Detached Task로 바꾸면 병렬로 섞여서 실행됨

``` swift
func doWork() {
    Task.detached {
        for i in 1...10_000 {
            print("In Task 1: \(i)") // 병렬 실행
        }
    }

    Task.detached {
        for i in 1...10_000 {
            print("In Task 2: \(i)") // Task 1과 섞여 출력
        }
    }
}
```

결론: **병렬 성능이 정말 필요하고 MainActor에 묶여 있는 상황에서만 Detached Task가 의미 있음.**

### 최종 결론 — 언제 무엇을 써야 할까?

- 🥇 가장 안전한 기본값 → Task
- 🥈 병렬 + 구조적 concurrency 유지 → async let
- 🥉 정말 어쩔 수 없을 때만 → Task.detached



## 💤 Task.sleep()

- 현재 **Task(작업)를 일정 시간 동안 일시 중단(suspend)** 시키는 기능.
- underlying thread(실제 스레드)는 막지 않음 → **스레드 블로킹 없음**.
- 즉, Task는 잠들어도 스레드는 다른 일을 처리할 수 있음.

---

### 기본 사용법

```swift
// 최소 3초 동안 현재 Task를 일시 중단
// 단, 실제로는 3초보다 약간 더 걸릴 수 있음(드리프트 있음)
// 작업이 취소되면 즉시 깨어나고 CancellationError를 throw
try await Task.sleep(for: .seconds(3))
```

---

### 오차 허용(tolerance) 사용

``` swift
// 최소 3초 동안 잠듦
// tolerance(허용 오차)를 추가하면 OS가 스케줄링 상황에 따라
// 최대 3초 + tolerance = 4초까지 잠들 수 있음
// → 시스템에 여유를 주어 성능 최적화에 도움
try await Task.sleep(for: .seconds(3), tolerance: .seconds(1))
```

---

### Task Cancellation 동작

#### 특징

- Task.sleep()은 **자동으로 Task 취소 여부를 체크**함.
- Task가 sleep 중일 때 task.cancel()이 호출되면:
  - 즉시 깨어남
  - CancellationError를 throw
  - catch 블록에서 처리할 수 있음

``` swift
let task = Task {
    do {
        print("Task will sleep now...")
        try await Task.sleep(for: .seconds(5))   // 5초 동안 잠듦
        print("Task completed normally.")        // 취소되지 않으면 실행
    } catch {
        // Task가 sleep 중 취소되면 여기로 옴
        print("Task was cancelled!")
    }
}

// 외부에서 Task 취소
Task {
    try await Task.sleep(for: .seconds(1))
    task.cancel()     // 1초 후 취소 → sleep 중 깨어나 catch 실행
}

/*
Task will sleep now...
Task was cancelled!
*/
```



## 🧾 Task에서 Result 얻는 방법

Task는 기본적으로 `await task.value` 로 성공 값을 얻지만, `task.result` 프로퍼티를 사용하면 **Result<Success, Failure>** 형태로 값을 받아 성공/실패를 하나의 값으로 다룰 수 있다.

- `await task.result` → Result 자체 읽기 (try 불필요)
- `result.get()` → 성공 값 추출 (이때 try 필요)
- 오류 타입은 `Error` 또는 `Never`

---

### 기본 예시 (Task 내부에서 오류 처리 후 Result 반환)

```swift
enum LoadError: Error {
    case fetchFailed, decodeFailed
}

func fetchQuotes() async {
    // 문자열을 다운로드하고 반환하는 Task 생성
    let downloadTask = Task {
        let url = URL(string: "https://hws.dev/quotes.txt")!

        do {
            // 네트워크 요청 (오류 가능 → try await 필요)
            let (data, _) = try await URLSession.shared.data(from: url)

            // UTF-8 문자열로 변환 시도
            if let string = String(data: data, encoding: .utf8) {
                return string // 성공 시 문자열 반환
            } else {
                // 문자열 변환 실패
                throw LoadError.decodeFailed
            }

        } catch {
            // 다운로드 실패 처리
            throw LoadError.fetchFailed
        }
    }

    // Task의 결과(Result<String, Error>) 가져오기 — await 필요, try는 필요 없음
    let result = await downloadTask.result

    // Result.get()으로 실제 성공 값 추출 (이때 오류 발생 가능 → try 필요)
    do {
        let string = try result.get()
        print(string)
    } catch LoadError.fetchFailed {
        print("Unable to fetch the quotes.")     // 다운로드 실패
    } catch LoadError.decodeFailed {
        print("Unable to convert quotes to text.") // 디코딩 실패
    } catch {
        print("Unknown error.") // 예측 불가능한 오류
    }
}

// INSIDE MAIN
await fetchQuotes()
```



## 🧵 Task 우선순위(priority) 제어 요약

### Task 우선순위란?
- Task는 `.high`, `.medium`, `.low`, `.background` 같은 우선순위를 가질 수 있음
- 우선순위를 지정하지 않으면 nil일 수도 있음
- OS가 어떤 Task를 먼저 실행할지 결정할 때 참고하지만 **절대적인 규칙은 아니고 “힌트” 수준**

---

### 우선순위를 가진 Task 생성 예시

```swift
func fetchData() async {
    // 우선순위를 .high로 지정해 Task 생성
    let downloadTask = Task(priority: .high) {
        let url = URL(string: "https://hws.dev/chapter.txt")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return String(decoding: data, as: UTF8.self)
    }

    do {
        let text = try await downloadTask.value
        print(text)
    } catch {
        print(error.localizedDescription)
    }
}

// INSIDE MAIN
await fetchData()
```

---

### 🧭 Task 우선순위 자동 결정 규칙

- Swift는 명시적인 우선순위가 없을 때 아래 3가지 규칙으로 자동 결정함:

- 자식 Task는 부모 Task의 우선순위를 상속함 (Task 내부에서 새로운 Task를 만들면 그대로 따라감)
  
- Main Thread에서 직접 생성된 Task는 자동으로 가장 높은 우선순위인 `.high`가 부여됨
  
- Task도 아니고 Main Thread도 아닌 환경에서 생성된 Task는 스레드의 우선순위를 조회하거나 우선순위가 `nil`이 됨
  
- 자동 우선순위는 대부분 상황에서 신뢰할 수 있으며 **명시적으로 지정하지 않는 것이 더 좋은 경우가 많음**

---

### 🎚️ 명시적으로 설정 가능한 Task 우선순위

- `.high`
  - 최우선 작업
  - GCD의 `.userInitiated`와 동일
  - 사용자가 직접 실행하고 즉시 결과를 기다리는 작업에 적합 (예: 버튼 눌렀을 때 바로 필요한 연산)
  
- `.medium`
  - 일반적인 작업에 적합
  - 사용자가 즉시 기다리지 않는 대부분의 작업에 사용

- `.low`
  - GCD의 `.utility` 수준
  - 시간이 오래 걸리지만 UI에 즉시 영향이 없는 작업 (예: 파일 복사, 데이터 가져오기 등)
  
- `.background`
  - 가장 낮은 우선순위
  - 사용자가 보지 않는 작업 (예: 검색 인덱스 구축, 백그라운드 캐싱)
  - 몇 시간 걸려도 문제 없는 작업
  
- 대부분의 상황에서는 **우선순위를 직접 설정하는 것보다** **자동 우선순위를 신뢰하는 것이 더 바람직함** (특히 UI 이벤트로 시작되는 Task는 자동으로 `.high`가 되므로 지정 필요 없음)

---

## ⚡ UI 액션에서 Task 생성 시 자동으로 높은 우선순위(.high) 할당됨

- SwiftUI의 버튼 액션이나 UI 이벤트는 **Main Thread(MainActor)** 에서 실행됨

- Main Thread에서 Task를 생성하면 우선순위를 지정하지 않아도 **자동으로 `.high`** 가 부여됨
  
- 이유:  
  - UI에서 발생한 작업은 **사용자가 즉시 기다리는 작업**으로 간주  
  - Swift가 UI 반응성을 높이기 위해 높은 우선순위를 자동 적용

- 따라서 일반적인 UI 이벤트에서는 **명시적으로 Task(priority:) 를 지정할 필요가 없음**
  
- 예: SwiftUI 버튼에서 Task 생성 시 자동으로 `.high` 우선순위

```swift
struct ContentView: View {
    @State private var jokeText = ""

    var body: some View {
        VStack {
            Text(jokeText)
            Button("Fetch new joke", action: fetchJoke)
        }
    }

    func fetchJoke() {
        // 버튼은 MainActor에서 실행됨
        // 따라서 이 Task는 별도 지정 없이 .high 우선순위를 가짐
        Task {
            let url = URL(string: "https://icanhazdadjoke.com")!
            var request = URLRequest(url: url)
            request.setValue("Swift Concurrency by Example", forHTTPHeaderField: "User-Agent")
            request.setValue("text/plain", forHTTPHeaderField: "Accept")

            let (data, _) = try await URLSession.shared.data(for: request)

            if let jokeString = String(data: data, encoding: .utf8) {
                jokeText = jokeString
            } else {
                jokeText = "Load failed."
            }
        }
    }
}
```

---

## 🎯 Task 현재 우선순위 확인 (Task.currentPriority)

- Swift는 `Task.currentPriority` 를 통해 현재 실행 중인 Task의 우선순위를 조회할 수 있음
  
- 어떤 Task 내부에서 호출하면:
  - 해당 Task가 가진 우선순위를 그대로 반환

- Task가 아닌 일반 함수에서 호출하면:
  - 시스템에게 현재 실행 스레드의 우선순위를 쿼리하거나
  - 적절한 정보가 없으면 기본값 **`.medium`** 반환

- 즉, Task 컨텍스트 안에서는 정확한 우선순위를 알 수 있고 Task 밖에서는 `.medium` 또는 시스템 기반 값이 제공됨



## 우선순위 상승(Priority Escalation)

- 모든 Task는 **명시적 우선순위**를 갖거나 **부모로부터 우선순위를 상속**받는다.
- 하지만 **특정 두 상황**에서 Swift는 Task의 우선순위를 자동으로 올려 더 빠르게 완료될 수 있도록 한다.
- 이를 **우선순위 상승(Priority Escalation)** 이라고 한다.

---

### ⚠️ 우선순위가 자동 상승하는 두 경우

#### 1. **높은 우선순위 Task가 낮은 우선순위 Task를 await 할 때**
- 예: High(.high) → Low(.low)를 await → **Low Task도 자동으로 .high로 상승**
  
- 즉, “중요한 작업이 덜 중요한 작업을 기다리는 상황” → 덜 중요하던 작업도 갑자기 중요해짐.

```swift
@main
struct App {
    static func main() async throws {
        // 높은 우선순위 Task
        let outerTask = Task(priority: .high) {
            print("Outer: \(Task.currentPriority)") // high

            // 내부의 낮은 우선순위 Task
            let innerTask = Task(priority: .low) {
                print("Inner: \(Task.currentPriority)") // 처음에는 low

                try await Task.sleep(for: .seconds(1))

                // 우선순위 상승 후 high 로 변경됨
                print("Inner: \(Task.currentPriority)")
            }

            // high 우선순위 Task가 low를 기다리기 시작 → 우선순위 상승 발생
            try await Task.sleep(for: .seconds(0.5))
            _ = try await innerTask.value
        }

        _ = try await outerTask.value
    }
}

/*
 Outer: TaskPriority.high
 Inner: TaskPriority.low
 Inner: TaskPriority.high
 */
```

---

### 2. 동일 Actor에서 낮은 우선순위 Task가 실행 중인데 높은 우선순위 Task가 큐잉될 때

#### 동작 설명
- Actor는 **한 번에 하나의 Task만 실행 가능**함.
- 이미 **low 우선순위 Task A**가 Actor에서 실행 중이고 **high 우선순위 Task B**가 같은 Actor에 큐잉되면:
  - Task A의 우선순위가 **Task B와 동일(.high)** 하게 상승하여 병목(jam)을 방지함.

---

#### 우선순위 상승이 발생하는 이유
- Swift는 **높은 우선순위 작업이 지연되지 않도록** 자동으로 조정함.  → 높은 우선순위 작업을 막고 있는 낮은 우선순위 작업도 함께 승격.
- 즉, **“중요한 작업을 위한 자동 최적화”**.

---

#### 개발자가 신경 쓸 필요가 없는 이유
- 대부분의 경우 우선순위 상승은 **Swift가 알아서 최적의 방식으로 처리**함.
- 따라서 우리가 우선순위를 직접 관리할 필요가 거의 없음.

---

#### 우선순위 상승 시 주의점 — `Task.currentPriority`
- Actor에서 실행 중인 **low Task가 high Task 때문에 승격**될 때:
  - 실제 실행 우선순위는 상승해도
  - `Task.currentPriority` 값은 **변하지 않을 수 있음**.
- 즉, Task 실행은 더 빠른데 **로그에서는 티가 나지 않을 수 있음**.

## How to Cancel a Task — Summary

Swift의 Task는 **협력적 취소(cooperative cancellation)** 모델을 사용한다.  
즉, 취소 요청을 보낼 수는 있지만 **Task가 스스로 취소 여부를 확인해야 멈춘다**.  
강제 종료를 막아 프로그램 상태가 망가지는 것을 방지하기 위한 설계이다.

---

### 1. Task 취소 관련 핵심 포인트 7가지

1. `task.cancel()` — 명시적 취소
   1. Task에 취소 요청을 보낸다.
2. `Task.isCancelled` — 취소 여부 확인
   1. Task 내부에서 현재 취소되었는지 확인하기 위한 Boolean 값.
3. `Task.checkCancellation()` — 취소 시 즉시 에러 throw
   1. Task가 취소된 경우 즉시 `CancellationError`를 던지고 종료.
   2. 취소되지 않았다면 아무 동작도 하지 않음.
4. Foundation API는 자동 취소 체크 수행
   1. 예: `URLSession.data(from:)`
   2. Task가 취소되면 자동으로 **URLError(.cancelled)** 등을 throw.
5. `Task.sleep()` 취소 시 즉시 깨어남
   1. sleep 중 Task가 취소되면 즉시 깨면서 `CancellationError`가 발생.
6. Task Group 내부에서 한 Task가 에러 → 나머지 Task 자동 취소
   1. 그룹 구조에서는 에러 발생 시 전체가 정리된다.
7. SwiftUI의 `.task` modifier는 View가 사라지면 자동 취소
   1. View lifecycle에 맞춰 Task도 자동 관리됨.
---

### 2. 예시

```swift
func getAverageTemperature() async {
    let fetchTask = Task {
        let url = URL(string: "https://hws.dev/readings.json")!
        
        // 여기는 암묵적 취소 지점 (URLSession이 자체 체크)
        let (data, _) = try await URLSession.shared.data(from: url)
        
      	// 명시적 취소 체크 지점
      	try Task.checkCancellation()
      	
	      // Task 스스로 취소 상태를 판단하여 직접 처리
				if Task.isCancelled { return 0.0 }
      
        let readings = try JSONDecoder().decode([Double].self, from: data)
        let sum = readings.reduce(0, +)
        return sum / Double(readings.count)
    }

    do {
        let result = try await fetchTask.value
        print("Average temperature: \(result)")
    } catch {
        print("Failed to get data.")
    }
}

await getAverageTemperature()
```



## 다음 볼거 How to voluntarily suspend a task