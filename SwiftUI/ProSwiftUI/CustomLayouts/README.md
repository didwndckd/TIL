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

