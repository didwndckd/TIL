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
- 각 작업은 동기(sync) 방식과 비동기(async)방식으로 실행 가능하지만 **Main Queue**에서는 **async**만 사용가능

### Serial(직렬성), Concurrent(동시성), Sync(동기), Async(비동기)

- `DispatchQueue`는 **Serial / Concurrent Queue**로 구분, 각 queue에서는 들어온 작업 **block**들을 **Sync / Async** 방식으로 실행
- **Serial / Concurrent**: **하나의 queue**안에서 작업실행 방식을 결정
- **Sync / Async**: **서로다른 queue**간에 작업 실행 방식을 결정



#### Serial / Concurrent

- **Serial**: Queue에 등록된 작업들을 순서대로 실행. **다음 작업이 실행될 때는 이전 작업이 종료**된 것이 보장됨
- **Concurrent**: 작업들이 queue에 등록되는 순서와 상관없이 실행 순서를 보장하지 않음
  - **Concurrency**: 논리적 병렬. 동시에 실행되는 것 처럼 보이지만 실제로는 빠른 속도로 왔다갔다 하면서 실행

####  Sync / Async

- **Synchronous**: 하나의 작업이 완전히 끝나야 다음 작업을 실행
- **Asynchronous**: 어떤 작업이 완료되는 것을 기다리지 않고 다음 작업을 실행

### Available Cases

|                    | Queue 내부 작업 순서 | 전체 작업 순서 |
| ------------------ | -------------------- | -------------- |
| Serial - Sync      | O                    | O              |
| Serial - Async     | O                    | X              |
| Concurrent - Sync  | O                    | O              |
| Concurrent - Async | X                    | X              |






































