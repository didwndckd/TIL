# TaskGroup

## Task Group 생성과 태스크 추가 방법

### 1. Task Group 개념

- **Task Group**은 여러 개의 `Task`가 **함께 하나의 결과를 만들어내는 컨테이너**이다.
- 그룹 안의 각 `Task`는 **동일한 타입의 값을 반환**해야 한다.
  - 필요하다면 `enum` + 연관값(associated value)로 서로 다른 데이터를 감싸서 한 타입으로 만들 수 있다. (조금 번거롭지만 가능)
- TaskGroup 인스턴스를 직접 생성하지 않고,
  - **`withTaskGroup(of:_:)`**
  - 또는 에러를 바깥으로 전달하고 싶다면 **`withThrowingTaskGroup(of:_:)`**를 사용한다.

---

### 2. 기본 예제: 문자열 5개를 모아서 한 문장 만들기

```swift
func printMessage() async {
    // TaskGroup이 반환할 타입을 String으로 명시
    let string = await withTaskGroup(of: String.self) { group in
        // group 파라미터로 TaskGroup 인스턴스를 전달받음
        // 각 addTask는 String을 반환하는 child Task를 하나씩 추가
        group.addTask { "Hello" }
        group.addTask { "From" }
        group.addTask { "A" }
        group.addTask { "Task" }
        group.addTask { "Group" }

        var collected = [String]()

        // TaskGroup은 AsyncSequence를 준수하므로
        // for await를 사용해 child Task들의 결과를 순서대로(완료 순서 기준) 읽을 수 있음
        for await value in group {
            collected.append(value)
        }

        // 수집된 문자열들을 공백으로 이어 붙여 하나의 문장으로 반환
        return collected.joined(separator: " ")
    }

    // 예: "Hello From A Task Group" 또는 순서가 섞인 문자열이 출력될 수 있음
    print(string)
}

// INSIDE MAIN
await printMessage()
```

---

### 3. Swift 6.1 이후 변화 & Throwing TaskGroup

#### 3.1 Swift 6.1 부터의 타입 추론

- Swift 6.1 이후:
  - `withTaskGroup()` 호출 시 `of:` 파라미터를 생략할 수 있다.
  - **그룹에 처음 추가되는 child task의 반환 타입**을 기준으로 Swift가 타입을 추론한다.

예:

```swift
await withTaskGroup { group in
    // 첫 번째 child Task가 String을 반환하므로
    // 그룹 전체의 타입이 String으로 추론됨
    group.addTask { "Hello" }
    // ...
}
```

#### 3.2 에러를 던지는 Task가 필요할 때

- `withTaskGroup(of:_:)` 를 사용할 때 생성된 Task는 **그룹 바깥으로 에러를 던질 수 없다.**
- Task 내부에서 발생한 에러를 **외부에서 처리할 수 있도록 전달**하려면 → **`withThrowingTaskGroup(of:_:)`** 를 사용해야 한다.

---

### 4. 실전 예제: 여러 뉴스 피드를 병렬로 가져와 합치기

```swift
// 개별 뉴스 기사를 표현하는 모델
struct NewsStory: Decodable, Identifiable {
    let id: Int
    let title: String
    let strap: String
    let url: URL
}

// 뉴스 목록을 보여주는 SwiftUI 뷰
struct ContentView: View {
    @State private var stories = [NewsStory]()

    var body: some View {
        NavigationStack {
            List(stories) { story in
                VStack(alignment: .leading) {
                    Text(story.title)
                        .font(.headline)

                    Text(story.strap)
                }
            }
            .navigationTitle("Latest News")
        }
        // View가 나타날 때 비동기로 뉴스 로딩
        .task {
            await loadStories()
        }
    }

    // 여러 JSON 피드를 병렬로 가져와 하나의 배열로 합치는 함수
    func loadStories() async {
        do {
            // 에러를 외부로 전파해야 하므로 withThrowingTaskGroup 사용
            stories = try await withThrowingTaskGroup(of: [NewsStory].self) { group in
                // 1 ~ 5번까지 뉴스 JSON을 병렬로 가져올 Task를 반복문에서 추가
                for i in 1...5 {
                    group.addTask {
                        let url = URL(string: "https://hws.dev/news-\(i).json")!
                        // 네트워크 요청은 에러를 던질 수 있으므로 try/await 사용
                        let (data, _) = try await URLSession.shared.data(from: url)
                        // 각 Task는 [NewsStory]를 디코딩해서 반환
                        return try JSONDecoder().decode([NewsStory].self, from: data)
                    }
                }

                var allStories = [NewsStory]()

                // 그룹 안의 Task는 어떤 순서로든 완료될 수 있으므로
                // for try await 로 완료되는 순서대로 결과를 읽어와 하나의 배열로 합침
                for try await stories in group {
                    allStories.append(contentsOf: stories)
                }

                // id 기준 내림차순으로 정렬해
                // 항상 일관된 순서로 화면에 표시되도록 정제된 배열을 반환
                return allStories.sorted { $0.id > $1.id }
            }
        } catch {
            // 전체 TaskGroup 중 하나라도 실패하면 여기로 에러가 전파됨
            print("Failed to load stories")
        }
    }
}
```

---

### 5. TaskGroup의 완료 규칙과 “기다리는 방법” 3가지

- 공통 규칙:
  - Throwing/Non-Throwing에 상관없이 **그룹 안의 모든 child task가 완료되어야** `withTaskGroup` / `withThrowingTaskGroup` 이 반환된다.

#### 6.1 모든 Task를 개별적으로 await 하기

- 예: `for await value in group { ... }`, 또는 `for try await value in group { ... }`
- 장점:
  - **가장 명시적**이고 읽기 쉽다.
  - “Task를 만들어놓고 결과를 안 쓰는 건가?” 같은 의문을 줄여준다.

#### 6.2 `waitForAll()` 사용

- `group.waitForAll()` 을 호출하면,
  - 우리가 명시적으로 `await`하지 않은 Task들까지 **모두 완료될 때까지 기다려 준다.**
  - 이때 그 Task들의 **반환값은 버려진다.**

#### 6.3 아무 child task도 명시적으로 await 하지 않기 (암묵적 await)

- 우리가 개별 Task를 전혀 `await` 하지 않아도,
  - Swift는 **그룹이 끝나기 전에 모든 child task가 끝날 때까지 자동으로 기다린다.**
- 즉, 결과를 사용하지 않더라도 Task들은 끝까지 실행된다.

#### 6.4 실무에서 자주 쓰는 방식

- 세 가지 방법 중 **“각 Task를 명시적으로 await 하는 방식(6.1)”**을 가장 자주 사용하게 된다.
- 이유:
  - 코드 읽는 사람이 “이 Task는 왜 만들고 방치하지?” 같은 의문을 갖지 않게 해주고,
  - 흐름이 가장 분명하다.

---

### 7. 한 줄 정리

- `withTaskGroup` / `withThrowingTaskGroup` =
  - 여러 비동기 작업을 **한 번에 던져두고**, **완료되는 순서대로 결과를 모아서 하나의 결과로 만드는 도구**
- 실제 네트워크/파일 I/O, 여러 API 병렬 호출 같은 곳에서 **간단한 루프로 Task를 생성하고 합치는 패턴**을 만들 수 있다.



## Task Group 취소하는 방법 (How to Cancel a Task Group)

### 1. Task Group이 취소되는 3가지 경우

1. **부모 Task가 취소될 때**
   - TaskGroup의 부모 Task가 취소되면 그룹 전체가 취소됨

2. **`cancelAll()` 명시적 호출**
   - 그룹에서 `group.cancelAll()`을 직접 호출

3. **child Task 중 하나가 에러를 던질 때**
   - throwing task group에서 한 task가 에러를 던지면 나머지 모든 task가 암묵적으로 취소됨

---

### 2. cancelAll()의 동작 방식

#### ✔️ 핵심 특징

- Task Group 취소도 **협력적 취소(cooperative cancellation)**
- `cancelAll()`을 호출해도 child task들이 취소를 확인하지 않으면 계속 실행됨
- Task는 `Task.isCancelled` 또는 `Task.checkCancellation()`으로 취소 여부를 확인해야 함
- **이미 완료된 작업은 취소할 수 없음** — 취소는 "남은 작업"에만 적용됨

---

### 3. 예시: cancelAll()만 호출하는 경우

```swift
func printMessage() async {
    let result = await withThrowingTaskGroup(of: String.self) { group in
        group.addTask { "Testing" }
        group.addTask { "Group" }
        group.addTask { "Cancellation" }

        // 모든 Task를 생성한 직후 즉시 취소 요청
        group.cancelAll()

        var collected = [String]()

        do {
            for try await value in group {
                collected.append(value)
            }
        } catch {
            print(error.localizedDescription)
        }

        return collected.joined(separator: " ")
    }

    print(result)
}

// INSIDE MAIN
await printMessage()
```

**결과:**

- 세 개의 문자열이 모두 출력됨
- **이유:** Task들이 취소를 확인하지 않기 때문에 `cancelAll()`이 영향을 주지 못함

---

### 4. 예시: 취소를 실제로 확인하는 경우

```swift
func printMessage() async {
    let result = await withThrowingTaskGroup(of: String.self) { group in
        // 첫 번째 Task는 취소를 명시적으로 확인
        group.addTask {
            try Task.checkCancellation()  // 취소되었다면 여기서 CancellationError throw
            return "Testing"
        }

        group.addTask { "Group" }
        group.addTask { "Cancellation" }

        group.cancelAll()

        var collected = [String]()

        do {
            for try await value in group {
                collected.append(value)
            }
        } catch {
            print(error.localizedDescription)
        }

        return collected.joined(separator: " ")
    }

    print(result)
}

// INSIDE MAIN
await printMessage()
```

**가능한 결과:**

- "Cancellation" 단독
- "Group" 단독
- "Cancellation Group"
- "Group Cancellation"
- 빈 문자열

**이유:**

- 세 Task가 모두 즉시 시작됨 (병렬 실행 가능)
- `cancelAll()` 호출 시점에 이미 일부 Task가 실행 중일 수 있음
- 첫 번째로 완료되는 Task가 `checkCancellation()`을 호출하면 즉시 에러를 던지고 종료
- 다른 Task들이 먼저 완료되면 그 결과가 포함될 수 있음

---

### 5. 중요한 포인트 정리

1. **cancelAll()은 "남은 작업"만 취소**
   - 이미 완료된 작업은 되돌릴 수 없음

2. **취소는 협력적(cooperative)**
   - Task가 스스로 취소 상태를 확인해야 함
   - `Task.isCancelled` 또는 `Task.checkCancellation()` 사용 필요

3. **병렬 실행의 불확실성**
   - Task들이 언제 시작되고 완료되는지는 시스템이 결정
   - 취소 시점과 Task 완료 시점의 경쟁 조건(race condition) 발생 가능

4. **에러 발생 시 자동 취소**
   - `withThrowingTaskGroup`에서 한 Task가 에러를 던지면
   - 나머지 모든 Task가 자동으로 취소됨 (협력적 취소)

---

### 6. 실전 예제: 뉴스 피드 가져오기 중 중단하기

```swift
struct NewsStory: Identifiable, Decodable {
    let id: Int
    let title: String
    let strap: String
    let url: URL
}

struct ContentView: View {
    @State private var stories = [NewsStory]()

    var body: some View {
        NavigationStack {
            List(stories) { story in
                VStack(alignment: .leading) {
                    Text(story.title)
                        .font(.headline)

                    Text(story.strap)
                }
            }
            .navigationTitle("Latest News")
        }
        .task {
            await loadStories()
        }
    }

    func loadStories() async {
        do {
            try await withThrowingTaskGroup(of: [NewsStory].self) { group in
                // 5개의 뉴스 피드를 병렬로 가져오기
                for i in 1...5 {
                    group.addTask {
                        let url = URL(string: "https://hws.dev/news-\(i).json")!
                        let (data, _) = try await URLSession.shared.data(from: url)

                        // 명시적 취소 확인
                        try Task.checkCancellation()

                        return try JSONDecoder().decode([NewsStory].self, from: data)
                    }
                }

                // 완료된 결과를 순서대로 처리
                for try await result in group {
                    if result.isEmpty {
                        // 빈 배열 = 데이터 할당량 소진
                        // 나머지 피드 가져오기를 모두 취소
                        group.cancelAll()
                    } else {
                        stories.append(contentsOf: result)
                    }
                }

                stories.sort { $0.id < $1.id }
            }
        } catch {
            print("Failed to load stories: \(error.localizedDescription)")
        }
    }
}
```

**핵심 포인트:**

- 빈 배열을 받으면 즉시 `cancelAll()` 호출하여 불필요한 네트워크 요청 중단
- `Task.checkCancellation()`으로 명시적 취소 확인
- `URLSession.shared.data(from:)`도 내부적으로 취소를 확인하여 불필요한 작업 방지

---

### 7. 에러 발생 시 자동 취소 예제

```swift
enum ExampleError: Error {
    case badURL
}

func testCancellation() async {
    do {
        try await withThrowingTaskGroup(of: Void.self) { group in
            // Task 1: 1초 후 에러 발생
            group.addTask {
                try await Task.sleep(for: .seconds(1))
                throw ExampleError.badURL
            }

            // Task 2: 2초 후 취소 여부 확인
            group.addTask {
                try await Task.sleep(for: .seconds(2))
                print("Task is cancelled: \(Task.isCancelled)")
            }

            // next()로 첫 번째 완료된 Task의 결과를 기다림
            // 에러가 발생하면 여기서 throw되고 나머지 Task들이 취소됨
            try await group.next()
        }
    } catch {
        print("Error thrown: \(error.localizedDescription)")
    }
}

// INSIDE MAIN
await testCancellation()

/*
출력:
Task is cancelled: true
Error thrown: The operation couldn't be completed. (...)
*/
```

**동작 과정:**

1. 두 Task 모두 동시에 시작
2. 1초 후 첫 번째 Task가 에러를 throw
3. `group.next()`가 에러를 받아서 다시 throw
4. 그룹의 나머지 Task(두 번째)가 자동으로 취소됨
5. 두 번째 Task는 2초 후 깨어나면서 `Task.isCancelled`가 `true`임을 확인

---

### 8. 에러 발생 시 취소의 중요한 규칙

⚠️ **Task 내부에서 에러를 던지는 것만으로는 다른 Task가 취소되지 않음**

취소가 발생하려면:

- `next()`로 명시적으로 Task 결과를 기다리거나
- `for try await` 루프로 Task 결과를 순회해야 함

즉, **에러를 던진 Task의 결과에 접근할 때** 비로소 에러가 전파되고 그룹의 다른 Task들이 취소됨.

---

### 9. addTaskUnlessCancelled() — 취소된 그룹에 Task 추가 방지

#### 문제 상황

- `group.addTask()`는 **그룹이 이미 취소되었어도 무조건 Task를 추가**함
- 이미 취소된 그룹에 불필요한 작업을 추가하게 될 수 있음

#### 해결 방법

```swift
// 그룹이 취소되지 않았을 때만 Task 추가
let wasAdded = group.addTaskUnlessCancelled {
    // 작업 내용
    return someValue
}

if wasAdded {
    print("Task가 성공적으로 추가됨")
} else {
    print("그룹이 이미 취소되어 Task가 추가되지 않음")
}
```

#### 특징

- 반환값: `Bool`
  - `true` — Task가 성공적으로 추가됨
  - `false` — 그룹이 이미 취소되어 Task가 추가되지 않음
- 사용 시기:
  - 동적으로 Task를 추가하는 상황에서
  - 그룹이 취소된 후 불필요한 작업을 방지하고 싶을 때

---

### 10. Task Group 취소 요약

| 상황                  | 취소 방법   | 비고                                         |
| --------------------- | ----------- | -------------------------------------------- |
| 부모 Task 취소        | 자동 취소   | 부모가 취소되면 그룹 전체 취소               |
| `cancelAll()` 호출    | 명시적 취소 | 남은 Task만 취소, 협력적                     |
| 에러 발생             | 자동 취소   | `next()` 또는 `for try await`로 에러 접근 시 |
| View 사라짐 (SwiftUI) | 자동 취소   | `.task` modifier 사용 시                     |

**핵심 원칙:**

- 모든 취소는 **협력적**
- Task는 `Task.isCancelled` 또는 `Task.checkCancellation()`으로 스스로 확인해야 함
- Foundation API (URLSession 등)는 내부적으로 취소를 확인함



## Task Group에서 서로 다른 결과 타입 처리하기

### 1. 문제 상황

- Task Group의 모든 child task는 **동일한 타입**을 반환해야 함
- 예: `withTaskGroup(of: String.self)` → 모든 Task가 `String` 반환
- 하지만 실무에서는 여러 다른 타입의 데이터를 동시에 가져와야 하는 경우가 많음

---

### 2. 해결 방법 두 가지

#### 방법 1: async let 사용 (권장)

```swift
async let username = fetchUsername()
async let favorites = fetchFavorites()  // Set<Int>
async let messages = fetchMessages()    // [Message]

// 각자 다른 타입을 반환 가능
let user = await User(
    username: username,
    favorites: favorites,
    messages: messages
)
```

**장점:**

- 각 작업이 고유한 타입을 반환할 수 있음
- 간결하고 타입 안전

**단점:**

- 작업 개수가 컴파일 타임에 고정되어야 함
- 루프로 동적 생성 불가

---

#### 방법 2: Enum + Associated Values 사용

- Task를 루프로 동적 생성해야 할 때
- Task Group을 반드시 써야 할 때

**핵심 아이디어:**

1. 반환할 각 타입을 감싸는 **enum**을 만듦
2. 각 case는 **associated value**로 실제 데이터를 포함
3. 모든 Task는 이 enum 타입을 반환 (형식적으로는 같은 타입)
4. 결과를 받을 때 **switch**로 case를 구분하고 데이터를 추출

---

### 3. 실전 예제: 사용자 정보 가져오기 (3가지 다른 타입)

```swift
// 디코딩할 메시지 구조체
struct Message: Decodable {
    let id: Int
    let from: String
    let message: String
}

// 최종적으로 만들 사용자 구조체
struct User {
    let username: String
    let favorites: Set<Int>
    let messages: [Message]
}

// 서로 다른 타입들을 감싸는 enum
enum FetchResult {
    case username(String)       // String 타입
    case favorites(Set<Int>)    // Set<Int> 타입
    case messages([Message])    // [Message] 타입
}

func loadUser() async {
    // TaskGroup은 FetchResult라는 하나의 타입만 반환
    let user = await withThrowingTaskGroup(of: FetchResult.self) { group in

        // Task 1: username (String) 가져오기
        group.addTask {
            let url = URL(string: "https://hws.dev/username.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = String(decoding: data, as: UTF8.self)

            // FetchResult.username case로 감싸서 반환
            return .username(result)
        }

        // Task 2: favorites (Set<Int>) 가져오기
        group.addTask {
            let url = URL(string: "https://hws.dev/user-favorites.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode(Set<Int>.self, from: data)

            // FetchResult.favorites case로 감싸서 반환
            return .favorites(result)
        }

        // Task 3: messages ([Message]) 가져오기
        group.addTask {
            let url = URL(string: "https://hws.dev/user-messages.json")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode([Message].self, from: data)

            // FetchResult.messages case로 감싸서 반환
            return .messages(result)
        }

        // 기본값 설정
        var username = "Anonymous"
        var favorites = Set<Int>()
        var messages = [Message]()

        // 완료된 Task들의 결과를 순회하며 처리
        do {
            for try await value in group {
                // switch로 각 case를 구분하고 associated value 추출
                switch value {
                case .username(let value):
                    username = value
                case .favorites(let value):
                    favorites = value
                case .messages(let value):
                    messages = value
                }
            }
        } catch {
            // 일부 fetch가 실패해도 받아온 데이터는 사용
            print("Fetch at least partially failed; sending back what we have so far. \(error.localizedDescription)")
        }

        // User 인스턴스 생성 및 반환
        return User(username: username, favorites: favorites, messages: messages)
    }

    // 완성된 사용자 데이터 사용
    print("User \(user.username) has \(user.messages.count) messages and \(user.favorites.count) favorites.")
}

// INSIDE MAIN
await loadUser()
```

---

### 4. 핵심 단계 정리

#### Step 1: Enum 정의

```swift
enum FetchResult {
    case username(String)
    case favorites(Set<Int>)
    case messages([Message])
}
```

- 각 case = 하나의 데이터 타입
- associated value로 실제 데이터를 감쌈

#### Step 2: Task에서 enum case로 감싸서 반환

```swift
group.addTask {
    let data = try await fetchSomeData()
    return .username(data)  // enum case로 반환
}
```

#### Step 3: 결과 처리 시 switch로 분기

```swift
for try await value in group {
    switch value {
    case .username(let str):
        // String 데이터 사용
    case .favorites(let set):
        // Set<Int> 데이터 사용
    case .messages(let arr):
        // [Message] 데이터 사용
    }
}
```

---

### 5. 장단점 비교

| 방법                 | 장점                                                         | 단점                                                         | 사용 시기                                 |
| -------------------- | ------------------------------------------------------------ | ------------------------------------------------------------ | ----------------------------------------- |
| **async let**        | • 간결함<br>• 타입 안전<br>• 코드가 명확                     | • 작업 개수 고정<br>• 동적 생성 불가                         | 작업 개수가 고정일 때                     |
| **enum + TaskGroup** | • 동적 Task 생성 가능<br>• 루프로 Task 추가 가능<br>• 유연함 | • 보일러플레이트 코드 증가<br>• enum 정의 필요<br>• switch 처리 필요 | 작업 개수가 동적일 때<br>루프가 필요할 때 |

---

### 6. 실무 팁

1. **대부분의 경우 async let을 먼저 고려**
   - 코드가 더 명확하고 간결
   - 타입 안전성이 높음

2. **다음 경우에만 enum + TaskGroup 사용**
   - 루프로 Task를 생성해야 할 때
   - 런타임에 Task 개수가 결정될 때
   - Task Group의 다른 기능(취소, 우선순위 등)이 필요할 때

3. **부분 실패 처리**
   - 위 예제처럼 기본값을 설정하고
   - catch에서도 지금까지 받은 데이터를 사용할 수 있음
   - 일부 데이터라도 사용자에게 보여주는 것이 더 나은 UX

---

### 7. 요약

**문제:** Task Group의 모든 Task는 같은 타입을 반환해야 함

**해결:**

- 작업 개수 고정 → `async let` 사용 (권장)
- 작업 개수 동적 → `enum` + `associated values` + `TaskGroup`

**핵심:**

- Enum으로 여러 타입을 하나의 타입으로 "포장"
- Switch로 결과를 "언박싱"하여 사용



## Task Group에서 결과 폐기하기 (Discarding Task Group)

### 1. 문제 상황: 일반 Task Group의 메모리 누수

#### 서버나 장시간 실행되는 Task의 문제

- 서버가 연결을 계속 받는 경우
- 파일 시스템 감시자가 계속 변경사항을 스캔하는 경우
- 무한히 데이터를 생성하는 경우

→ Task가 완료되어도 우리가 `next()` 또는 `for await`로 결과를 기다리지 않으면 **Task가 메모리에 계속 쌓임**

---

### 2. 메모리 누수 예제

#### 계속해서 랜덤 숫자를 생성하는 AsyncSequence

```swift
struct RandomGenerator: AsyncSequence, AsyncIteratorProtocol {
    mutating func next() async -> Int? {
        try? await Task.sleep(for: .seconds(0.001))
        return Int.random(in: 1...Int.max)
    }

    func makeAsyncIterator() -> Self {
        self
    }
}
```

#### 메모리 누수가 발생하는 코드

```swift
// INSIDE MAIN
let generator = RandomGenerator()

await withTaskGroup(of: Void.self) { group in
    for await newNumber in generator {
        group.addTask {
            print(newNumber)
        }
    }
}
```

**문제점:**

- Task는 `Void`를 반환 (반환값 없음)
- 하지만 **완료된 Task를 명시적으로 await 하지 않음**
- 완료된 Task들이 메모리에 계속 쌓여서 **초당 약 0.5MB씩 메모리 누수 발생**

---

### 3. 일반적인 해결 시도와 새로운 문제

#### 해결 시도: Task 결과를 await 하기

```swift
await withTaskGroup(of: Void.self) { group in
    for await newNumber in generator {
        group.addTask {
            print(newNumber)
        }

        // Task 완료를 기다림 → 메모리 누수 해결
        await group.next()
    }
}
```

#### 새로운 문제 발생

- 현재 Task가 완료될 때까지 기다려야 함
- **그동안 새로운 연결(또는 데이터)을 받을 수 없음**
- 서버의 경우: 한 번에 하나의 연결만 처리 가능 → 병렬 처리 불가능
- 성능 저하 발생

---

### 4. 해결책: Discarding Task Group

#### 핵심 개념

- **Discarding Task Group**은 완료된 Task를 자동으로 폐기하고 파괴함
- `next()` 같은 명시적 대기가 **필요 없음**
- 실제로 결과를 기다릴 수도 **없음** (설계상 불가능)
- 완료되는 즉시 자동으로 정리됨

#### 사용 방법

```swift
// 기존 코드
await withTaskGroup(of: Void.self) { group in

// 변경 후
await withDiscardingTaskGroup { group in
```

---

### 5. 완전한 예제: Discarding Task Group 사용

```swift
// INSIDE MAIN
let generator = RandomGenerator()

await withDiscardingTaskGroup { group in
    for await newNumber in generator {
        group.addTask {
            print(newNumber)
        }
    }
}
```

**효과:**

- ✅ 메모리 누수 없음 (완료된 Task 자동 파괴)
- ✅ 병렬 처리 가능 (새 Task를 계속 추가 가능)
- ✅ 명시적 대기 불필요

---

### 6. 실전 사용 사례

#### 서버 연결 처리

```swift
// 서버가 계속해서 연결을 받는 상황
await withDiscardingTaskGroup { group in
    for await connection in server.incomingConnections {
        group.addTask {
            // 각 연결을 독립적으로 처리
            await handleConnection(connection)
            // 완료되면 자동으로 Task가 파괴됨
        }
    }
}
```

#### 파일 시스템 감시

```swift
await withDiscardingTaskGroup { group in
    for await fileChange in fileWatcher.changes {
        group.addTask {
            // 파일 변경사항 처리
            await processFileChange(fileChange)
            // 완료 후 자동 정리
        }
    }
}
```

---

### 7. Throwing Discarding Task Group

#### withThrowingDiscardingTaskGroup

- 에러를 던질 수 있는 Discarding Task Group
- 기본적인 동작은 동일하지만 Task 내부에서 에러를 던질 수 있음

```swift
await withThrowingDiscardingTaskGroup { group in
    for await connection in server.incomingConnections {
        group.addTask {
            // 에러가 발생할 수 있는 작업
            try await handleConnection(connection)
        }
    }
}
```

---

### 8. 일반 Task Group vs Discarding Task Group 비교

| 특징            | 일반 Task Group              | Discarding Task Group            |
| --------------- | ---------------------------- | -------------------------------- |
| **결과 대기**   | 필수 (`next()`, `for await`) | 자동 (불가능)                    |
| **메모리 관리** | 수동 (명시적 대기 필요)      | 자동 (완료 즉시 파괴)            |
| **반환값 사용** | 가능                         | 불가능 (자동 폐기)               |
| **사용 사례**   | 결과가 필요한 경우           | 결과가 필요 없는 fire-and-forget |
| **장시간 실행** | 메모리 누수 위험             | 안전                             |
| **병렬 처리**   | 대기 시 차단 가능            | 항상 비차단                      |

---

### 9. 언제 Discarding Task Group을 사용해야 할까?

#### ✅ 사용해야 할 때

1. **장시간 또는 무한히 실행되는 작업**
   - 서버 연결 처리
   - 파일 시스템 감시
   - 이벤트 리스너

2. **Task의 반환값이 필요 없는 경우**
   - Fire-and-forget 패턴
   - 로깅, 알림 전송 등

3. **많은 수의 Task를 계속 생성하는 경우**
   - 수천~수만 개의 독립적인 작업 처리

#### ❌ 사용하지 말아야 할 때

1. **Task의 결과를 수집해야 하는 경우**
   - 여러 API 호출 결과를 모아서 사용
   - 일반 Task Group 사용

2. **모든 Task의 완료를 명시적으로 기다려야 하는 경우**
   - 일반 Task Group의 `waitForAll()` 사용

3. **Task 개수가 적고 제한적인 경우**
   - 일반 Task Group으로 충분

---

### 10. 핵심 정리

**문제:**

- 일반 Task Group에서 결과를 기다리지 않으면 메모리 누수 발생
- 결과를 기다리면 병렬 처리가 제한됨

**해결:**

- `withDiscardingTaskGroup` 사용
- 완료된 Task를 자동으로 폐기하여 메모리 관리
- 병렬 처리를 막지 않음

**사용법:**

```swift
// Non-throwing
await withDiscardingTaskGroup { group in
    // Task 추가
}

// Throwing
await withThrowingDiscardingTaskGroup { group in
    // 에러를 던질 수 있는 Task 추가
}
```

**주의사항:**

- Task의 반환값을 사용할 수 없음 (자동 폐기되므로)
- 오직 side effect만을 위한 작업에 사용



## async let vs Task vs Task Group 비교 및 선택 가이드

### 1. 공통점

세 가지 모두 **동시성(concurrency)을 생성**하여 시스템이 효율적으로 실행할 수 있도록 함

---

### 2. 핵심 차이점 5가지

#### 차이점 1: 작업 개수의 동적/정적 처리

**async let & Task**

- **개별 작업** 생성에 적합
- 작업 개수가 **컴파일 타임에 고정**되어야 함
- 동적으로 작업을 생성할 수 없음

```swift
// ❌ 배열의 URL 개수만큼 동적으로 작업 생성 불가
async let data1 = fetch(url1)
async let data2 = fetch(url2)
// ... 개수가 정해져 있어야 함
```

**Task Group**

- **여러 작업을 동시에 실행**하고 결과를 수집
- 작업 개수를 **런타임에 동적으로 결정** 가능
- 배열을 루프로 돌면서 작업 추가 가능

```swift
// ✅ 배열의 URL 개수만큼 동적으로 작업 생성 가능
await withTaskGroup(of: Data.self) { group in
    for url in urls {  // urls.count는 런타임에 결정
        group.addTask {
            await fetch(url)
        }
    }
}
```

**예시: URL 배열에서 날씨 데이터 가져오기**

- Task Group: 배열을 루프로 돌면서 각 URL을 병렬로 fetch
- async let/Task: URL 개수를 미리 알아야 하므로 하드코딩 필요

**✅ Task를 동적으로 생성하면 요청 순서를 유지할 수 있다**

Task 자체는 배열을 순회하며 동적으로 생성할 수 있습니다. 이 방식의 **장점**은 **요청 순서를 보장**할 수 있다는 점입니다:

```swift
let data = [1, 2, 3, 4, 5]

func createTask(for index: Int) -> Task<Int, any Error> {
    return Task {
        let delay = data.randomElement()!
        print("Task(\(index)) 시작 -> 딜레이: \(delay)")
        // 랜덤하게 sleep, 병렬 처리 시 언제 끝날지 모르는 상황을 재현
        try await Task.sleep(for: .seconds(delay))
        return index
    }
}

Task {
    let start = Date()

    let tasks = data.map { createTask(for: $0) }
    var result: [Int] = []

    // 모든 테스크는 반드시 await을 하여 끝내야 한다. 그러지 않으면 고아 테스크가 생겨 성능 이슈로 이어짐.
    for task in tasks {
        result.append(try await task.value)
    }

    print("총 걸린 시간: \(Date().timeIntervalSince(start))")
    print("결과: \(result)")
}

/*
출력:
Task(1) 시작 -> 딜레이: 3
Task(2) 시작 -> 딜레이: 5
Task(4) 시작 -> 딜레이: 3
Task(3) 시작 -> 딜레이: 4
Task(5) 시작 -> 딜레이: 1
총 걸린 시간: 5.297232031822205
결과: [1, 2, 3, 4, 5]
*/
```

**핵심 특징:**

1. **병렬 실행**: 모든 Task가 동시에 시작됨 (Task(1)~(5) 모두 즉시 실행)
2. **요청 순서 보장**: 결과는 항상 `[1, 2, 3, 4, 5]` 순서로 수집됨
3. **총 실행 시간**: 가장 긴 작업 시간만큼 소요 (위 예시: 5초)
4. **고아 Task 방지**: 배열의 순서대로 모든 Task를 명시적으로 await

**Task Group과의 비교:**

```swift
// Task Group: 완료 순서대로 결과 처리 (순서 보장 안 됨)
await withTaskGroup(of: Int.self) { group in
    for index in data {
        group.addTask {
            try await Task.sleep(for: .seconds(data.randomElement()!))
            return index
        }
    }

    var result: [Int] = []
    for await value in group {
        result.append(value)
    }
    print(result)  // 예: [5, 1, 4, 3, 2] - 완료 순서대로

    // 순서를 맞추려면 정렬 필요 → O(n log n) 시간복잡도
    result.sort()
    print(result)  // [1, 2, 3, 4, 5]
}
```

**💡 Task Group에서도 순서를 O(n)으로 보장하는 방법**

정렬 대신, **인덱스와 함께 반환**하여 미리 할당된 배열의 올바른 위치에 저장하면 시간복잡도를 **O(n)**으로 유지할 수 있습니다:

```swift
// Task Group: 인덱스를 함께 반환하여 순서 보장 (O(n))
await withTaskGroup(of: (index: Int, value: Int).self) { group in
    for (index, _) in data.enumerated() {
        group.addTask {
            let delay = data.randomElement()!
            try await Task.sleep(for: .seconds(delay))
            return (index: index, value: index + 1)  // 인덱스와 값을 함께 반환
        }
    }

    // 미리 결과 배열을 요청 개수만큼 할당
    var result = Array(repeating: 0, count: data.count)

    for await (index, value) in group {
        result[index] = value  // O(1) - 올바른 위치에 직접 저장
    }

    print(result)  // [1, 2, 3, 4, 5] - 정렬 없이 순서 보장
}
```

**시간복잡도 비교:**

| 방식                              | 시간복잡도  | 설명                                      |
| --------------------------------- | ----------- | ----------------------------------------- |
| Task 배열 (순서대로 await)        | **O(n)**    | 배열 순서대로 await하므로 자동 정렬       |
| TaskGroup + 정렬                  | **O(n log n)** | 완료 순서로 받은 후 정렬 필요             |
| TaskGroup + 인덱스 기반 배열 저장 | **O(n)**    | 미리 할당된 배열에 인덱스로 직접 저장     |

**언제 어떤 방식을 선택할까?**

| 상황                              | 선택                       | 이유                                               |
| --------------------------------- | -------------------------- | -------------------------------------------------- |
| 순서 보장 + 간단한 구현           | Task 배열                  | 요청 순서대로 자동 정렬, 코드 간결                 |
| 순서 보장 + 취소 기능 필요        | TaskGroup + 인덱스         | O(n) 시간복잡도 + `cancelAll()` 사용 가능          |
| 순서 보장 + 대용량 데이터         | TaskGroup + 인덱스         | 정렬 비용(O(n log n)) 없이 O(n)으로 처리           |
| 가장 빠른 결과만 필요             | Task Group                 | `group.next()` 로 첫 번째 완료된 것만 사용         |
| 완료되는 대로 즉시 UI 업데이트    | Task Group                 | 완료 순서대로 즉시 표시 (응답성 향상)              |
| 결과 순서가 중요하지 않은 경우    | Task Group                 | 완료 순서대로 처리                                 |
| 작업 그룹 전체 취소가 필요한 경우 | Task Group                 | `cancelAll()` 로 그룹 전체 취소 가능               |

→ **결론**:
- **Task 배열**: 간단한 순서 보장이 필요할 때, 코드 가독성이 중요할 때
- **TaskGroup + 인덱스**: 순서 보장 + 취소 기능 + O(n) 성능이 모두 필요할 때 (대용량 데이터에 유리)
- **TaskGroup (일반)**: 완료 순서대로 처리하여 빠른 응답성이 필요할 때

---

#### 차이점 2: 결과 처리 순서

**async let & Task**

- **명시한 순서대로** 결과를 받아야 함
- 먼저 완료된 작업이 있어도 await 순서대로만 읽을 수 있음

```swift
async let data1 = slowTask()   // 10초 걸림
async let data2 = fastTask()   // 1초 걸림

// data2가 먼저 완료되어도 data1을 먼저 기다려야 함
let result1 = await data1  // 10초 대기
let result2 = await data2  // 이미 완료됨
```

**Task Group**

- **완료되는 순서대로** 결과를 처리 가능
- `group.next()` 또는 `for await`로 가장 먼저 완료된 작업의 결과를 읽음

```swift
await withTaskGroup(of: Data.self) { group in
    group.addTask { await slowTask() }   // 10초
    group.addTask { await fastTask() }   // 1초

    // fastTask 결과를 먼저 받음 (1초 후)
    if let firstResult = await group.next() {
        print("First result: \(firstResult)")
    }
}
```

**실전 예시: 여러 서버 중 가장 빠른 서버 사용**

```swift
await withTaskGroup(of: Data.self) { group in
    group.addTask { await fetchFrom(server1) }
    group.addTask { await fetchFrom(server2) }
    group.addTask { await fetchFrom(server3) }

    // 가장 빠른 서버의 응답만 사용
    if let fastestResponse = await group.next() {
        return fastestResponse
    }
}
```

---

#### 차이점 3: 직접 취소 기능

**async let**

- ❌ 직접 취소 불가능
- 부모 Task가 취소되면 자동으로 취소됨

**Task**

- ✅ `task.cancel()` 로 직접 취소 가능

```swift
let task = Task {
    await someWork()
}

task.cancel()  // 직접 취소
```

**Task Group**

- ✅ `group.cancelAll()` 로 모든 child task 취소 가능

```swift
await withTaskGroup(of: Int.self) { group in
    group.addTask { await work1() }
    group.addTask { await work2() }

    group.cancelAll()  // 모든 작업 취소
}
```

---

#### 차이점 4: Task 참조 전달 가능 여부

**async let**

- ❌ 내부 Task에 대한 참조(handle)를 얻을 수 없음
- 다른 함수로 Task를 전달할 수 없음
- async let을 시작한 곳에서 반드시 await 해야 함

```swift
func startWork() {
    async let result = fetchData()
    // result를 다른 함수로 전달 불가능
    await processResult(result)  // 여기서만 사용 가능
}
```

**Task**

- ✅ Task 객체를 변수에 저장하고 전달 가능
- `Task<String, Never>` 같은 타입으로 참조 가능

```swift
func startWork() -> Task<String, Never> {
    // Task를 반환하여 다른 곳에서 사용 가능
    return Task {
        return await fetchData()
    }
}

func processWork() async {
    let task = startWork()
    // 다른 작업...
    let result = try await task.value
}
```

---

#### 차이점 5: 서로 다른 타입 처리

**async let & Task**

- ✅ 각 작업이 서로 다른 타입을 반환 가능
- 추가 작업 없이 자연스럽게 처리

```swift
async let name: String = fetchName()
async let age: Int = fetchAge()
async let scores: [Double] = fetchScores()

// 각기 다른 타입을 쉽게 사용
let user = User(
    name: await name,
    age: await age,
    scores: await scores
)
```

**Task Group**

- ⚠️ 모든 child task가 같은 타입을 반환해야 함
- 다른 타입을 사용하려면 **enum + associated values**로 감싸야 함 (번거로움)

```swift
// 각기 다른 타입을 위해 enum 필요
enum Result {
    case name(String)
    case age(Int)
    case scores([Double])
}

await withTaskGroup(of: Result.self) { group in
    group.addTask { .name(await fetchName()) }
    group.addTask { .age(await fetchAge()) }
    group.addTask { .scores(await fetchScores()) }
    // switch로 unwrapping 필요...
}
```

---

### 3. 비교표

| 특징            | async let          | Task               | Task Group      |
| --------------- | ------------------ | ------------------ | --------------- |
| **작업 개수**   | 고정 (컴파일 타임) | 고정 (컴파일 타임) | 동적 (런타임)   |
| **결과 순서**   | 명시한 순서대로    | 명시한 순서대로    | 완료 순서대로   |
| **직접 취소**   | ❌ 불가능           | ✅ `cancel()`       | ✅ `cancelAll()` |
| **Task 전달**   | ❌ 불가능           | ✅ 가능             | N/A             |
| **다른 타입**   | ✅ 쉬움             | ✅ 쉬움             | ⚠️ enum 필요     |
| **사용 난이도** | 가장 쉬움          | 쉬움               | 복잡함          |
| **코드 간결성** | 매우 간결          | 간결               | 상대적으로 장황 |

---

### 4. 실무 사용 가이드

#### 📊 사용 빈도 (높음 → 낮음)

1. **async let** (가장 많이 사용)
2. **Task** (중간)
3. **Task Group** (가장 적게 사용)

---

### 5. 언제 무엇을 사용할까?

#### ✅ async let을 사용해야 할 때 (1순위)

**특징:**

- 가장 간결하고 읽기 쉬운 코드
- 타입 안전성이 높음
- 대부분의 상황에서 충분함

**사용 사례:**

- 고정된 개수의 작업을 병렬로 실행
- 각 작업이 서로 다른 타입을 반환
- 모든 결과가 필요함

```swift
// 사용자 프로필 페이지 로딩
async let profile = fetchProfile()
async let posts = fetchPosts()
async let followers = fetchFollowers()

return ProfileView(
    profile: await profile,
    posts: await posts,
    followers: await followers
)
```

---

#### ✅ Task를 사용해야 할 때 (2순위)

**특징:**

- async let보다 유연함
- 취소 기능 필요
- Task 참조를 전달해야 함

**사용 사례:**

- Task를 취소해야 하는 경우
- Task를 다른 함수로 전달해야 하는 경우
- async let으로는 표현할 수 없는 로직

```swift
// 검색 기능: 이전 검색 취소
class SearchViewModel {
    var currentSearchTask: Task<[Result], Never>?

    func search(query: String) {
        // 이전 검색 취소
        currentSearchTask?.cancel()

        // 새 검색 시작
        currentSearchTask = Task {
            await performSearch(query)
        }
    }
}
```

---

#### ✅ Task Group을 사용해야 할 때 (3순위)

**특징:**

- 동적 개수의 작업 처리
- 완료 순서대로 결과 처리
- 가장 복잡하지만 강력함

**사용 사례:**

- 작업 개수가 런타임에 결정 (배열, 딕셔너리 등)
- 완료 순서가 중요한 경우
- 가장 빠른 결과만 필요한 경우

```swift
// 동적 개수의 이미지 다운로드
func downloadImages(urls: [URL]) async -> [UIImage] {
    await withTaskGroup(of: UIImage?.self) { group in
        for url in urls {
            group.addTask {
                await downloadImage(from: url)
            }
        }

        var images: [UIImage] = []
        for await image in group {
            if let image = image {
                images.append(image)
            }
        }
        return images
    }
}
```

---

### 6. 실무 선택 원칙

#### 1단계: async let으로 시작

```swift
async let data1 = fetch1()
async let data2 = fetch2()
let result = await (data1, data2)
```

**이유:**

- 대부분의 경우 async let으로 충분
- 가장 간결하고 읽기 쉬움
- 다른 타입 처리가 간편

---

#### 2단계: 필요시 Task로 이동

**다음 경우에만 Task 사용:**

- ✅ 취소 기능이 필요할 때
- ✅ Task를 전달해야 할 때
- ✅ fire-and-forget 패턴이 필요할 때

```swift
let task = Task {
    await longRunningWork()
}

// 나중에 취소 가능
task.cancel()
```

---

#### 3단계: 특수한 경우에만 Task Group 사용

**다음 경우에만 Task Group 사용:**

- ✅ 작업 개수가 동적일 때 (배열, 루프)
- ✅ 완료 순서대로 처리해야 할 때
- ✅ 가장 빠른 결과만 필요할 때

```swift
// 가장 빠른 서버 응답 사용
await withTaskGroup(of: Data.self) { group in
    for server in servers {
        group.addTask { await fetch(from: server) }
    }
    return await group.next()  // 가장 빠른 것만
}
```

---

### 7. 왜 이 순서로 선택해야 할까?

#### 실무에서 발견한 패턴

1. **대부분은 모든 결과가 필요함**
   - 일부만 사용하거나 완료 순서가 중요한 경우는 드묾
   - async let이면 충분

2. **서로 다른 타입을 다루는 경우가 많음**
   - Task Group의 enum wrapping은 번거로움
   - async let/Task는 자연스러움

3. **취소가 필요하면 Task로 쉽게 전환 가능**
   - async let → Task로 전환은 간단
   - Task Group으로 바로 가는 것보다 점진적

---

### 8. 의사결정 플로우차트

```
작업이 고정된 개수인가?
├─ Yes → 다른 타입을 반환하는가?
│         ├─ Yes → async let 사용
│         └─ No → 취소 기능이 필요한가?
│                   ├─ Yes → Task 사용
│                   └─ No → async let 사용
│
└─ No (동적 개수) → Task Group 사용

특수 케이스:
- 가장 빠른 결과만 필요? → Task Group
- 완료 순서대로 처리? → Task Group
- Task를 전달해야 함? → Task
```

---

### 9. 핵심 요약

| 우선순위 | 도구           | 사용 빈도 | 주요 사용 사례                 |
| -------- | -------------- | --------- | ------------------------------ |
| 🥇 1순위  | **async let**  | 가장 높음 | 고정된 작업, 다른 타입, 간결함 |
| 🥈 2순위  | **Task**       | 중간      | 취소 필요, Task 전달 필요      |
| 🥉 3순위  | **Task Group** | 가장 낮음 | 동적 작업, 완료 순서 중요      |

**기본 원칙:**

1. async let으로 시작
2. 안 되면 Task 고려
3. 정말 필요할 때만 Task Group 사용

**실무 팁:**

- Task Group을 직접 사용하는 빈도는 낮음
- 하지만 Task Group 위에 다른 추상화를 만들어 사용하는 경우는 많음
- 예: 커스텀 병렬 처리 유틸리티, 배치 작업 처리기 등