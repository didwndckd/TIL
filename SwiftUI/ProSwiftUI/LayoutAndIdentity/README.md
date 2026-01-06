# Layout and Identity

## Parents and children

SwiftUI 레이아웃의 3단계 프로세스:

1. 부모 뷰가 자식에게 크기를 제안
2. 자식이 자신의 크기를 결정하고, 부모는 이를 존중
3. 부모가 자신의 좌표 공간에 자식을 배치

### 부모 뷰의 정의

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

Fixing view sizes
Layout neutrality
Multiple frames