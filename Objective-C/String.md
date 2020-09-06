# String

> 문자열

- [NSString]()
- [NSMutableString]()

## NSString

> 기본 문자열 클래스 자기 자신을 바꿀 수 없다.

### 초기화

- initialization

  NSString 동적할당 이후 값을 넣어주는방식

  ``` objective-c
  NSString *str = [[NSString alloc]init];
  str = @"This is NSString";
  ```

- Conveniance initialization

  NSString 동적할당과 동시에 값을 넣어 초기화

  ``` objective-c
  NSString *str = [[NSString alloc]initWithString:@"This is NSString"];
  
  NSString *str = @"This is NSString";
  ```

### 관련 함수

#### substring

- `- (NSString *)substringFromIndex:(NSUInteger)from; `

  > form ~ end 까지의 문자열을 반환
  
  ```objective-c
  NSString *str = @"This is NSString";
  NSString *result;
  result = [str substringFromIndex:6];
  NSLog(@"result: %@", result);
  // 6 ~ 끝까지
  // s NSString
  ```
  
- `- (NSString *)substringToIndex:(NSUInteger)to;`

  > 0 ~ to 까지의 문자열을 반환

  ``` objective-c
  NSString *str = @"This is NSString";
  NSString *result;
  
  result = [str substringToIndex:6];
  NSLog(@"result: %@", result);
  // 0 ~ 6까지
  // This i
  ```

- ` - (NSString *)substringWithRange:(NSRange)range;`

  > NSRange 값에 위치한 문자열을 반환

  ``` objective-c
  NSString *str = @"This is NSString";
  NSString *result;
  
  NSRange range = NSMakeRange(8, 3);
  result = [str substringWithRange:range];
  NSLog(@"result: %@", result);
  // NSRange 값에 위치한 문자열을 반환
  // 8 ~ 10
  // NSS
  ```

  

#### uppercase, lowercase

- `@property(readonly, copy) NSString *lowercaseString;`

  > 모든 문자를 소문자로 변경한 문자열 반환

  ``` objective-c
  NSString *str = @"This is NSString";
  NSString *result;
  
  result = [str lowercaseString];
  NSLog(@"result: %@", result);
  // 모든 문자를 소문자로 변경
  // this is nsstring
  ```

- `@property(readonly, copy) NSString *uppercaseString;`

  > 모든 문자를 대분자로 변경한 문자열 반환

  ``` objective-c
  NSString *str = @"This is NSString";
  NSString *result;
  
  result = [str uppercaseString];
  NSLog(@"result: %@", result);
  // 모든 문자를 대문자로 변경
  // THIS IS NSSTRING
  ```



## NSMutableString

> 자기 자신을 바꿀 수 있는 문자열 클래스 NSString을 상속받는다.



### 초기화

- `+ (instancetype)stringWithString:(NSString *)string;`

  > 클래스 메서드를 호출하여 NSString을 받아서  생성

  ``` objective-c
  NSString *str = @"This is NSString";
  NSMutableString *mstr = [NSMutableString stringWithString: str];
  NSLog(@"mstr: %@", mstr);
  // This is NSString
  ```



### 관련 함수

#### 문자열 병합

- `- (void)appendString:(NSString *)aString;`

  > 매개 변수로 받은 NSString을 자기 자신과 병합

  ``` objective-c
  NSString *str = @"This is NSString";
  NSMutableString *mstr = [NSMutableString stringWithString: str];
  
  NSString *appendString = @" and NSMutableString";
  [mstr appendString:appendString];
  NSLog(@"mstr: %@", mstr);
  // This is NSString and NSMutableString
  ```

- `- (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc;`

  > 매개변수로 받은 NSString을 전달받은 NSUInteger의 위치에 삽입

  ``` objective-c
  NSString *str = @"This is NSString";   
  NSMutableString *mstr = [NSMutableString stringWithString: str];
  
  [mstr insertString:@"Mutable " atIndex:8];
  NSLog(@"mstr: %@", mstr);
  // This is Mutable NSString
  ```

  



























