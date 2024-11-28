# Mach-O

> Mach Object file format

## Static Library

- 파일 형식:  `.a`
- **excutable file**에 포함된다.

## Dynamic Library

- 파일 형식: ``.dylib``
- Dynamic library에 대한 참조만 **excutable file**에 포함된다.

## 모듈 구성 예시

타겟별 이미지

![1_Tuist_Graph_Targets](Assets/1_Tuist_Graph_Targets.avif)

### Case 1.

![2_Case1](Assets/2_Case1.png)

  빌드된 앱 **excutable file**의 심볼 정보를 출력

``` sh
$ nm Mach_O_Sample_App.app/Mach_O_Sample_App| grep "\.o"
```

| 이미지                                           | 설명                                                         |
| ------------------------------------------------ | :----------------------------------------------------------- |
| ![3_Case1_nm](Assets/3_Case1_nm.png)             | 빌드된 앱 **excutable file**에 **object file** 심볼이 포함되어있다. |
| ![4_Case1_capacity](Assets/4_Case1_capacity.png) | 최종 앱 **excutable file**의 용량은 250KB 정도               |



