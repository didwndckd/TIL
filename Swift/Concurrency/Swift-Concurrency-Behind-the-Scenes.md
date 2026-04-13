# Structured Concurrency

## 참고
- Swift Concurrency
	- [WWDC21: Meet async/await in Swift](https://developer.apple.com/videos/play/wwdc2021/10132/)
	- [WWDC21: Explore structured concurrency in Swift](https://developer.apple.com/videos/play/wwdc2021/10134/)
	- [WWDC21: Swift concurrency: Behind the scenes](https://developer.apple.com/videos/play/wwdc2021/10254/)
- GCD
	- [WWDC17: Modernizing Grand Central Dispatch Usage](https://developer.apple.com/videos/play/wwdc2017/706/)
	- [WWDC15: Building responsive and efficient apps with GCD](https://nonstrict.eu/wwdcindex/wwdc2015/718/?t=533)

---

# Swift Concurrency: Behind the Scenes

> [WWDC21: Swift concurrency: Behind the scenes](https://developer.apple.com/videos/play/wwdc2021/10254/) 세션 내용 정리
> 
> 스레드 관점에서 Swift Concurrency가 어떻게 동작하는지에 초점을 맞춰 정리

## GCD의 스레딩 모델과 문제점

### Thread Explosion (스레드 폭발)

GCD는 요청 기반으로 스레드를 생성한다.

- 큐에 작업이 들어오면 시스템이 스레드를 생성해서 처리
- 스레드가 블로킹되면 대기 중인 작업을 위해 **추가 스레드를 생성**
- 예: 2코어 기기에서 100개의 피드 업데이트 → CPU 코어 수 대비 **16배 이상의 스레드** 생성 가능

```swift
// concurrentQueue를 delegate 큐로 사용하는 URLSession 생성
let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: concurrentQueue)

for feed in feedsToUpdate {
    // 각 피드마다 네트워크 요청 생성
    let dataTask = urlSession.dataTask(with: feed.url) { data, response, error in
        guard let data = data else { return }
        do {
            let articles = try deserializeArticles(from: data)
            // databaseQueue.sync 호출 → 이 시점에서 현재 스레드가 블로킹됨
            // 여러 콜백이 동시에 실행되면 블로킹된 스레드가 누적된다
            databaseQueue.sync {
                updateDatabase(with: articles, for: feed)
            }
        } catch { /* ... */ }
    }
    dataTask.resume()
}
```

### GCD의 `async`도 블로킹 문제를 해결하지 못한다

`DispatchQueue.async`는 **호출한 쪽 스레드**는 블로킹하지 않지만, 작업이 실행되는 스레드 자체는 블로킹될 수 있다.

```swift
for feed in feedsToUpdate {  // 100개의 피드
    // async로 작업을 넘기면 호출자는 즉시 반환된다
    // 하지만 이 블록을 실행하기 위해 GCD가 스레드를 배정해야 한다
    concurrentQueue.async {
        // 네트워크 I/O 완료까지 이 스레드는 블로킹됨
        let data = fetchData(from: feed.url)
        // DB 큐 접근 대기로 이 스레드가 또 블로킹됨
        databaseQueue.sync { ... }
    }
}
```

1. 100개의 작업이 큐에 들어감
2. GCD가 작업마다 스레드를 배정
3. 각 스레드가 네트워크 응답 대기 등으로 블로킹
4. 블로킹된 스레드가 쌓이면서 → **Thread Explosion**

| | GCD `async` | Swift Concurrency `await` |
|---|---|---|
| **호출자 블로킹** | 안 됨 | 안 됨 |
| **실행 스레드 블로킹** | 내부에서 블로킹 가능 | 함수가 일시 중단되고 스레드 반납 |
| **결과** | 스레드가 계속 쌓일 수 있음 | 스레드 수가 코어 수로 고정 |

GCD의 `async`는 작업을 **넘기는 시점**만 논블로킹이고, 작업이 **실행되는 스레드 자체는 블로킹될 수 있다**. Swift Concurrency의 `await`는 실행 중인 스레드까지 반납하는 것이 근본적인 차이다.

### Thread Explosion의 부작용

| 문제 | 설명 |
|------|------|
| **메모리 오버헤드** | 블로킹된 스레드마다 스택과 커널 데이터 구조를 유지 |
| **스케줄링 오버헤드** | 스레드 간 과도한 컨텍스트 스위칭 발생 |
| **데드락 위험** | 락을 잡은 채 대기하는 스레드 |
| **CPU 효율 저하** | 스케줄링 레이턴시가 실제 유용한 작업 시간을 초과 |

---

## Swift Concurrency의 스레딩 모델

### Cooperative Thread Pool (협력적 스레드 풀)

Swift Concurrency는 GCD와 근본적으로 다른 접근 방식을 사용한다.

**핵심 원칙: 스레드는 절대 블로킹되지 않는다 (Runtime Contract)**

- **CPU 코어 수만큼만 스레드를 생성** (2코어 → 2개 스레드)
- 스레드 컨텍스트 스위칭 대신 **경량 continuation**으로 작업 전환
- OS 레벨 컨텍스트 스위칭이 아닌 **함수 호출 수준의 비용**으로 전환

이것이 가능한 이유는 `async/await`, Task 의존성 등의 **언어 레벨 기능**으로 의존 관계가 컴파일 타임에 명시적으로 드러나기 때문이다.

### GCD vs Swift Concurrency 비교

| 항목           | GCD                   | Swift Concurrency           |
| ------------ | --------------------- | --------------------------- |
| **스레드 생성**   | 요청에 따라 동적 생성          | 고정 풀 (CPU 코어 수)             |
| **블로킹 동작**   | 블로킹 시 새 스레드 생성        | 함수가 일시 중단 후 스레드의 제어권을 반납하여 다른 작업으로 전환 |
| **컨텍스트 스위칭** | OS 레벨 전체 컨텍스트 스위칭     | 함수 호출 수준의 전환                |
| **메모리 오버헤드** | 높음 (스레드별 스택 + 커널 데이터) | 낮음 (힙 기반 continuation)      |
| **의존성 정보**   | 런타임에 숨겨짐              | 명시적, 컴파일러가 인지               |
| **스레드 수 상한** | 제한 없음                 | CPU 코어 수로 고정                |
| **스케줄링 방식**  | FIFO (선입선출)           | Reentrant (유연한 순서, 우선순위 기반) |

---

## Async/Await의 스레드 레벨 동작

### Suspension(일시 중단) 메커니즘

`await`는 스레드를 **블로킹하지 않는다**. 대신 async 함수의 실행을 일시 중단하고 스레드의 제어권을 시스템에 반납하여 즉시 다른 작업에 사용할 수 있도록 한다.

```swift
func add(_ newArticles: [Article]) async throws {
    // await 시점에서 async 함수가 일시 중단되고, 스레드의 제어권을 반납하여 다른 작업에 재사용됨
    // newArticles는 await 이후에도 필요하므로 async frame(힙)에 저장됨
    let ids = try await database.save(newArticles, for: self)
    // 재개 후 같은 스레드 또는 다른 스레드에서 실행이 계속됨
    for (id, article) in zip(ids, newArticles) {
        articles[id] = article
    }
}
```

**실행 흐름:**

1. **`await` 이전**: 즉시 사용되는 변수들은 스택 프레임에 존재
2. **`await` 시점**: 일시 중단 이후에 필요한 변수들을 **async frame** (힙)에 저장
3. **`await` 이후**: 스레드의 제어권이 반납되어 다른 작업을 수행
4. **재개(resume)**: 같은 스레드 또는 **다른 스레드**가 continuation을 가져와 실행 재개

### Stack vs Heap 저장 구조

```
Stack Frame (스레드별):
├── 지역 변수
├── 반환 주소
└── 즉시 사용되는 컨텍스트

Async Frame (함수별, 힙에 저장):
├── suspension point를 넘어 필요한 상태
├── 스레드가 재사용되어도 생존
└── continuation 체인을 구성
```

### 스레드 동작 예시

```
초기 상태:
┌─ updateDatabase()가 add()를 호출
│  Stack: [add() frame]              ← 스레드의 스택에 현재 실행 중인 함수 프레임
│  Heap: [updateDatabase의 async frame, add의 async frame]  ← 힙에 저장된 async 상태
│
└─ 첫 번째 await (database.save) 도달:
   - async 함수가 일시 중단                ← 스레드가 블로킹되는 것이 아님
   - async frame들로 continuation 생성  ← 재개에 필요한 상태를 힙에 보존
   - 스레드가 다른 작업을 수행              ← 스레드는 즉시 재사용 가능

재개:
   - 아무 스레드나 continuation을 가져감    ← 반드시 같은 스레드일 필요 없음
   - save()의 스택 프레임 재생성
   - await 지점부터 실행 계속
```

### Continuation이란?

**Continuation**은 힙에 저장된 async 호출 체인의 런타임 표현이다.

- suspension point를 넘어 필요한 상태를 포함하는 async frame들의 목록
- 각 프레임은 변수, 매개변수, 실행 컨텍스트를 추적
- 스레드 컨텍스트 스위칭을 넘어 생존

```swift
// URLSession.data()는 async 함수로, 네트워크 응답을 기다리는 동안 스레드를 블로킹하지 않는다
let (data, response) = try await URLSession.shared.data(from: feed.url)
// 이 await 시점에서:
// 1. 현재 async frame이 힙에 저장됨 → 재개 시 필요한 변수들을 보존
// 2. async 함수가 일시 중단됨 → 네트워크 응답이 올 때까지 대기
// 3. 스레드의 제어권이 반납되어 다른 작업에 사용됨 → 스레드 낭비 없음
// 4. 재개 지점을 추적하는 continuation이 생성됨 → 응답이 오면 여기서부터 실행 재개
```

---

## Structured Concurrency와 스레드 관리

### Task 의존성

Swift 런타임은 명시적 의존성을 추적한다.

```swift
// TaskGroup을 사용한 구조화된 동시성
// 각 피드를 자식 Task로 병렬 처리하되, 부모는 모든 자식이 완료될 때까지 대기
await withThrowingTaskGroup(of: [Article].self) { group in
    for feed in feedsToUpdate {
        // 각 피드마다 자식 Task 생성 → 병렬로 실행됨
        group.addTask {
            // await 시점마다 스레드를 반납하므로 코어 수만큼의 스레드로 모든 피드를 처리 가능
            let (data, response) = try await URLSession.shared.data(from: feed.url)
            let articles = try deserializeArticles(from: data)
            await updateDatabase(with: articles, for: feed)
            return articles
        }
    }
    // 부모 Task는 여기서 모든 자식 Task 완료를 대기 (이 의존성을 런타임이 명시적으로 인지)
}
```

**의존성 그래프의 특징:**

- Continuation은 해당 async 함수가 완료된 후에만 실행 가능
- 자식 Task는 부모가 진행하기 전에 반드시 완료되어야 함
- 모든 의존성이 **컴파일 타임에 명시적으로 드러남**

이러한 명시적 의존성 덕분에 런타임은:
- 지능적인 스케줄링 결정이 가능
- 스레드 데드락을 방지
- 우선순위가 높은 작업을 효율적으로 처리

---

## Actor와 상호 배제

### Actor Hopping

**Cooperative Pool 내에서의 Hopping (빠름):**

```swift
// 현재 Actor에서 database Actor로 전환 (hopping)
// 같은 Cooperative Pool 안에서의 전환이므로 OS 컨텍스트 스위칭 없이 함수 호출 수준의 비용
let ids = try await database.save(articles, for: feed)
```

- 컨텍스트 스위칭이 필요 없음
- 함수가 일시 중단되면 스레드는 즉시 다른 작업에 재사용
- 매우 낮은 오버헤드

### Actor Reentrancy (재진입)

```
비경합 상태 (contention 없음):
Sports Feed Actor → Database Actor (같은 스레드에서 직접 전환)
  └── Database Actor가 비어있으므로 스레드가 그대로 이어서 실행

경합 상태 (Actor가 바쁨):
Weather Feed Actor → Database Actor (함수가 일시 중단, 스레드의 제어권 반납)
├── Database Actor가 이미 다른 작업 중이므로 새 작업 D2가 큐에 추가
├── D2가 D1보다 먼저 완료될 수 있음 (FIFO가 아닌 유연한 순서)
└── 우선순위가 높은 작업을 먼저 실행 가능
```

### Main Actor Hopping (비용이 큼)

```swift
// 나쁜 예: 반복마다 Main Thread ↔ Cooperative Pool 간 2번의 OS 컨텍스트 스위칭 발생
@MainActor func updateArticles(for ids: [ID]) async throws {
    for id in ids {
        // Main Thread → Cooperative Pool로 컨텍스트 스위칭
        let article = try await database.loadArticle(with: id)
        // Cooperative Pool → Main Thread로 다시 컨텍스트 스위칭
        await updateUI(for: article)
    }
}

// 좋은 예: 배치 처리로 컨텍스트 스위칭을 최소화
@MainActor func updateArticles(for ids: [ID]) async throws {
    // Main Thread → Cooperative Pool로 1번만 스위칭
    let articles = try await database.loadArticles(with: ids)
    // Cooperative Pool → Main Thread로 1번만 스위칭
    await updateUI(for: articles)
}
```

Main Actor와 Cooperative Pool 사이의 전환은 OS 레벨 컨텍스트 스위칭이 필요하므로, **배치 처리로 전환 횟수를 최소화**하는 것이 중요하다.

---

## 주의 사항

### await 지점에서의 주의점

- `await` 전후로 **스레드가 바뀔 수 있다**
- **await를 넘어 락(lock)을 잡고 있으면 안 된다**
- 스레드별 데이터는 보존되지 않는다

### Runtime Contract를 지키기 위한 동기화 프리미티브

> **동기화 프리미티브(synchronization primitive)**: 동시성 환경에서 스레드 간 동기화를 위해 제공되는 가장 기본적인 도구. 락(lock), 세마포어(semaphore), 조건 변수(condition variable) 등이 이에 해당한다.

**안전한 프리미티브 (사용 가능):**
- `os_unfair_lock` — 짧고 잘 알려진 크리티컬 섹션
- `NSLock` — 주의해서 사용
- Swift Concurrency 프리미티브 — `await`, Actor, Task Group

**위험한 프리미티브 (사용 금지):**
- `DispatchSemaphore`
- `NSConditionVariable`
- 의존성을 숨기는 모든 블로킹 프리미티브

```swift
// 잘못된 예: Cooperative Thread Pool에서 forward progress contract 위반
let semaphore = DispatchSemaphore(value: 0)
Task {
    // 이 Task는 Cooperative Pool의 스레드에서 실행됨
    await someAsyncWork()
    semaphore.signal()  // 작업 완료 후 signal
}
// Cooperative Pool의 스레드를 블로킹함
// 풀의 스레드 수가 코어 수로 제한되어 있으므로 모든 스레드가 블로킹되면 교착 상태 발생
semaphore.wait()
```

`DispatchSemaphore` 같은 블로킹 프리미티브를 사용하면 Cooperative Thread Pool의 고정된 스레드가 블로킹되어 **전체 시스템이 교착 상태에 빠질 수 있다**.

### 동시성이 항상 좋은 것은 아니다

```swift
// UserDefaults 읽기는 매우 가벼운 동기 작업
// Task를 생성하고 스케줄링하는 오버헤드가 작업 자체보다 크다
group.addTask {
    return UserDefaults.standard.bool(forKey: "flag")
}
```

매우 가벼운 작업에 Task를 만드는 것은 오히려 비효율적이다. 동시성의 오버헤드가 작업 자체보다 클 수 있다.

### 디버깅 도구

Xcode scheme에서 아래 환경 변수를 설정하면 unsafe 프리미티브 사용을 감지할 수 있다:

```
LIBDISPATCH_ENABLE_PRIORITY_INVERSION_DETECTION=1
```
