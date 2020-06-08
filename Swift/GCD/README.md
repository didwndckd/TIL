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
  



  