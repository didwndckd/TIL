# Custom Layouts

## Adaptive Layouts

### 핵심 개념

- **`AnyLayout`**: 레이아웃 타입을 type-erase하는 래퍼. `AnyView`와 달리, 동적으로 레이아웃을 전환할 때 **상태(state), 애니메이션, 플랫폼 뷰를 유지**하도록 설계됨
- **`HStackLayout` / `VStackLayout` / `ZStackLayout`**: `HStack` 등과 동일하게 동작하지만 `AnyLayout`과 함께 사용하기 위해 별도로 존재 (컴파일러 성능 이유)
- **`GridLayout`**: 그리드 형태 배치. `GridRow`로 행을 나눔
- **`Layout` 프로토콜**: 위 레이아웃들이 모두 준수하는 프로토콜. 커스텀 레이아웃을 만들어 `AnyLayout`에 사용 가능

### 레이아웃 전환 패턴

**상태를 가진 자식 뷰** — 레이아웃이 바뀌어도 `counter` 값이 유지됨:

```swift
struct ExampleView: View {
    @State private var counter = 0
    let color: Color

    var body: some View {
        Button { counter += 1 } label: {
            RoundedRectangle(cornerRadius: 10)
                .fill(color)
                .overlay(
                    Text(String(counter))
                        .foregroundColor(.white)
                        .font(.largeTitle)
                )
        }
        .frame(width: 100, height: 100)
        .rotationEffect(.degrees(.random(in: -20...20)))
    }
}
```

**레이아웃 배열 + 인덱스로 동적 전환**:

```swift
struct ContentView: View {
    let layouts = [
        AnyLayout(VStackLayout()),
        AnyLayout(HStackLayout()),
        AnyLayout(ZStackLayout()),
        AnyLayout(GridLayout())
    ]
    @State private var currentLayout = 0

    var layout: AnyLayout { layouts[currentLayout] }

    var body: some View {
        VStack {
            Spacer()

            // GridRow는 Grid 외 레이아웃에서 Group처럼 동작
            layout {
                GridRow {
                    ExampleView(color: .red)
                    ExampleView(color: .green)
                }
                GridRow {
                    ExampleView(color: .blue)
                    ExampleView(color: .orange)
                }
            }

            Spacer()

            Button("Change Layout") {
                withAnimation {
                    currentLayout = (currentLayout + 1) % layouts.count
                }
            }
            .buttonStyle(.borderedProminent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.gray)
    }
}
```

### 주요 특징

- 레이아웃 전환 시 **각 뷰의 상태가 유지**됨 (카운터 값 등)
- `withAnimation` 안에서 전환하면 SwiftUI가 자동으로 **레이아웃 변경을 애니메이션**으로 처리
- `GridRow`는 Grid 외의 레이아웃에서는 `Group`처럼 동작 — 에러 없이 무시됨
- **커스텀 `Layout`** 타입도 `AnyLayout`으로 감싸 기본 레이아웃과 자유롭게 전환 가능

---

## Implementing a Radial Layout

### 핵심 개념

- **`Layout` 프로토콜** 구현 시 두 메서드가 필수:
  - `sizeThatFits()`: 컨테이너가 원하는 크기 반환. 부모가 여러 번 호출할 수 있음
  - `placeSubviews()`: 각 자식 뷰를 실제로 배치
- **`ProposedViewSize`**: 단순한 width/height가 아닌 **의도**를 담은 제안
- **`replacingUnspecifiedDimensions()`**: `nil` 값을 기본값(10pt)으로 대체해 완전한 `CGSize` 반환
  - `Color.red`가 ScrollView 안에서 10pt 높이를 갖는 이유가 바로 이 메서드 때문

### ProposedViewSize 종류

| 값 | 의미 |
|---|---|
| `.unspecified` (nil) | "이상적인 크기가 얼마야?" |
| `.infinity` | "최대 얼마나 쓸 수 있어?" |
| `.zero` | "최소 얼마나 필요해?" |
| 구체적 값 (e.g. 300×200) | "이 크기로 배치해, 맞춰봐" |
| 부분 값 (e.g. 300×nil) | "가로만 정해졌어, 세로는 네가 결정해" |

> width/height 각각 독립적으로 nil이 될 수 있으므로, `CGSize`가 아닌 별도 타입으로 존재

### `sizeThatFits` — 제안된 공간 그대로 사용

```swift
func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
    // nil → 10pt로 대체. 원형 레이아웃은 공간을 알아야 배치 가능하므로 제안 크기를 그대로 수용
    proposal.replacingUnspecifiedDimensions()
}
```

### `placeSubviews` — 원형 배치 계산

```swift
func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
    let radius = min(bounds.size.width, bounds.size.height) / 2
    let angle = Angle.degrees(360 / Double(subviews.count)).radians

    for (index, subview) in subviews.enumerated() {
        let viewSize = subview.sizeThatFits(.unspecified)

        // 뷰 크기의 절반만큼 안쪽으로 당겨 원 안에 완전히 들어오게 함
        // .pi / 2 빼기: 0도를 오른쪽(SwiftUI 기본)이 아닌 위쪽으로 보정
        let xPos = cos(angle * Double(index) - .pi / 2) * (radius - viewSize.width / 2)
        let yPos = sin(angle * Double(index) - .pi / 2) * (radius - viewSize.height / 2)

        let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
        subview.place(at: point, anchor: .center, proposal: .unspecified)
    }
}
```

### 전체 코드

```swift
struct RadialLayout: Layout {
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        proposal.replacingUnspecifiedDimensions()
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let radius = min(bounds.size.width, bounds.size.height) / 2
        let angle = Angle.degrees(360 / Double(subviews.count)).radians
        for (index, subview) in subviews.enumerated() {
            let viewSize = subview.sizeThatFits(.unspecified)
            let xPos = cos(angle * Double(index) - .pi / 2) * (radius - viewSize.width / 2)
            let yPos = sin(angle * Double(index) - .pi / 2) * (radius - viewSize.height / 2)
            let point = CGPoint(x: bounds.midX + xPos, y: bounds.midY + yPos)
            subview.place(at: point, anchor: .center, proposal: .unspecified)
        }
    }
}

struct ContentView: View {
    @State private var count = 16

    var body: some View {
        RadialLayout {
            ForEach(0..<count, id: \.self) { _ in
                Circle()
                    .frame(width: 32, height: 32)
            }
        }
        .padding()
        .safeAreaInset(edge: .bottom) {
            Stepper("Count: \(count)", value: $count.animation(), in: 0...100)
                .padding()
        }
    }
}
```

### 주요 포인트

- `subview.sizeThatFits(.unspecified)`: 자식 뷰의 이상적인 크기 조회
- `bounds.midX / midY` 더하기: 원점(top-left)이 아닌 **컨테이너 중앙** 기준으로 배치
- `anchor: .center`: 계산한 point가 뷰의 중심임을 명시
- `$count.animation()`: Stepper 값 변경 시 자동 애니메이션 적용

## Implementing an equal width layout