# Dictionary
> 딕셔너리



- [NSDictionary]()
- [NSMutableDictionary]()
- [Method]()



## NSDictionary

> 정적 딕셔너리로 변경할 수 없다.

### 초기화

> 여러가지 객체들을 넣어줄 수 있다.
>
> 끝을알리기위해 마지막 인자는 nil이 들어가야 한다.
>
> 다른 언어와는 다르게 `value: key` 순서로 넣어줘야 함

- `- (instancetype)initWithObjectsAndKeys:(id)firstObject, ...;`

  > 인스턴스 메서드로 동적할당 후 호출 가능

  ``` objective-c
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"value", @"key", @"value2", @"key2", nil];
  ```

- `+ (instancetype)dictionaryWithObjectsAndKeys:(id)firstObject, ...;`

  > 클래스 메서드로 메서드 내부에서 동적할당까지 해줌.

  ``` objective-c
  NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"value", @"key", @"value2", @"key2", nil];
  ```

  

## NSMutableDictionary

> 가변 배열로 변경이 가능하다.



### 초기화

- `+ (instancetype)dictionaryWithDictionary:(NSDictionary<KeyType, ObjectType> *)dict;`

  > NSDictionary를 매개 변수로 받아 NSMutableDictionary를 생성

  ``` objective-c
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"value", @"key", @"value2", @"key2", nil];
  NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
  ```

  

## Method

> 딕셔너리의 메서드 모음



### 요소 접근

- `- (ObjectType)objectForKey:(KeyType)aKey;`

  > 매개 변수로 받은 key의 value를 반환

  ``` objective-c
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"양중창", @"이름", @"모름", @"나이", nil];
  NSString *age = [dic objectForKey:@"나이"];
  // 모름
  ```

- ` dic[key]`

  ``` objective-c
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"양중창", @"이름", @"모름", @"나이", nil];
  NSString *name = dic[@"이름"];
  // 양중창
  ```



### 요소 추가, 수정

- `- (void)setObject:(ObjectType)anObject forKey:(id<NSCopying>)aKey;`

  > 매개 변수로 받은 key에 전달 받은 value 할당
  >
  > 기존의 값이 있다면 수정, 없다면 추가.

  ``` objective-c
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"양중창", @"이름", @"모름", @"나이", nil];
  NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
  // ["이름": "양중창", "나이": "모름"]
  
  [mDic setObject:@"윤철규" forKey:@"친구"];
  // ["이름": "양중창", "나이": "모름", "친구": "윤철규"]
  [mDic setObject:@"29" forKey:@"나이"];
  // ["이름": "양중창", "친구": "윤철규", "나이": "29"]
  ```

### 요소 삭제

- `- (void)removeObjectForKey:(KeyType)aKey;`

  > 매개 변수로 받은 key에 value 삭제

  ``` objective-c
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"양중창", @"이름", @"모름", @"나이", nil];
  NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
  // ["이름": "양중창", "나이": "모름"]
  
  [mDic removeObjectForKey:@"나이"];
  // ["이름": "양중창"]
  ```

- `- (void)removeAllObjects;`

  > 딕셔너리의 모든 요소 삭제

  ``` objective-c
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"양중창", @"이름", @"모름", @"나이", nil];
  NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
  // ["이름": "양중창", "나이": "모름"]
  
  [mDic removeAllObjects];
  // []
  ```

  









