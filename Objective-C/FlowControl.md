# Flow Control(흐름 제어)

### 조건문

- **if 문**

  ```objective-c
  if (Boolean) {
  	// code...
  } else if (Boolean) {
  	// code...
  } else {
  	// code...
  }
  ```

- **swith 문**

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



### 반복문

- **for 구문**

  ``` objective-c
  for (int i=0; i<10; i++) {
  	NSLog(@"In for loop %i", i);
  }
  ```

- **while 구문**

  ``` objective-c
  int i = 10;
  while (i < 10) {
  	NSLog(@"In for loop %i", i);
    i++;
  }
  ```

  