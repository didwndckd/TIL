# Layout and Identity

## Parents and children

SwiftUI 레이아웃의 3단계 프로세스:

1. 부모 뷰가 자식에게 크기를 제안
2. 자식이 자신의 크기를 결정하고, 부모는 이를 존중
3. 부모가 자신의 좌표 공간에 자식을 배치

### 부모 뷰란?

```swift
VStack {
    Text("Hello, world!")
        .frame(width: 300, height: 100)  // Text의 실제 부모는 VStack이 아닌 .frame()
    Image(systemName: "person")
}
```

### Modifier = 새로운 뷰 생성

```swift
// 1개의 뷰
Text("Hello, world!")

// 2개의 뷰 (Text를 감싸는 Frame ModifiedContent)
Text("Hello, world!")
    .frame(width: 300, height: 100)
```

- Modifier 적용 시 원본 뷰를 감싸는 새로운 뷰 생성
- 부모(frame)가 300x100 컨테이너로서 Text를 중앙에 배치

### 뷰 타입 확인

```swift
Text("Hello, world!")
    .frame(width: 300, height: 100)
    .onTapGesture {
        print(type(of: self.body))
        // 출력: ModifiedContent<ModifiedContent<Text, _FrameLayout>, TapGestureModifier>
    }
```

- `ModifiedContent`: View 프로토콜을 준수하는 struct
- 모든 modifier가 새 뷰를 생성하는 것은 아님

### ModifiedContent

Xcode Open Quickly(Shift+Cmd+O)에서 확인 가능한 정의:

```swift
@frozen public struct ModifiedContent<Content, Modifier>

extension ModifiedContent: View where Content: View, Modifier: ViewModifier
```

Public API로 직접 사용 가능:

```swift
// ViewModifier 정의
struct CustomFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle)
    }
}

// 동일한 결과를 생성하는 두 방식
ModifiedContent(content: Text("Hello"), modifier: CustomFont())  // 직접 사용
Text("Hello").modifier(CustomFont())                              // .modifier() 사용
```

- SwiftUI result builder가 컴파일 타임에 modifier를 `ModifiedContent`로 중첩 변환
- 런타임이 아닌 컴파일 타임 처리로 두 방식의 실제 타입 동일

### 원본 Frame 유지

```swift
// Text의 원본 frame(자연스러운 크기) + 300x100 ModifiedContent 생성
Text("Hello, world!")
    .frame(width: 300, height: 100)

// alignment 동작을 위해 Text는 자신의 원본 frame 정보 유지
Text("Hello, world!")
    .frame(width: 300, height: 100, alignment: .bottomTrailing)
```

- Text의 bounds는 텍스트의 자연스러운 너비/높이를 초과하여 확장 불가
- `.frame()` modifier는 Text 주변에 더 큰 공간을 가진 새로운 `ModifiedContent` 뷰 생성

---

## Fixing view sizes

뷰의 최종 크기 결정에 사용되는 6가지 값:

| 속성 | 설명 |
|------|------|
| Minimum width/height | 뷰가 수용하는 최소 공간. 이보다 작은 값은 무시되어 뷰가 제안된 공간 밖으로 "leak" |
| Maximum width/height | 뷰가 수용하는 최대 공간. 이보다 큰 값은 무시되어 부모가 남은 공간에 뷰를 배치 |
| Ideal width/height | 뷰가 원하는 선호 공간 (UIKit의 intrinsic content size와 유사). min~max 범위 내에서 다른 값 제공 가능 |

### Text의 크기 결정

```swift
// Text의 ideal size: 한 줄에 모든 문자를 표시하는 크기
Text("Hello, world!")
    .frame(width: 300, height: 100)

// 너비가 부족하면 자동 줄바꿈
Text("Hello, world!")
    .frame(width: 30, height: 100)  // 여러 줄로 wrap
```

- Text의 ideal width/height: 한 줄에 모든 문자를 표시하는 크기
- Text의 minimum size: 없음 (제한된 너비에서 자동 줄바꿈)
- "자식이 자신의 크기를 결정" 규칙 위반처럼 보이지만, Text는 minimum size가 없어 좁은 공간 수용 가능

### fixedSize()

뷰의 ideal size를 minimum/maximum size로 승격시키는 modifier:

```swift
// fixedSize()가 ideal size를 고정 크기로 변환
// frame(30, 100)이 제안해도 Text는 원래 크기 유지
Text("Hello, world!")
    .fixedSize()
    .frame(width: 30, height: 100)
```

실행 순서:
1. frame이 30x100 공간을 fixedSize() 자식에게 제안
2. fixedSize()가 Text에게 동일 크기 제안
3. Text가 "ideal size는 95x20, 더 작은 공간도 수용 가능" 응답
4. fixedSize()가 ideal size를 fixed size로 변환하여 반환
5. frame이 자신보다 큰 자식을 배치 (선택의 여지 없음)

```swift
// 파라미터 없이: 양축 고정
.fixedSize()

// 특정 축만 고정
.fixedSize(horizontal: true, vertical: false)   // 가로만 고정 (한 줄 유지)
.fixedSize(horizontal: false, vertical: true)   // 세로만 고정 (가로 압축 허용, 높이는 필요한 만큼)
```

### Image의 크기

```swift
// Image의 ideal size = 이미지 데이터의 원본 크기
// frame을 적용해도 이미지는 원본 크기로 overflow
Image("singapore")
    .frame(width: 300, height: 100)

// clipped()로 overflow 확인
Image("singapore")
    .frame(width: 300, height: 100)
    .clipped()  // 300x100 영역만 표시

// resizable()은 새로운 뷰를 생성하지 않음
// ideal size는 그대로 유지
Image("singapore")
    .resizable()
    .fixedSize()  // 다시 원본 크기로
    .frame(width: 300, height: 100)
```

- `resizable()`: 새 뷰 생성 없이 유연한 width/height 설정
- 기본 ideal size는 유지됨
- frame에 명시적으로 지정하지 않은 값은 이미지의 값을 상속

### 큰 이미지로 인한 레이아웃 문제

```swift
// 문제: 2000x1000 이미지가 VStack 너비를 화면 밖으로 확장
// Text도 화면 밖으로 밀려남
VStack(alignment: .leading) {
    Image("wide-image")
    Text("Hello, World! This is a layout test.")
}

// 해결: 완전히 유연한 frame으로 감싸기 -> Text는 그대로 아래에 밀려있는데??
VStack(alignment: .leading) {
    Image("wide-image")
        .frame(minWidth: 0, maxWidth: .infinity)  // minWidth: 0 필수
    Text("Hello, World! This is a layout test.")
}
```

- `minWidth` 생략 시: 이미지의 minimum width(원본 크기) 상속
- `minWidth: 0, maxWidth: .infinity` 지정해도 ideal size는 유지됨
- `fixedSize()` 적용 시 다시 원본 크기로 복원

### 두 뷰의 높이 동일하게 맞추기

```swift
// 문제: 서로 다른 컨텐츠 크기로 인해 높이가 다름
HStack {
    Text("Forecast")
        .padding()
        .background(.yellow)
    Text("The rain in Spain falls mainly on the Spaniards")
        .padding()
        .background(.cyan)
}

// 해결: maxHeight: .infinity + HStack에 fixedSize(vertical: true)
HStack {
    Text("Forecast")
        .padding()
        .frame(maxHeight: .infinity)  // 무한대 높이 허용
        .background(.yellow)
    Text("The rain in Spain falls mainly on the Spaniards")
        .padding()
        .frame(maxHeight: .infinity)  // 무한대 높이 허용
        .background(.cyan)
}
.fixedSize(horizontal: false, vertical: true)  // HStack의 ideal height로 고정
```

동작 원리:
1. 각 Text의 ideal height → background가 상속 → HStack의 ideal height = 자식들 중 최대값
2. `maxHeight: .infinity`로 Text들이 무한대까지 확장 가능
3. HStack에 `fixedSize(vertical: true)` 적용 → HStack의 ideal height(= 가장 긴 텍스트 높이)로 고정
4. 모든 자식이 동일한 높이로 확장

- 개별 Text에 `fixedSize()` 적용과 다름: 컨테이너의 ideal size를 상한으로 자식들이 확장
- Apple 문서: fixedSize()는 "부모가 제안한 뷰 크기에 대한 counter proposal 생성"

---

## Layout neutrality(레이아웃 중립성)

뷰가 6가지 크기 차원 중 일부에 대해 특별한 선호 없이 다른 뷰에 맞춰 적응하는 특성

```swift
// Color는 완전히 layout neutral
// 사용 가능한 모든 공간을 채움
struct ContentView: View {
    var body: some View {
        Color.red  // 전체 화면을 빨간색으로 채움
    }
}

// background로 사용 시: 자식(Text)의 크기에 맞춤
Text("Hello, World!")
    .background(.red)  // Text 크기만큼만 빨간색
```

- Color가 background로 사용될 때: 자식의 ideal/maximum size를 상속
- minimum size는 상속하지 않음 (Text 자체가 minimum에 대해 layout neutral)
- 결과: Text를 꼭 맞게 감싸되, 필요시 더 작게 압축 가능

| 뷰 | Layout Neutral 차원 |
|---|---|
| Text | minimum width, minimum height |
| Color | 모든 6가지 차원 (사용 맥락에 따라 적응) |
| background(.red) | minimum width, minimum height (자식으로부터 ideal/max 상속) |

### idealWidth/idealHeight와 Layout Neutral 조합

```swift
struct ContentView: View {
    var body: some View {
        Text("Hello, World!")
            .frame(idealWidth: 300, idealHeight: 200)
            .background(.red)
    }
}
```

**레이아웃 순서** (바깥에서 안쪽으로):

1. `background(.red)`: 전체 화면 공간을 가짐. Color.red는 완전히 layout neutral → 사용 가능한 모든 공간 채움 가능
2. `background` → `frame()`에 전체 화면 크기 제안. frame은 min/max width/height에 대해 layout neutral
3. `frame()` → `Text`에 전체 화면 크기 제안. Text는 min width/height에 대해 layout neutral, ideal/max에는 관심 있음
4. `Text`가 frame에 응답: 자신이 관심 있는 4가지 값 반환. **하지만** frame이 자체 ideal width/height(300x200)를 지정했으므로 Text의 ideal은 무시됨. frame의 max width/height는 layout neutral이라 Text의 max를 상속
5. `frame` → `background`에 최종 크기 반환: ideal size 300x200 + max size는 Text의 값(예: 95x20)
6. 결과: **95x20 영역만 빨간색으로 채워짐** (max size가 제한)

### 핵심 포인트

- 6가지 크기 값(min/ideal/max × width/height)이 **조합**되어 동작
- `idealWidth/idealHeight`만 지정 시: frame의 ideal은 설정되지만 **max는 자식으로부터 상속**
- 최종 크기는 min ≤ actual ≤ max 범위 내에서 결정
- 각 modifier가 어떤 값에 대해 layout neutral인지 파악하는 것이 중요

### nil을 사용한 동적 Layout Neutrality

6가지 크기 값은 모두 **optional**이며, `nil`을 전달하면 해당 차원에 대해 layout neutral이 된다:

```swift
struct ContentView: View {
    @State private var usesFixedSize = false

    var body: some View {
        VStack {
            Text("Hello, World!")
                .frame(width: usesFixedSize ? 300 : nil)  // nil = layout neutral
                .background(.red)

            Toggle("Fixed sizes", isOn: $usesFixedSize.animation())
        }
    }
}
```

**런타임 동작:**
- `usesFixedSize == true`: frame이 Text에 300pt 너비 제안
- `usesFixedSize == false`: frame이 VStack에서 받은 크기를 그대로 전달 (사실상 아무 역할 없음)

### 모든 차원이 Layout Neutral인 경우

`nil`로 모든 차원을 layout neutral로 만들 수 있지만, 모든 뷰는 최소한 **nominal ideal size**를 가진다. 이는 레이아웃이 무한히 확장되는 것을 방지한다.

### ScrollView 내부의 Layout Neutral 뷰

```swift
// Color.red는 무한히 확장될 수 없음 → nominal 10pt 높이로 제한
ScrollView {
    Color.red  // 10pt 높이의 얇은 빨간 줄만 표시됨
}
```

ScrollView는 자식에게 **무한한 공간**을 제안할 수 있다. 하지만 Color.red가 무한히 확장되면 의미 없는 레이아웃이 되므로, **nominal ideal size(10pt)** 가 적용된다.

```swift
// ❌ maxHeight만 지정: ideal height가 여전히 10pt
ScrollView {
    Color.red
        .frame(maxHeight: 400)  // 여전히 10pt 높이
}

// ❌ background로 확인: frame도 10pt
ScrollView {
    Color.red
        .frame(maxHeight: 400)
        .background(.blue)  // 파란색 안 보임 - frame도 10pt
}

// ✅ idealHeight 지정: 400pt로 확장
ScrollView {
    Color.red
        .frame(idealHeight: 400, maxHeight: 400)  // 400pt 높이로 확장
}
```

**핵심**:
- Color의 내부 max height는 무한대지만, frame의 400pt로 제한됨
- `idealHeight`를 지정해야 frame이 Color의 10pt ideal을 무시하고 400pt 사용
- `maxHeight`만으로는 ideal height를 변경할 수 없음

---

## Multiple frames

여러 SwiftUI modifier를 쌓아 흥미로운 효과를 만들 수 있다.

### 여러 frame과 background 쌓기

```swift
Text("Hello, World!")
    .frame(width: 200, height: 200)
    .background(.blue)
    .frame(width: 300, height: 300)
    .background(.red)
    .foregroundColor(.white)
// 결과: 빨간 300x300 박스 안에 파란 200x200 박스, 중앙에 텍스트
```

### Fixed Frame vs Flexible Frame

`frame()` modifier를 연속으로 두 번 적용하는 것이 일반적인 이유:

SwiftUI는 **fixed frame**과 **flexible frame**을 분리한다:
- 하나의 뷰는 고정된 width/height를 가지거나
- 유연한 차원(min/ideal/max)을 가질 수 있지만
- **둘 다 동시에 가질 수는 없다**

```swift
// ❌ 하나의 frame에서 fixed와 flexible 동시 사용 불가
.frame(width: 200, minWidth: 100, maxWidth: 300)  // 의미 없음

// ✅ 두 개의 frame으로 분리
.frame(minWidth: 100, maxWidth: 300)  // flexible frame
.frame(width: 200)                      // fixed frame
```