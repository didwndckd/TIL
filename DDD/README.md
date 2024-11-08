# 6장 어플리케이션 서비스

- 도메인 서비스와 어플리케이션 서비스의 차이..?
  - 도메인 서비스: 도메인을 위한 처리를 하는 서비스
  - 어플리케이션 서비스: 어플리케이션을 위한 서비스
  - 뭐가 도메인을 위한 처리이고 뭐가 어플리케이션을 위한 처리인지 혼란하다..
- 도메인 객체를 그대로 반환값으로 사용할지 말지에 대한 선택이 중요한 분기점
  - 도메인 객체를 공개하는 경우
    - 코드가 비교적 간단해진다
    - 의도하지 않은 도메인 객체의 메서드 호출이 가능하다는 점이 문제
      - 의도하지 않은 도메인 객체의 메서드 호출이 무의미하더라도 진짜 문제는 애플리케이션 서비스가 아닌 객체가 도메인 객체의 직접적인 클라이언트가 되어 도메인 객체를 자유롭게 조작한다는 점이 문제
    - 도메인 객체의 행동을 호출하는 것은 애플리케이션 서비스의 책임이다. 이 구조가 지켜진다면 도메인 객체의 행동을 호출하는 코드가 모두 애플리케이션 서비스 안에 모여있지만 그렇지 않다면 여러 곳에 코드가 흩어질 수 있다.
    - 도메인 객체에 대한 의존이 많이 생기는 것도 문제.
  - 도메인 규칙의 유출
    - 애플리케이션 서비스는 도메인 객체가 수행하는 테스크를 조율하는데만 전념해야 한다. 
    - 애플리케이션 서비스에서 도메인 규칙을 기술해서는 안된다.
      - 애플리케이션 서비스에 도메인 규칙을 기술한 상태에서 도메인 규칙이 변경되었을 때 이에 맞춰 애플리케이션 서비스의 코드도 수정되어야 하기때문에 문제가 발생 할 수 있고 코드가 많아지면 많아질수록 문제가 발생할 확률이 더 많아진다.
      - 애플리케이션 서비스에서는 도메인 객체를 사용하는 역할만 한다.

# 7장 소프트웨어의 유연성을 위한 의존 관계 제어

- 의존 관계 역전의 원칙
  - 추상화 수준이 높은 모듈이 낮은 모듈에 의존해서는 안되며 두 모듈 모두 추상 타입에 의존해야 한다.
  - 추상 타입이 구현부의 세부 사항에 의존해서는 안된다. 구현의 세부 사항이 추상 타입에 의존해야 한다.
- 추상화 수준: 입/출력으로부터의 거리
  - 추상화 수준이 낮다는 것은 기계와 가까운 구체적인 거리를 말하며 추상화 수준이 높다는 것은 사람과 가까운 추상적인 처리를 말한다.
- 주도권을 추상 타입에 둬라!
  - 추상 타입이 세부사항에 의존하면 낮은 추상화 수준의 모듈에서 일어난 변경이 높은 추상화 수준의 모듈까지 영향을 미치게 되는 이상한 상황이 발생한다. 중요도가 높은 도메인 규칙은 항상 추상화 수준이 높은 쪽에 기술되는데, 낮은 추상화 수준의 모듈에서 일어난 변경 때문에 더 중요한 추상화 수준이 높은 모듈을 수정해야하는 상황이 일어나는 것이다. 이는 바람직한 상황이 아니다. 
  - 주체가 되는것은 추상화 수준이 높은 모듈, 추상타입이어야 한다. 추상화 수준이 낮은 모듈이 주체가 되어서는 안된다.
  - 추상화 수준이 높은 모듈은 낮은 모듈을 이용하는 클라이언트이다. 주도권은 인터페이스를 사용할 클라이언트에 있다.(UseCase)

# 8장 소프트웨어에 꼭 필요한 사용자 인터페이스

- 단위 테스트
  - 정상 케이스 뒤에는 이상 케이스에 대한 테스트를 작성한다.
  - 어떤 입력이 들어와야 하는지, 입력에 대한 결과가 어떠해야 하는지를 기술하는 요령으로 작성한다.
  - 문서화가 전혀 안되어있는 프로젝트라면 단위 태스트가 로직의 설계를 보여주는 마지막 단서가 되기도 한다.
  - 단위 테스트가 있다고 해서 무조건 소프트웨어의 품질이 향상되는 것은 아니지만, 코드가 단위 테스트를 수행할 수 있는 상태에 이르는 것은 품질 향상의 첫걸음이다.
  - 단위테스트가 잘 갖춰져 있다면 리팩토링이 기존 기능을 망가뜨리지 않음을 확인하면서 작업을 진행할 수 있다.

# 9장 복잡한 객체 생성을 맡길 수 있는 팩토리 패턴

- 복잡한 도구는 만드는 과정도 복잡하다. 복잡한 객체를 생성하기 위한 복잡한 처리는 도메인 모델을 나타낸다는 객체의 취지를 불분명하게 만든다. 그렇다고 객체 생성을 무작정 클라이언트에게 맡기는 것도 좋은 방법이 아니다. 여기서 바로 객체 생성 과정을 객체로 정의할 필요가 생긴다. 이렇게 객체 생성을 책임지는 객체를 **팩토리**라고 부른다.
- 팩토리의 존재감 인식시키기
  - User, UserFactory가 있을 때 같은 패키지 안에 넣어두면 누군가 해당 패키지를 열었을 때 User와 UserFactory가 함께 있는것을 보게 될 것이고 팩토리의 존재를 인지할 것이다.
- 팩토리를 통해 생성 절차가 복잡한 객체를 생성하면 코드의 의도를 더 분명히 드러낼 수 있고 똑같은 객체 생성 코드가 중복되는것도 막을 수 있다.





# 10장 데이터의 무결성 유지하기

- 무결성이란 서로 모순이 없고 일관적이라는 뜻
- 데이터 무결성을 특정 기술에 의존해서는 안된다. 특정 기술에서 제공하는 데이터 무결성은 규칙을 준수하는 주 수단이 아니라 안전망 역할로 활용해야 한다.
  - 예를들어 사용자명에 특정 데이터베이스의 유일키 제약을 적용한다면 사용자명은 사용자명 중복이 없다는 것은 보장되지만 비즈니스 로직이 특정한 기술에 의존하게되고 이는 도메인에 있어 매우 중요한 규칙과 관련된 처리가 원래 있어야 할 장소에서 이탈한 상태이다.
- 비즈니스 로직에서는 데이터 무결성을 확보하기 위한 구체적인 구현 코드보다는 **이부분에서 데이터 무결성을 확보해야 한다**는 것을 명시적으로 보여주는 코드가 담겨야 한다.
  - 비즈니스 로직의 입장에서는 무결성을 지키는 수단이 무엇이냐는 그리 중요하지 않다. 
  - 데이터의 무결성을 확보하는 것 자체는 추상화 수준이 낮은 특정 기술 기반의 역할이다.

# 11장 애플리케이션 바닥부터 만들기

- 말과 어긋나는 코드가 일으킬 수 있는 일

  - 서클에 소속된 사용자의 수는 서클장과 사용자를 포함해 최대 30명이다 라는 규칙이 있을 때 

    ``` swift
    // 서클장 + 멤버 수가 최대 30명 -> 서클장을 제외하고 최대 29명
    if circle.members.count >= 29 {
      // code..
    }
    ```

    코드에서 위와 같이 말로 표현된 30과 다른 29라는 숫자를 사용하게되면 추후에 서클 클래스의 구현 세부사항을 모르는 개발자가 30으로 수정할 우려가 있다. 때문에 규칙에 나오는 30이라는 숫자를 코드에도 그대로 사용하는 것이 바람직하다.

  - 클래스의 구현 세부사항을 외부로 노출하는 것은 가능한 피해야 한다.

- 규칙이 도메인 객체를 이탈했을 때 생기는 일
  - 도메인 규칙에서 중요도가 높은 규칙은 도메인 객체에 구현되어야 한다.
  - 이를 위반하고 애플리케이션 서비스에 이러한 규칙이 구현되면 같은 규칙을 나타내는 코드가 중복 작성될 수 있다.
  - 코드의 중복은 그 코드를 변경할 일이 생겼을 때 문제가 된다.

# 12장 도메인의 규칙을 지키는 '애그리게이트'

- 애그리게이트의 기본 구조
  - 애그리게이트는 서로 연관된 객체를 감싸는 경계를 통해 정의된다.
  - 외부에서는 애그리게이트 내부에 있는 객체를 조작할 수 없다.
  - 애그리게이트를 조작하는 직접적인 인터페이스가 되는 객체는 애그리게이트 루트뿐이다.
- 데메테르의 법칙
  - 모듈은 자신이 조작하는 객체의 속사정을 몰라야 한다
  - 데메테르의 법칙은 어떤 컨텍스트에서 다음 객체의 메서드만을 호출할 수 있게 제한한다.
    - 객체 자신
    - 인자로 전달받은 객체
    - 인스턴스 변수
    - 해당 컨텍스트에서 직접 생성한 객체
- 애그리게이트의 크기가 지나치게 커지면 애그리게이트를 대상으로하는 처리가 실패할 가능성도 높다. 따라서 애그리게이트의 크기는 가능한 작게 유지하는 것이 좋다.



# 13장 복잡한 조건을 나타내기 위한 '명세'

- 명세는 어떤 객체가 그 객체의 평가 기준을 만족 하는지 판정하기 위한 객체다.
- 객체에 대한 평가는 도메인 규칙 중에서도 중요도가 높은 것으로 서비스에 구현하기에 걸맞은 내용이 아니다. 이를 위한 대책으로 많이 쓰이는것이 명세다.
- 엔티티나 값 객체가 도메인 모델을 나타내는 데 전념할 수 있으려면 리포지토리를 다루는 것은 가능한 한 피해야 한다.
- 객체를 평가하는 코드를 곧이곧대로 해당 객체에 구현하면 객체의 원래 의도가 잘 드러나지 않는다.
  - 흠.... 그런가..? 
  - 객체 평가 메서드를 이렇게 객체에 그대로 남겨두면 객체에 대한 의존이 무방비하게 증가해 변경이 닥쳤을 때 어려움을 겪는다.(이부분은 약간 공감?)
- 도메인의 보호를 이유로 사용자에게 불편을 강요하는 것은 결코 옳은 길이 아니다.



# 14장 아키텍처

- 도메인 주도 설계에서 아키텍처는 결코 주역이 아니다.

- 도메인 주도 설계에서 중요한 것은 도메인을 분리하는 것이지, 어떤 아키텍처를 반드시 써야 한다는 것은 아니다.

- 계층형 아키텍처

  - 프레젠테이션 계층(사용자 인터페이스 계층)
  - 애플리케이션 계층
  - 도메인 계층
  - 인프라스트럭처 계층

- 헥사고날 아키텍처

  - 육각형이 모티브인 아키텍처
  - 콘셉트는 애플리케이션과 그 외 인터페이스나 저장 매체를 자유롭게 탈착 가능하게 하는것

- 클린 아키텍처

  - 사용자 인터페이스나 데이터스토어 같은 세부사항은 가장자리로 밀어내고, 의존관계의 방향을 안쪽을 향하게 함으로써 세부사항이 추상에 의존하는 의존관계 역전 원칙을 달성
  - 헥사고날 아키텍처와 목적하는바가 같다.
  - 헥사고날 아키텍처와의 가장 큰 차이점은 구현 내용이 언급되는지 여부에 있다.
  - 콘셉트를 실현하기 위한 구체적 구현 방식이 명시된다.

  # 15장 앞으로의 학습
  
  - 도메인 주도 설계의 진짜 목표는 그저 패턴을 적용하는 것만이 아니다.
  
  - 가장 중요한 것은 도메인의 본질을 파악하는 것
  
  - 개발자가 쓰는 언어가 시스템의 관점에 더 가까울수록, 이를 듣는 도메인 전문가는 대화를 포기하고싶어질 것이다.
  
    - 언어의 차이때문에 서로간의 이해를 포기하면 결국 도메인과 코드가 단절되는 결과를 낳는다.
    - 시스템 관점의 언어를 도메인 전문가의 언어로 변환하기보다는 도메인 개념을 왜곡하지 않는 개발자와 도메인 전문가 사이의 공통 언어로 소통해야 한다.
  
  - 보편언어
  
    - 한가지 개념에 여러 이름이 붙어 있다면 당연히 의사소통에 혼란이 올 것이다.
  
    - 도메인에서 자연스러운 표현을 코드에도 충실히 표현되어야 한다.
  
      ``` swift
      // 도메인에서의 표현이 '사용자명 변경하기'일 때
      func changeName(name: String)
      // 도메인에서의 표현이 '사용자명 수정하기'일 때
      func updateName(name: String)
      ```
  
  - 시스템의 규모가 커지면 통일된 모델을 유지하기가 어렵다. 변경에 어려움이 생기지 않게 하려면 모델을 포착하는 방식이 달라지는 지점에서 시스템을 분할하고 분할된 영역마다 언어를 통일한다.
  
    - 영역을 분할한다는 것은 경계를 긋는 것이며 이 경계가 바로 컨텍스트의 경계다.