# Environment and Preferences

## Environment

SwiftUI의 Environment는 뷰 계층 구조를 따라 **위에서 아래로 데이터를 전파**하는 시스템이다. `.font()`, `.foregroundColor()` 같은 modifier들이 자식 뷰 전체에 영향을 줄 수 있는 이유가 바로 Environment 덕분이다. 뷰는 자신이 관심 있는 Environment 값만 `@Environment`로 읽으면 되고, 커스텀 키를 정의하여 직접 만든 데이터도 동일한 방식으로 전파할 수 있다.

뷰에 modifier를 적용하면 대부분 원래 뷰를 감싸는 새로운 뷰가 생성된다. 하지만 항상 그런 것은 아니다.

---

### modifier를 흡수하는 Text

`Text`는 래핑 없이 modifier를 자체적으로 흡수하는 대표적인 예다:

```swift
Text("Tap")
    .font(.title)
    .foregroundColor(.red)
    .fontWeight(.black)
    .onTapGesture {
        print(type(of: self.body))
    }
```

시뮬레이터에서 탭하면 타입이 여전히 `Text`다. modifier들이 뷰에 직접 흡수되기 때문이다. 이 덕분에 다양한 폰트와 색상을 가진 텍스트를 만든 뒤 연산자 오버로딩으로 하나의 `Text` 뷰로 합칠 수 있다.

SwiftUI 인터페이스 파일에서 `"internal var modifiers"`를 검색하면, 모든 `Text` 뷰가 modifier용 enum 케이스 배열을 저장하고 있는 것을 확인할 수 있다.

> **Tip**: `Text` 뷰가 폰트 변경 시 다른 자연 크기를 가지는 이유가 바로 이것이다. 폰트가 뷰에 직접 흡수되어 크기 계산에 사용된다.

---

### font()의 이중 동작과 Environment 전파

반면 `font()`를 `VStack` 등 일반 `View`에 적용하면 결과 타입에 `_EnvironmentKeyWritingModifier`가 포함된다:

```swift
VStack {
    Text("Tap")
}
.font(.title)
.onTapGesture {
    print(type(of: self.body))
}
```

이는 `font()`가 호출 위치에 따라 다르게 동작하기 때문이다:

| 호출 위치 | 결과 | 이유 |
|----------|------|------|
| `Text`에 직접 | 내부 enum 배열에 흡수 | 더 제약된 타입이 우선 (overload resolution) |
| 다른 `View`에 | `environment(\.font, .title)`로 변환 | 프로토콜 수준의 메서드 |

Swift의 오버로드 해석은 "가장 제약된 것이 우선한다(the most constrained wins)" 원칙을 따른다. SwiftUI 인터페이스 파일에서 `func font`은 `Text`와 `View`에 각각 한 번씩 존재한다.

`View`에 붙은 `font()` 메서드는 `@inlinable`로 표시되어 있어 실제 구현을 볼 수 있다:

```swift
@inlinable public func font(_ font: SwiftUI.Font?) -> some SwiftUI.View {
    return environment(\.font, font)
}
```

즉, `View.font(.title)`은 `.environment(\.font, .title)`의 래퍼다. **Environment 값은 하위 뷰 계층 전체로 전파**되므로, `VStack` 내부의 모든 자식 뷰가 해당 폰트를 자동으로 적용받는다.

> **Tip**: SwiftUI 인터페이스에서 `return environment(\`를 검색하면 이 동작의 다른 사례들을 볼 수 있다.

> **참고: `@inlinable`** — 컴파일러가 함수 호출을 함수 본문 코드로 직접 대체할 수 있게 허용하는 속성이다. 일반적으로 프레임워크의 함수는 컴파일된 바이너리로만 제공되어 내부 구현을 볼 수 없지만, `@inlinable`로 표시된 함수는 소스 코드가 모듈 외부에 공개된다. 덕분에 SwiftUI 인터페이스 파일에서 `View.font()`의 실제 구현(`environment(\.font, font)`)을 확인할 수 있다.

---

### 커스텀 Environment Key 만들기

예시로, 필수 입력 필드 옆에 빨간 별표를 표시하는 `TextField` 래퍼를 만든다.

**1단계: EnvironmentKey 정의**

```swift
struct FormElementIsRequiredKey: EnvironmentKey {
    static var defaultValue = false
}
```

**2단계: EnvironmentValues 확장**

```swift
extension EnvironmentValues {
    var required: Bool {
        get { self[FormElementIsRequiredKey.self] }
        set { self[FormElementIsRequiredKey.self] = newValue }
    }
}
```

**3단계: View Extension으로 감싸기**

`View.font()`가 `environment(\.font)`의 래퍼인 것처럼, 커스텀 키도 동일한 패턴으로 사용성을 높인다:

```swift
extension View {
    func required(_ makeRequired: Bool = true) -> some View {
        environment(\.required, makeRequired)
    }
}
```

> **Tip**: Boolean 파라미터의 기본값을 `true`로 설정하면 호출부에서 `required()`만으로 자연스럽게 사용할 수 있다.

**4단계: Environment 값을 읽는 뷰 생성**

```swift
struct RequirableTextField: View {
    @Environment(\.required) var required

    let title: String
    @Binding var text: String

    var body: some View {
        HStack {
            TextField(title, text: $text)

            if required {
                Image(systemName: "asterisk")
                    .imageScale(.small)
                    .foregroundColor(.red)
            }
        }
    }
}
```

**5단계: 사용 — 일괄 적용**

개별 뷰가 아닌 컨테이너에 적용하면, 내부의 모든 자식 뷰에 자동으로 전파된다:

```swift
struct ContentView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var makeRequired = false

    var body: some View {
        Form {
            RequirableTextField(title: "First name", text: $firstName)
            RequirableTextField(title: "Last name", text: $lastName)
            Toggle("Make required", isOn: $makeRequired.animation())
        }
        .required(makeRequired)
    }
}
```

---

### 실습: strokeWidth Environment Key

도형의 선 두께를 Environment로 관리하는 예제.

**1단계: EnvironmentKey + EnvironmentValues + View Extension**

```swift
struct StrokeWidthKey: EnvironmentKey {
    static var defaultValue = 1.0
}

extension EnvironmentValues {
    var strokeWidth: Double {
        get { self[StrokeWidthKey.self] }
        set { self[StrokeWidthKey.self] = newValue }
    }
}

extension View {
    func strokeWidth(_ width: Double) -> some View {
        environment(\.strokeWidth, width)
    }
}
```

**2단계: Environment 값을 읽는 뷰**

```swift
struct CirclesView: View {
    @Environment(\.strokeWidth) var strokeWidth

    var body: some View {
        ForEach(0..<3) { _ in
            Circle()
                .stroke(.red, lineWidth: strokeWidth)
        }
    }
}
```

**3단계: 상위 뷰에서 값 설정**

```swift
struct ContentView: View {
    @State private var sliderValue = 1.0

    var body: some View {
        VStack {
            CirclesView()
            Slider(value: $sliderValue, in: 1...10)
        }
        .strokeWidth(sliderValue)
    }
}
```

> **Tip**: `StrokeWidthKey`와 `CirclesView`는 다음 챕터에서도 사용되므로 코드를 보관해 두는 것이 좋다.

---

### 핵심 정리

| 항목 | 설명 |
|------|------|
| **Environment 전파** | 적용 지점의 모든 하위 뷰로 자동 전파 |
| **선택적 읽기** | 뷰는 관심 있는 값만 `@Environment`로 읽으면 됨 |
| **커스텀 키 생성** | `EnvironmentKey` → `EnvironmentValues` 확장 → (선택) `View` Extension → `@Environment`로 읽기 |
| **일괄 적용** | 컨테이너에 적용하면 모든 자식 뷰에 자동 전파 |

---

### @Environment vs @EnvironmentObject

Environment는 observable object의 변경을 감시하지 않는다. 클래스를 저장하고 업데이트해도 뷰가 갱신되지 않으므로, `@Environment`는 값 타입에, `@EnvironmentObject`는 클래스 인스턴스에 적합하다.

가능하다면 `@Environment` 키를 사용하는 것이 유리한 두 가지 이유가 있다:

#### 1. 안전성: 기본값 보장

| | `@Environment` | `@EnvironmentObject` |
|--|-----------------|----------------------|
| **기본값** | `EnvironmentKey`에서 `defaultValue` 필수 제공 | 없음 |
| **누락 시** | 기본값 사용 | **런타임 크래시** |

#### 2. 성능: 세밀한 업데이트

`ObservableObject`의 문서화된 동작에 따르면, `@Published` 프로퍼티가 변경되면 `objectWillChange.send()`가 객체 단위로 호출되어 해당 객체를 관찰하는 모든 뷰가 갱신 대상이 된다.

**Environment Key 방식** — 뷰가 사용하는 키만 변경될 때 갱신:

```swift
struct CirclesView: View {
    @Environment(\.strokeWidth) var strokeWidth

    var body: some View {
        ForEach(0..<3) { _ in
            Circle()
                .stroke(.red, lineWidth: strokeWidth)
        }
    }
}
```

**EnvironmentObject 방식** — 객체 단위 갱신:

```swift
class ThemeManager: ObservableObject {
    @Published var strokeWidth = 1.0
    @Published var titleFont = TitleFontKey.defaultValue
}

struct CirclesView: View {
    @EnvironmentObject var theme: ThemeManager

    var body: some View {
        ForEach(0..<3) { _ in
            Circle()
                .stroke(.red, lineWidth: theme.strokeWidth)
        }
    }
}
```

> **참고**: `ObservableObject`는 프로퍼티 단위가 아닌 **객체 단위**로 변경을 알린다. `@Environment` 키는 해당 키를 사용하는 뷰만 갱신하므로 불필요한 `body` 재호출을 줄일 수 있다. 단, iOS 18+ 에서는 내부 최적화가 추가되어 실제 `body` 재호출 빈도가 다를 수 있다.

> **참고: iOS 17+의 `@Observable`** — iOS 17에서 도입된 `@Observable` 매크로는 프로퍼티 단위 추적을 지원한다. `@Observable` + `@Environment`를 사용하면 `@EnvironmentObject`의 두 가지 단점(기본값 없음, 객체 단위 갱신)이 모두 해결된다. Apple도 `ObservableObject` → `@Observable` 마이그레이션을 권장하고 있다.

#### 절충안: 공유 객체 + Environment Key

데이터를 하나의 객체에서 읽고 쓰되, 누락 시 크래시를 방지하고 싶다면 공유 객체의 프로퍼티를 Environment Key로 노출하는 방식을 사용할 수 있다.

**구조**: Theme 프로토콜 → 구체 구현 → ObservableObject 싱글턴 → Environment Key로 노출

```swift
// 1. Theme 프로토콜과 기본 구현
protocol Theme {
    var strokeWidth: Double { get set }
    var titleFont: Font { get set }
}

struct DefaultTheme: Theme {
    var strokeWidth = 1.0
    var titleFont = TitleFontKey.defaultValue
}

// 2. 싱글턴 ThemeManager
class ThemeManager: ObservableObject {
    @Published var activeTheme: any Theme = DefaultTheme()
    static var shared = ThemeManager()
    private init() { }
}

// 3. Environment Key로 노출
struct ThemeKey: EnvironmentKey {
    static var defaultValue: any Theme = ThemeManager.shared.activeTheme
}

extension EnvironmentValues {
    var theme: any Theme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}

// 4. ViewModifier로 ThemeManager 변경 감시 → Environment에 주입
struct ThemeModifier: ViewModifier {
    @ObservedObject var themeManager = ThemeManager.shared

    func body(content: Content) -> some View {
        content.environment(\.theme, themeManager.activeTheme)
    }
}

extension View {
    func themed() -> some View {
        modifier(ThemeModifier())
    }
}
```

**사용 — key path로 프로퍼티 단위 의존성 설정**:

`@Environment`는 key path를 사용하므로, 테마 객체 전체가 아닌 특정 프로퍼티만 의존성으로 지정할 수 있다:

```swift
struct CirclesView: View {
    // theme 전체가 아닌 strokeWidth만 의존
    @Environment(\.theme.strokeWidth) var strokeWidth

    var body: some View {
        ForEach(0..<3) { _ in
            Circle()
                .stroke(.red, lineWidth: strokeWidth)
        }
    }
}
```

`titleFont`가 변경되어도 `CirclesView`의 `body`는 재호출되지 않는다.

| 방식 | 안전성 | 성능 | 적합한 상황 |
|------|--------|------|------------|
| **@Environment** | 기본값 보장 | 키별 세밀한 갱신 | 값 타입, 독립적인 설정값 |
| **@EnvironmentObject** | 누락 시 크래시 | 객체 단위 전체 갱신 | 클래스 인스턴스, 복잡한 상태 |
| **공유 객체 + Environment Key** | 기본값 보장 | key path로 프로퍼티 단위 갱신 | 공유 상태 + 안전성 + 성능 |

---

### Overriding the environment

자식 뷰에서 동일한 Environment 키에 새 값을 설정하면 부모의 값을 **완전히 대체(override)**한다. 값을 대체하는 것이 아니라 **변형**하고 싶을 때는 `transformEnvironment()`를 사용한다. 특정 Environment 키의 현재 값을 `inout` 참조로 전달받아, 상위에서 어떤 값이 내려오든 클로저를 통해 변형할 수 있다.

```swift
// 환영 뷰 — 이미지와 텍스트로 구성
struct WelcomeView: View {
    var body: some View {
        VStack {
            Image(systemName: "sun.max")
                // ❌ .font(.largeTitle.weight(.black))
                // → Environment 값을 완전히 덮어써서 부모의 폰트 변경이 무시됨

                // ✅ transformEnvironment로 현재 폰트를 변형
                // → 부모가 어떤 폰트를 설정하든 weight만 black으로 변경
                .transformEnvironment(\.font) { font in
                    font = font?.weight(.black)
                }

            Text("Welcome!")
        }
    }
}

// 부모 뷰 — 폰트를 .headline로 바꿔도 이미지는 headline.weight(.black)이 적용됨
struct ContentView: View {
    var body: some View {
        WelcomeView()
            .font(.largeTitle)
    }
}
```

`transaction()` modifier와 유사한 접근법으로, 어떤 폰트가 적용되든 커스텀 클로저를 통해 자동으로 변형된다.
