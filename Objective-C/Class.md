# Class

> Objective-C의 클래스는 선언부와 구현부로 나누어져있다.



- **클래스 선언부**

  클래스 선언부는 멤버와 메서드 선언부로 나누어짐

  ``` objective-c
  #import <Foundation/Foundation.h>
  
  @interface Person : NSObject {
    
    // member variable(멤버변수)
  }
  
  // member method(메서드)
  
  @end
  ```

- **클래스 구현부**

  ``` objective-c
  #import "SomClass.h"
  
  @implementation SomeClass
  
  @end
  ```

- **멤버 변수(Member varuable) 정의**

  멤버 변수는 `@interface` 의 {} 내부에 작성

  > `Type` name;

  ```objective-c
  #import <Foundation/Foundation.h>
  
  @interface Person : NSObject {
    // member variable(멤버변수)
    // 기본값 사용 불가
    int age;
    int tall;
  }
  @end
  ```

- **멤버 메서드(Member method) 정의**

  멤버 메서드 또한 선언부와 구현부로 나누어진다

  `-`는 인스턴스 메서드, `+`는 타입 메서드를 나타낸다

  - 메서드 선언

    **- **(`ReturnType`)`methodName`:(`ParameterType`)`parameterName`;

    매개 변수가 없으면 생략한다  

    ​	**- ** (`ReturnType`)`methodName`;

    매개변수가 여러개인 경우

    > colon(:) 을 기준으로 매개변수를 나눈다
    >
    > :(타입)이름 :(타입)이름2 :(타입)이름3

    ​	 **- ** (`ReturnType`)`methodName`:(`ParameterType1`)`parameterName1` : (`ParameterType2`)`parameterName2`...;

    ​	 **- ** (`ReturnType`)`methodName`:(`ParameterType1`)`parameterName1` `ArgumentName2`: (`ParameterType2`)`parameterName2`...;

    ```objective-c
    #import <Foundation/Foundation.h>
    
    @interface Person : NSObject { //클래스 선언부
      // member variable(멤버변수)
      // 기본값 사용 불가
      int age;
      int tall;
    }
    
    // member method(메서드)
    - (void)setAge:(int)a; // (int) -> void
    - (int)age; // () -> int
    - (void)setTall:(int)t;// (int) -> void
    - (int)tall; // () -> int
    - (void)print; // -> () -> void
    - (void)setPersonAge:(int)a Tall: (int)t Number: (int)n; // (int, int, int) -> void
    - (void)setPerson:(int)a :(int)t :(int)n; // (int, int, int) -> void
    @end
    ```

  - 메서드 구현

    **- **(`ReturnType`)`methodName`:(`ParameterType`)`parameterName` { `code...` } 

    매개 변수가 없으면 생략한다

    ​	 **- **(`ReturnType`) `methodName` { `code...` } 

    매개변수가 여러개인 경우

    > colon(:) 을 기준으로 매개변수를 나눈다
    >
    > :(타입)이름 :(타입)이름2 :(타입)이름3

    ​	**- ** (`ReturnType`)`methodName`:(`ParameterType1`)`parameterName1` : (`ParameterType2`)`parameterName2`... { `code...`} 

    ​	 **- ** (`ReturnType`)`methodName`:(`ParameterType1`)`parameterName1` `ArgumentName2`: (`ParameterType2`)`parameterName2`... { `code...`} 

    ``` objective-c
    #import "Person.h"
    
    @implementation Person // 클래스 구현부
    // (-) 인스턴스 메서드
    // (+) 클래스 메서드
    
    - (int)age {
      return age;
    }
    
    - (void)setAge:(int)a {
      age = a;
    }
    
    - (int)tall {
      return tall;
    }
    
    
    - (void)setTall:(int)t {
      tall = t;
    }
    
    - (void)print {
      NSLog(@"age: %i, tall: %i", age, tall);
    }
    
    - (void)setPersonAge:(int)a Tall:(int)t Number:(int)n {
      age = a;
      tall = t;
      NSLog(@"setPerson() %i", n);
    }
    
    - (void)setPerson:(int)a :(int)t :(int)n {
      age = a;
      tall = t;
      NSLog(@"setPerson() %i", n);
    }
    @end
    ```

- **인스턴스 생성 및 메서드 호출**

  - 인스턴스 생성

    `Type` *`name` = [[`Type` alloc]init];

    `Type` *`name` = [`Type` new];

    ```objective-c
    Person *yang = [[Person alloc]init]; // 인스턴스 생성 alloc -> 메모리 동적할당을 하겠다.
    Person *yang2 = [Person new];
    ```

  - 메서드 호출

    [`InstanceName` `methodName`:`parameter`];

    매개변수가 없는 메서드는 생략 [`InstanceName` `methodName`];

    ``` objective-c
    Person *yang = [[Person alloc]init];
        
    [yang setAge:29]; // setAge 메서드 호출 (int) -> void
    [yang setTall:172]; // setTall 메서드 호출 (int) -> void
    [yang print]; // print 메서드 호출 () -> void
        
    NSLog(@"age: %i, tall: %i", [yang age], [yang tall]);
    // () -> int
    // age, tall getter 메서드를 호출하여 반환 받은 값을 NSLog로 출력
    ```

- **프로퍼티(property), 신디싸이즈(synthesize)**

  > 클래스 외부에서는 멤버 변수에 직접 접근이 불가능하기때문에 필수적으로 getter, setter 메서드를 작성하여 접근해야하는데 이런 노가다성 코드를 줄이기위해 있는것이 **프로퍼티, 신디싸이즈** 이다.

  - 프로퍼티(property)

    클래스 선언부에 사용

    ``` objective-c
    #import <Foundation/Foundation.h>
    
    @interface Person : NSObject {
      // member variable(멤버변수)
      // 기본값 사용 불가
      int age;
      int tall;
    }
    
    // member method(메서드)
    // getter, setter 생략
    @property int age;
    @property int tall;
    
    @end
    ```

  - 신디싸이즈(synthesize)

    클래스 구현부에 사용

    ``` objective-c
    #import "Person.h"
    
    @implementation Person
    
    // getter, setter 생략
    @synthesize age;
    @synthesize tall;
    
    @end
    ```

  - 호출

    자동으로 getter, setter의 이름이 정해진다

    **Getter** : `name` 

    **Setter** : `getName` 

    ``` objective-c
    Person *yang = [[Person alloc]init]; // 인스턴스 생성 alloc -> 메모리 동적할당을 하겠다.
    [yang setAge:29]; // age -> setter
    [yang setTall:172]; // tall -> setter
    NSLog(@"age: %i, tall: %i", [yang age], [yang tall]);
    // age, tall -> getter
    ```

    

    기존 함수 호출방식이 아닌 점연산자(dot operator) 가능

    ``` objective-c
    Person *yang = [[Person alloc]init];
    yang.age = 20;
    yang.tall = 180;
    NSLog(@"age: %i, tall: %i", yang.age, yang.tall);
    ```

  - 옵션(Property 재정의)

    getter, setter의 이름을 재정의 할 수 있다.

    @property (`Options`) `Type` `name`;

    ``` objective-c
    #import <Foundation/Foundation.h>
    
    @interface Person : NSObject {
      int age;
      int tall;
    }
    
    @property (getter = getAge, setter = changeAge:) int age; 
    // setter의 :은 매개변수를 받아야 하기때문에 넣어야한다.
    @property (getter = getTall) int tall;
    -(void)print;
    
    @end
    
    ```

