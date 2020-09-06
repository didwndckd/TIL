# Flow Control(흐름 제어)

- [조건문](https://github.com/JoongChangYang/TIL/blob/master/Objective-C/FlowControl.md#%EC%A1%B0%EA%B1%B4%EB%AC%B8)
- [반복문](https://github.com/JoongChangYang/TIL/blob/master/Objective-C/FlowControl.md#%EB%B0%98%EB%B3%B5%EB%AC%B8)

## 조건문

### if 구문

- **Basic**

  ```objective-c
  if (Boolean) {
    // code...
  } else if (Boolean) {
    // code...
  } else {
    // code...
  }
  ```

### switch 구문

- **Basic**

  swift와는 다르게 break;를 하지않으면 다음 case 까지 실행한다

  ```objective-c
  switch (기본 자료형) {
    case 값1:
      // code...
      break;
    case 값2:
      // code...
      break;
    default:
      // code...
      break;
  }
  ```



## 반복문

### for 구문

- **Basic**

  ``` objective-c
  for (int i = 0; i < 10; i++;) {
    NSLog(@"In for loop %i", i);
  }
  ```

- **for in 구문**

  > collection 타입을 순회하는 반복문

  ``` objective-c
  for (Type *element in collection) {
    // code...
  }
  
  // Array
  NSArray *summer = [[NSArray alloc]initWithObjects:@"6월", @"7월", @"8월", nil];
  
  for (NSString *month in summer) {
    NSLog(@"month: %@", month);
  }
  /*
  6월
  7월
  8월
  */
  
  // Dictionary
  NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:@"양중창", @"이름", @"모름", @"나이", nil];
  
  for (NSString *key in dic) {
    NSLog(@"%@: %@", key, [dic objectForKey:key]);
  }
  /*
  나이: 모름
  이름: 양중창
  */
  ```

  

### while 구문

- **Basic**

  ``` objective-c
  int i = 10;
  while (i< 10) {
    NSLog(@"In for loop %i", i);
    i++;
  }
  ```

  

