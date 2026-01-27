# Animations and Transitions

## Animating the unanimatable

SwiftUI에서 거의 모든 것을 애니메이션할 수 있지만, 일부 속성은 약간의 추가 작업이 필요하다.

---

### 애니메이션의 두 가지 방식

| 방식 | 설명 | 예시 |
|------|------|------|
| **명시적 애니메이션** | `withAnimation` 블록으로 상태 변경을 감싸서 애니메이션 트리거 | `withAnimation { scale += 1 }` |
| **암묵적 애니메이션** | `.animation()` modifier로 값 변경 시 자동 애니메이션 | `.animation(.default, value: scale)` |

**명시적 애니메이션**:
```swift
struct ContentView: View {
    @State private var scale = 1.0

    var body: some View {
        Text("Hello, World!")
            .scaleEffect(scale)
            .onTapGesture {
                withAnimation {
                    scale += 1
                }
            }
    }
}
```

**암묵적 애니메이션**:
```swift
struct ContentView: View {
    @State private var scale = 1.0

    var body: some View {
        Text("Hello, World!")
            .scaleEffect(scale)
            .onTapGesture {
                scale += 1
            }
            .animation(.default, value: scale)
    }
}
```

> **Tip**: iOS 15부터 `value` 파라미터 없이 `.animation()` 사용은 deprecated. 모든 변경에 애니메이션이 적용되어 의도치 않은 결과 발생 가능.

---

### 애니메이션되지 않는 속성: zIndex

`zIndex`는 기본적으로 애니메이션되지 않는다:

```swift
struct ContentView: View {
    @State private var redAtFront = false
    let colors: [Color] = [.blue, .green, .orange, .purple, .mint]

    var body: some View {
        VStack {
            Button("Toggle zIndex") {
                withAnimation(.linear(duration: 1)) {
                    redAtFront.toggle()
                }
            }

            ZStack {
                RoundedRectangle(cornerRadius: 25)
                    .fill(.red)
                    .zIndex(redAtFront ? 6 : 0)  // ❌ 애니메이션 안 됨

                ForEach(0..<5) { i in
                    RoundedRectangle(cornerRadius: 25)
                        .fill(colors[i])
                        .offset(x: Double(i + 1) * 20, y: Double(i + 1) * 20)
                        .zIndex(Double(i))
                }
            }
            .frame(width: 200, height: 200)
        }
    }
}
```

**문제**: `withAnimation`을 사용해도 빨간 박스가 즉시 앞으로 점프한다.

---

### 해결책: Animatable 프로토콜

`ViewModifier`와 `Animatable` 프로토콜을 결합하여 애니메이션되지 않는 속성을 애니메이션 가능하게 만든다.

#### 1. AnimatableZIndexModifier 생성

```swift
struct AnimatableZIndexModifier: ViewModifier, Animatable {
    var index: Double

    var animatableData: Double {
        get { index }
        set { index = newValue }
    }

    func body(content: Content) -> some View {
        content
            .zIndex(index)
    }
}
```

> **Tip**: modifier 이름이 "animatable"(애니메이션 가능)이지 "animated"(애니메이션된)가 아님. 실제 애니메이션 여부는 사용 방식에 따라 결정됨.

#### 2. View Extension 추가

```swift
extension View {
    func animatableZIndex(_ index: Double) -> some View {
        self.modifier(AnimatableZIndexModifier(index: index))
    }
}
```

#### 3. 사용

```swift
RoundedRectangle(cornerRadius: 25)
    .fill(.red)
    .animatableZIndex(redAtFront ? 6 : 0)  // ✅ 애니메이션 됨
```

---

### Animatable 프로토콜의 동작 원리

| 구성 요소 | 역할 |
|----------|------|
| `animatableData` | 애니메이션 중 보간된 값을 읽고 쓰는 프로퍼티 |
| `get` | 현재 애니메이션 값 반환 |
| `set` | SwiftUI가 보간된 값 전달 (0.1, 1.35, 4.825, ...) |

**동작 흐름**:
```
0 → 6 애니메이션 요청
    ↓
SwiftUI가 타이밍 곡선에 따라 보간값 계산
    ↓
animatableData setter로 값 전달 (0.1, 1.35, 4.825, ...)
    ↓
전달받은 값을 zIndex에 적용
    ↓
부드러운 Z축 애니메이션 완성
```

**디버깅**:
```swift
var animatableData: Double {
    get { index }
    set {
        print(newValue)  // 보간값 확인
        index = newValue
    }
}
// 출력: 0.0, 0.1, 0.35, 1.2, 2.5, 4.1, 5.4, 5.9, 6.0, ...
```

---

### iOS 15.6 이하 호환성

#### Font Size 애니메이션

iOS 16 이전 버전에서는 시스템 폰트 크기 애니메이션이 기본 지원되지 않았다. `Animatable` 프로토콜로 해결 가능:

```swift
struct AnimatableFontModifier: ViewModifier, Animatable {
    var size: Double

    var animatableData: Double {
        get { size }
        set { size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}

extension View {
    func animatableFont(size: Double) -> some View {
        self.modifier(AnimatableFontModifier(size: size))
    }
}
```

**사용 예시**:
```swift
struct ContentView: View {
    @State private var scaleUp = false

    var body: some View {
        Text("Hello, World!")
            .animatableFont(size: scaleUp ? 56 : 24)
            .onTapGesture {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.5)) {
                    scaleUp.toggle()
                }
            }
    }
}
```

> **주의**: 애니메이션 중 매 프레임마다 새로운 크기의 시스템 폰트를 생성한다. 효과는 훌륭하지만 과도하게 사용하면 성능에 영향을 줄 수 있다. Apple의 iOS 16+ 구현이 더 최적화되어 있을 가능성이 높다.

#### foregroundColor 애니메이션

`foregroundColor()`는 iOS 15.6 이하에서 애니메이션되지 않는다:

```swift
// ❌ iOS 15.6 이하에서 작동 안 함
struct ContentView: View {
    @State private var isRed = false

    var body: some View {
        Text("Hello, World!")
            .foregroundColor(isRed ? .red : .blue)
            .font(.largeTitle.bold())
            .onTapGesture {
                withAnimation {
                    isRed.toggle()
                }
            }
    }
}
```

색상 애니메이션을 `Animatable`로 구현하려면 before/after 색상을 저장하고 RGBA 값을 수동으로 보간해야 해서 복잡하다.

**해결책: colorMultiply() 활용**

`colorMultiply()`는 애니메이션이 가능하다. 원본 색상과 다른 색상의 RGBA 값을 각각 곱한다.

**원리**: 흰색(1, 1, 1, 1)에 어떤 색상을 곱하면 그 색상 그대로 반환된다.

```swift
// ✅ iOS 15.6 이하에서도 작동
Text("Hello, World!")
    .foregroundColor(.white)
    .colorMultiply(isRed ? .red : .blue)
```

**Extension으로 정리**:

```swift
extension View {
    func animatableForegroundColor(_ color: Color) -> some View {
        self
            .foregroundColor(.white)
            .colorMultiply(color)
    }
}
```

#### iOS 버전별 지원 현황

| 속성 | iOS 16+ | iOS 15.6 이하 |
|------|---------|--------------|
| Font Size | 기본 지원 | `Animatable` 필요 |
| foregroundColor | 기본 지원 | `colorMultiply()` 우회 |
| zIndex | ❌ | `Animatable` 필요 |

---

### Creating animated views

`Animatable` 프로토콜은 `ViewModifier`에만 제한되지 않는다. 일반 `View`에서도 동일하게 작동한다.

#### 예시 1: CountingText

숫자가 애니메이션되며 변하는 텍스트:

```swift
struct CountingText: View, Animatable {
    var value: Double
    var fractionLength = 8

    var animatableData: Double {
        get { value }
        set { value = newValue }
    }

    var body: some View {
        Text(value.formatted(.number.precision(.fractionLength(fractionLength))))
    }
}

// 사용
struct ContentView: View {
    @State private var value = 0.0

    var body: some View {
        CountingText(value: value)
            .onTapGesture {
                withAnimation(.linear) {
                    value = Double.random(in: 1...1000)
                }
            }
    }
}
```

**핵심**: `Animatable`은 보간된 값을 전달할 뿐, 그 값을 어떻게 사용할지는 개발자가 결정한다.

#### 예시 2: TypewriterText

글자가 하나씩 나타나는 타이프라이터 효과:

```swift
struct TypewriterText: View, Animatable {
    var string: String
    var count = 0

    var animatableData: Double {
        get { Double(count) }
        set { count = Int(max(0, newValue)) }
    }

    var body: some View {
        let stringToShow = String(string.prefix(count))
        Text(stringToShow)
    }
}
```

**레이아웃 개선**: 텍스트 공간을 미리 확보하려면 hidden된 전체 텍스트를 사용:

```swift
var body: some View {
    let stringToShow = String(string.prefix(count))
    ZStack {
        Text(string)
            .hidden()
            .overlay(
                Text(stringToShow),
                alignment: .topLeading
            )
    }
}
```

**사용 예시**:

```swift
struct ContentView: View {
    @State private var value = 0
    let message = "This is a very long piece of text that appears letter by letter."

    var body: some View {
        VStack {
            TypewriterText(string: message, count: value)
                .frame(width: 300, alignment: .leading)

            Button("Type!") {
                withAnimation(.linear(duration: 2)) {
                    value = message.count
                }
            }

            Button("Reset") {
                value = 0
            }
        }
    }
}
```

#### 접근성 고려

VoiceOver 사용자나 애니메이션 줄이기를 설정한 사용자를 위한 대응:

```swift
struct TypewriterText: View, Animatable {
    @Environment(\.accessibilityVoiceOverEnabled) var accessibilityVoiceOverEnabled
    @Environment(\.accessibilityReduceMotion) var accessibilityReduceMotion

    var string: String
    var count = 0

    var animatableData: Double {
        get { Double(count) }
        set { count = Int(max(0, newValue)) }
    }

    var body: some View {
        if accessibilityVoiceOverEnabled || accessibilityReduceMotion {
            Text(string)  // 애니메이션 없이 전체 텍스트 표시
        } else {
            let stringToShow = String(string.prefix(count))
            ZStack {
                Text(string)
                    .hidden()
                    .overlay(
                        Text(stringToShow),
                        alignment: .topLeading
                    )
            }
        }
    }
}
```

| 환경 변수 | 용도 |
|----------|------|
| `accessibilityVoiceOverEnabled` | VoiceOver 활성화 여부 |
| `accessibilityReduceMotion` | 동작 줄이기 설정 여부 |

---

### 핵심 정리

| 항목 | 설명 |
|------|------|
| **Animatable 프로토콜** | 보간된 값을 시간에 따라 읽고 쓸 수 있게 해줌 |
| **animatableData** | 애니메이션 값을 처리하는 핵심 프로퍼티 |
| **적용 범위** | zIndex, font size 등 기본적으로 애니메이션되지 않는 속성에 사용 |
| **작동 원리** | 단순히 보간값을 전달할 뿐, 실제 처리는 개발자가 결정 |

**결론**: `Animatable` 프로토콜을 사용하면 SwiftUI에서 거의 모든 속성을 애니메이션할 수 있다. 마법처럼 보이지만 내부적으로는 매우 단순한 구조다.
