# Array

> 정적 배열, 동적 배열

- [NSArray](https://github.com/JoongChangYang/TIL/blob/master/Objective-C/Array.md#nsarray)
- [NSMutableArray](https://github.com/JoongChangYang/TIL/blob/master/Objective-C/Array.md#nsmutablearray)
- [Method](https://github.com/JoongChangYang/TIL/blob/master/Objective-C/Array.md#method)

## NSArray

> 정적 배열로 변경할 수 없다.

### 초기화

> 여러가지 객체들을 넣어줄 수 있다.
>
> 끝을알리기위해 마지막 인자는 nil이 들어가야 한다.

- `- (instancetype)initWithObjects:(ObjectType)firstObj, ...;`

  > 인스턴스 메서드로 동적할당 후 호출 가능

  ``` objective-c
  NSArray *summer = [[NSArray alloc]initWithObjects:@"6월", @"7월", @"8월", nil];
  ```

- `+ (instancetype)arrayWithObjects:(ObjectType)firstObj, ...;`

  > 클래스 메서드로 메서드 내부에서 동적할당까지 해줌.

  ``` objective-c
  NSArray *friendList = [NSArray arrayWithObjects:@"철규", @"민석", @"동연", @"태훈", @"태헌", nil];
  ```

- 배열 리터럴 사용

  > 배열 리터럴 구문을 사용하여 주어진 객체를 포함하는 배열을 만들 수 있다.

  ``` objective-c
  NSArray *numbers = @[@(1), @(2), @(3), @(4), @(5)];
  ```

## NSMutableArray

> 가변 배열로 변경이 가능하다.

### 초기화

- `+ (instancetype)arrayWithArray:(NSArray<ObjectType> *)array;`

  > NSArray를 인자로 받아 NSMutableArray를 초기화 할 수 있다.

  ``` objective-c
  NSArray *summer = [[NSArray alloc]initWithObjects:@"6월", @"7월", @"8월", nil];
  NSMutableArray *mSummer = [NSMutableArray arrayWithArray:summer];
  ```



## Method

> 배열의 메서드 모음



### 요소 접근

- Index 접근

  ``` objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  
  NSNumber *number = [numbers objectAtIndex:0];
  // Index 0 요소 반환 -> 0
  
  NSNumber *number = numbers[3];
  // Index 3 요소 반환 -> 3
  ```

- Property 접근

  ``` objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  
  NSNumber *number = [numbers firstObject];
  // 배열의 첫번째 요소 반환 -> 0
  
  NSNumber *number = [numbers lastObject];
  // 배열의 마지막 요소 반환 -> 5
  ```



### 요소 추가

> 가변 배열에서만 가능

- `- (void)addObject:(ObjectType)anObject;`

  > 배열의 맨 마지막 자리에 요소 추가

  ``` objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  NSMutableArray *mNumbers = [NSMutableArray arrayWithArray:numbers];
  // [0, 1, 2, 3, 4, 5]
  
  [mNumbers addObject:@10];
  // [0, 1, 2, 3, 4, 5, 10]
  ```

- `- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;`

  > 매개 변수로 들어간 index에 요소 추가

  ``` objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  NSMutableArray *mNumbers = [NSMutableArray arrayWithArray:numbers];
  // [0, 1, 2, 3, 4, 5]
  
  [mNumbers insertObject:@10 atIndex:3];
  // [0, 1, 2, 10, 3, 4, 5]
  ```

### 요소 수정

> 가변 배열에서만 가능

- `- (void)setObject:(ObjectType)obj atIndexedSubscript:(NSUInteger)idx;`

  > 매개 변수로 들어간 index의 요소 수정

  ``` objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  NSMutableArray *mNumbers = [NSMutableArray arrayWithArray:numbers];
  // [0, 1, 2, 3, 4, 5]
  
  [mNumbers setObject:@10 atIndexedSubscript:0];
  // [10, 1, 2, 3, 4, 5]
  ```

### 요소 삭제

> 가변 배열에서만 가능

- `- (void)removeObjectAtIndex:(NSUInteger)index;`

  > 매개 변수로 들어간 index의 요소 삭제

  ```objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  NSMutableArray *mNumbers = [NSMutableArray arrayWithArray:numbers];
  // [0, 1, 2, 3, 4, 5]
      
  [mNumbers removeObjectAtIndex:0];
  // [1, 2, 3, 4, 5]
  ```

- `- (void)removeObject:(ObjectType)anObject;`

  > 매개 변수로 들어간 요소를 비교하여 일치하는것을 모두 삭제

  ``` objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  NSMutableArray *mNumbers = [NSMutableArray arrayWithArray:numbers];
  // [0, 1, 2, 3, 4, 5]
  
  [mNumbers removeObject:@2];
  // [0, 1, 3, 4, 5]
  ```

- `- (void)removeLastObject;`

  > 마지막 요소 삭제

  ``` objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  NSMutableArray *mNumbers = [NSMutableArray arrayWithArray:numbers];
  // [0, 1, 2, 3, 4, 5]
      
  [mNumbers removeLastObject];
  // // [0, 1, 2, 3, 4] 
  ```

- `- (void)removeAllObjects;`

  > 모든 요소를 삭제

  ``` objective-c
  NSArray *numbers = @[@0, @1, @2, @3, @4, @5];
  NSMutableArray *mNumbers = [NSMutableArray arrayWithArray:numbers];
  // [0, 1, 2, 3, 4, 5]
  
  [mNumbers removeAllObjects];
  // []
  ```

  





















