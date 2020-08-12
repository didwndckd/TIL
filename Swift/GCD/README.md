# GCD(Grand Central Dispatch)

- GCD 이전에는 멀티 스레딩을 위해 `Thread`와` OperationQueue` 등의 클래스를 사용했는데, 

  `Thread`는 복잡하고 `Critical Section` 등을 이용한` Lock` 을 관리하기가 까다로웠고,

  `OperationQueue` 는 `GCD` 에 비해 무겁고 `Boilerplate` 코드들이 많이 필요한 문제가 있음
  
- Thread 관리와 실행에 대한 책임을 applecation level에서 OS level로 넘겨 멀티 코어 프로세서 시스템에 대한 응용프로그램 지원을 최적화

- 작업의 단위는 Block 이라 불리며, DispatchQueue가 이 Block 들을 관리

- GCD는 각 어플리케이션에서 생성된 `DispatchQueue`를 읽는 멀티코어 실행 엔진을 가지고 있으며,

  이것이 Queue에 등록된 각 작업을 꺼내 스레드에 할당
  
- 개발자는 내부 동작을 자세히 알 필요 없이 Queue에 작업을 넘기기만 하면 됨

- `Thread`를 직접 생성하고 관리하는것에 비해 용이성과 이식성, 성능 증가

- 장점

  - 앱의 메모리 공간에 thread stack을 저장하기 위한 memory penalty를 줄임
  - Thread를 생성하고 구성하는데 필요한 코드를 제거
  - Thread 작업을 관리하고 예약하는데 필요한 코드를 제거
  

## Dispatch Framework

> 멀티코어 하드웨어에서 다중 작업을 동시에 수행할 수 있도록 관리하기 위한 프레임워크
>
> 시스템에서 관리하는 `DispatchQueue`에 작업을 전달하여 수행

## DispatchQueue

- Dispatch Framework
  - 멀티코어 하드웨어에서 다중작업을 동시에 수행할 수 있도록 관리하기 위한 Framework
  - 시스템에서 관리하는 `DispatchQueue`
- GCD는 앱이 `Block`객체 형태로 작업을 전송할 수 있는 FIFO 대기열(Queue)을 제공하고 관리
- Queue에 전달된 작업은 시스템이 전적으로 관리하는 스레드 풀(a pool of threads)에서 실행
- 작업이 실행될 Thread는 보장되지 않음 (어떤 Thread에서 작업이 될지 알 수 없음)
- DispatchQueue는 2개의 타입(**Serial / Concurrent**)으로 구분되면 둘 모두 FIFO 순서로 처리
- 앱을 실행하면 시스템이 자동으로 메인스레드 위헤서 동작하는 Main 큐(Serial Queue)를 만들어 작업을 수행하고, 그 외에 추가적으로 여러 개의 Global Queue(Concurrent Queue)를 만들어서 큐를 관리
- 각 작업은 동기(sync) 방식과 비동기(async)방식으로 실행 가능하지만 **Main Queue(Main Thread 내에서 호출되는)**에서는 **async**만 사용가능

### Serial(직렬성), Concurrent(동시성), Sync(동기), Async(비동기)

- `DispatchQueue`는 **Serial / Concurrent Queue**로 구분, 각 queue에서는 들어온 작업 **block**들을 **Sync / Async** 방식으로 실행
- **Serial / Concurrent**: **하나의 queue**안에서 작업 실행 방식을 결정
- **Sync / Async**: **해당 Thread**의 작업 실행 방식을 결정



#### Serial / Concurrent

- **Serial**: Queue에 등록된 작업들을 순서대로 실행. **다음 작업이 실행될 때는 이전 작업이 종료**된 것이 보장됨
- **Concurrent**: 작업들이 queue에 등록되는 순서와 상관없이 실행 순서를 보장하지 않음
  - **Concurrency**: 논리적 병렬. 동시에 실행되는 것 처럼 보이지만 실제로는 빠른 속도로 왔다갔다 하면서 실행

####  Sync / Async

- **Synchronous**: **해당 Thread 내에서** 하나의 작업이 완전히 끝나야 다음 작업을 실행
- **Asynchronous**: **해당 Thread 내에서** 어떤 작업이 완료되는 것을 기다리지 않고 다음 작업을 실행

#### Available Cases

|                    | Queue 내부 작업 순서 | 전체 작업 순서 |
| ------------------ | -------------------- | -------------- |
| Serial - Sync      | O                    | O              |
| Serial - Async     | O                    | X              |
| Concurrent - Sync  | O                    | O              |
| Concurrent - Async | X                    | X              |



- **Serial - Sync**: Serial Queue에 전달된 작업이 완전히 끝난뒤 다음 작업이 실행됨.

  ```swift
  let serialQueue = DispatchQueue(label: "kr.doan.serialQueue")
  serialQueue.sync { log("1") }
  log("A")
  serialQueue.sync { log("2") }
  log("B")
  serialQueue.sync { log("3") }
  log("C")
  // 1 - A - 2 - B - 3 - C 
  ```

- **Serial - Async**: Serial Queue에 작업을 전달하고 작업의 종료와 상관없이 다음 작업을 실행하고 Queue 내부의 작업 순서를 보장함.

  ```swift
  let serialQueue = DispatchQueue(label: "kr.doan.serialQueue")
  serialQueue.async { self.log("1") }
  log("A")
  serialQueue.async { self.log("2") }
  log("B")
  serialQueue.async { self.log("3") }
  log("C")
  //1 - A - B - C - 2 - 3
  ```

- **Concurrent - Sync**: Concurrent Queue에 전달한 작업이 완전히 끝난뒤 다음 작업이 실행됨.

  ```swift
  let concurrentQueue = DispatchQueue(label: "kr.doan.concurrentQueue", attributes: [.concurrent])
  concurrentQueue.sync { log("1") }
  log("A")
  concurrentQueue.sync { log("2") }
  log("B")
  concurrentQueue.sync { log("3") }
  log("C")
  // 1 - A - 2 - B - 3 - C 
  ```

- **Concurrent - Async**: Concurrent Queue에 전달한 작업의 종료와 상관없이 다음 작업을 실행하고 Queue 내부의 작업 순서를 보장하지 않음.

  ```swift
  let concurrentQueue = DispatchQueue(label: "kr.doan.concurrentQueue", attributes: [.concurrent])
  concurrentQueue.async { self.log("1") }
  log("A")
  concurrentQueue.async { self.log("2") }
  log("B")
  concurrentQueue.async { self.log("3") }
  log("C")
  concurrentQueue.async { self.log("4") }
  log("D")
  // A - B - 1 - 3 - C - 2 - 4 - D
  ```

  

### System Dispatch Queue

- system이 제공하는 Queue: **Main, Globak**
- **Main Queue (Serial Queue)**
  - UI와 관련된 모든 작업을 수행
  - Main Thread에서 Main Queue를 sync로 동작시키면 dead lock에 빠지게됨.
- **Global Queue (Concurrent Queue)**
  - UI를 제외한 작업에 사용 (Main Thread에서 동작할 수 있게 한다면 UI작업을 할수는 있기는 함)



### Custom Dispatch Queue

- **Serial / Concurrent 및 Qos** 등 을 지정할 수 있다

  ```swift
  convenience init(
    label: String, 								
    qos: DispatchQoS = .unspecified, 
    attributes: DispatchQueue.Attributes = [], 
    autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency = .inherit, 
    target: DispatchQueue? = nil
  )
  
  let queue = DispatchQueue(label: "doan.serialQueue")
  
  let queueOptions = DispatchQueue(
    label: "doan.concurrentQueue",
  	qos: .userInteractive,
  	attributes: [.concurrent]
  )
  ```

  - label: queue를 식별하기위한 문자열
  - qos: 우선순위
  - attributes: 속성(Concurrent .... ), 따로 지정해주지 않으면 SerialQueue
  - autoreleaseFrequency: 대기열이 예약하는 블록에 의해 생성 된 객체를 자동 해제하는 빈도
  - target: 블록을 실행할 대상 큐.



### DispatchQoS (Quality of Service)

- 시스템은 **QoS** 정보를 통해 스케쥴링, CPU 및 I/O 처리량, 타이머 대기 시간 등의 우선 순위를 조정
- 총 6개의 **QoS** 클래스가 있으며 4개의 주요 유형과 다른 2개의 특수 유형으로 구분 가능

#### primary QoS Classes

> 우선순위가 높을 수록 더 빨리 수행되고 더 많은 전력을 소모
>
> 수행 작업에 적절한 **QoS** 클래스를 지정해주어야 더 반응성이 좋아지며, 효율적인 에너지 사용이 가능

- **userInteractive**
  - 즉각 반응해야 하는 작업으로 반응성 및 성능에 중점
  - **main thread** 에서 동작하는 인터페이스 새로고침, 애니메이션 작업 등 즉각 수행되는 유저와의 상호작용 작업에 할당
- **userInitiated**
  - 몇 초 이내의 짧은 시간 내 수행해야 하는  작업으로 반응성 및 성능에 중점
  - 문서를 열거나, 버튼을 클릭해 액션을 수행하는 것 처럼 빠른 결과를 요구하는 유저와의 상호작용 작업에 할당
- **utility**
  - 수초에서 수분에걸쳐 수행되는 작업으로 반응성, 성능 그리고 에너지 효율성 간에 균형을 유지하는데 중점
  - 데이터를 읽어들이거나 다운로드 하는 등 작업을 완료하는데 어느 정도 시간이 걸릴 수 있으며 보통 진행 표시줄로 표현
- **background**
  - 수분에서 수시간에 걸쳐 수행되는 작업으로 에너지 효율성에 중점. `NSOperation`클래스 사용 시  기본 값
  - `background`에서 동작하며 색인 생성, 동기화, 백업 같이 사용자가 볼 수 없는 작업에 할당
  - 저전력 모드에서는 네트워킹을 포함하여 백그라운드 작업은 일시 중지



#### Special QoS Classes

> 일반적으로, 별도로 사용할 일이 없는 특수 유형의 **QoS**

- **default**
  - **QoS**를 별도로 지정하지 않으면 기본값으로 사용되는 형태이며 **userIntiated 와 utility의 중간 레벨**
  - **GCD global queue**의 기본 동작 형태
- **unspecified**
  - **QoS** 정보가 없으므로 시스템이 **QoS**를 추론해야 한다는 것을 의미



#### DispatchQueue.Attributes

- `.concurrent`: **Concurrent Queue**로 생성. 이 옵션 미 지정시 **Serial Queue**가 기본값

- `.initallyInactive`: **Inactive**상태로 생성. 작업 수행 시점에 `activate()` 메서드를 호출해야 동작

  ```swift
  extension DispatchQueue {
  public struct Attributes : OptionSet {
  public static let concurrent: DispatchQueue.Attributes
  public static let initiallyInactive: DispatchQueue.Attributes
  	} 
  }
  ```

  

### DispatchWorkItem






















