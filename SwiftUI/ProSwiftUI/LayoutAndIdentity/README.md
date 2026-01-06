# Layout and Identity

## Parents and children

SwiftUI의 핵심은 3단계 레이아웃 프로세스다.

1. 부모 뷰가 자식에게 크기를 제안한다
2. 자식이 자신의 크기를 결정하고, 부모는 이를 존중해야 한다
3. 부모가 자신의 좌표 공간에 자식을 배치한다

### 부모 뷰란?

```swift
VStack {
    Text("Hello, world!")
        .frame(width: 300, height: 100)
    Image(systemName: "person")
}
```

Text의 부모가 VStack이라고 생각하기 쉽지만, 실제로는 `.frame()` modifier가 부모다.

### Modifier는 새로운 뷰를 생성한다

```swift
Text("Hello, world!")  // 1개의 뷰
```

```swift
Text("Hello, world!")
    .frame(width: 300, height: 100)  // 2개의 뷰 (Text + Frame)
```

Text는 스스로 위치를 정할 수 없고, 부모(frame)가 300x100 컨테이너가 되어 Text를 중앙에 배치한다. Modifier를 여러 개 쌓으면 원본 뷰를 감싸는 새 뷰들이 계속 생성된다.

### 뷰 타입 확인하기

```swift
Text("Hello, world!")
    .frame(width: 300, height: 100)
    .onTapGesture {
        print(type(of: self.body))
    }

// ModifiedContent<ModifiedContent<Text, _FrameLayout>, TapGestureModifier>
```

출력하면 `ModifiedContent` 타입이 자주 나타난다. `ModifiedContent`는 View 프로토콜을 준수하는 struct다. 단, 모든 modifier가 새 뷰를 생성하는 것은 아니다.

### ModifiedContent

Xcode의 Open Quickly(Shift+Cmd+O)로 `ModifiedContent`를 검색하면 SwiftUI의 생성된 인터페이스 파일에서 확인할 수 있다.

```swift
@frozen public struct ModifiedContent<Content, Modifier>

extension ModifiedContent: View where Content: View, Modifier: ViewModifier
```

`ModifiedContent`는 public API이므로 직접 사용할 수 있다.

```swift
struct CustomFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle)
    }
}

// ModifiedContent로 직접 적용
ModifiedContent(content: Text("Hello"), modifier: CustomFont())
```

아래 두 코드는 동일한 결과를 만든다.

```swift
// 방법 1: ModifiedContent 직접 사용
ModifiedContent(content: Text("Hello"), modifier: CustomFont())

// 방법 2: .modifier() 사용
Text("Hello").modifier(CustomFont())
```

SwiftUI의 result builder가 컴파일 타임에 modifier들을 `ModifiedContent`로 중첩 변환한다. 런타임이 아닌 컴파일 타임에 처리되므로, 두 방식의 실제 타입이 동일하다.

### 원본 frame은 유지된다

```swift
Text("Hello, world!")
    .frame(width: 300, height: 100)
```

이 코드는 원본 Text 뷰 + 300x100 frame을 가진 `ModifiedContent`를 생성한다. Text의 원본 frame(텍스트의 자연스러운 크기)은 그대로 유지된다.

```swift
Text("Hello, world!")
    .frame(width: 300, height: 100, alignment: .bottomTrailing)
```

alignment가 작동하려면 Text가 자신의 원본 frame을 알아야 한다. Text의 bounds는 절대로 텍스트의 자연스러운 너비/높이를 넘어서 확장되지 않는다. `.frame()` modifier는 Text 주변에 더 큰 공간을 가진 새로운 `ModifiedContent` 뷰를 생성할 뿐이다.

---

Fixing view sizes
Layout neutrality
Multiple frames