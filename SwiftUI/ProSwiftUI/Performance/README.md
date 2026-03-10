# Performance

## Delaying work…

- 가장 빠른 코드는 실행되지 않는 코드 — 작업을 건너뛰거나 지연시키기
- **Debounce** = 입력이 일정 시간 멈춘 후에야 작업 수행. 0.1초만으로도 큰 성능 향상
- **Combine 방식**: `$input.debounce(for:scheduler:).sink` → `@Published output`으로 전파. 바인딩에 적합
- **Task 방식**: `Task.sleep` 후 작업 실행, 재호출 시 기존 Task `cancel()` → 새로 스케줄

### 예시 1: Combine 기반 Debouncer

```swift
import SwiftUI
internal import Combine

class Debouncer<T>: ObservableObject {
    @Published var input: T
    @Published var output: T

    private var debounce: AnyCancellable?

    init(initialValue: T, delay: Double = 1) {
        self.input = initialValue
        self.output = initialValue

        debounce = $input
            .debounce(for: .seconds(delay), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.output = $0
            }
    }
}

struct DelayingWork1: View {
    @StateObject private var text = Debouncer(initialValue: "", delay: 0.5)
    @StateObject private var slider = Debouncer(initialValue: 0.0, delay: 0.1)

    var body: some View {
        VStack {
            TextField("Search for something", text: $text.input)
                .textFieldStyle(.roundedBorder)
            Text(text.output)

            Spacer().frame(height: 50)

            Slider(value: $slider.input, in: 0...100)
            Text(slider.output.formatted())
        }
    }
}
```

### 예시 2: Task 기반 debounce

```swift
import SwiftUI

extension DelayingWork2 {
    class ViewModel: ObservableObject {
        private var refreshTask: Task<Void, Error>?
        var workCounter = 0

        func doWorkNow() {
            workCounter += 1
            print("Work done: \(workCounter)")
        }

        func scheduleWork() {
            refreshTask?.cancel()

            refreshTask = Task {
                try await Task.sleep(until: .now + .seconds(3), clock: .continuous)
                doWorkNow()
            }
        }
    }
}

struct DelayingWork2: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        VStack {
            Button("Do Work Soon", action: viewModel.scheduleWork)
            Button("Do Work Now", action: viewModel.doWorkNow)
        }
    }
}
```

## ...or skipping it entirely

- 작업을 지연시키는 것보다 더 좋은 건 **아예 건너뛰는 것**
- 클래스를 `@StateObject`로 감시할 필요 없으면 **`@State`로 저장** → 변경 추적 없이 캐시처럼 활용 (예: `CIContext` 같은 무거운 객체)
- `let`으로 저장하면 뷰 재생성마다 인스턴스가 파괴·재할당되므로 주의
- **`onAppear()`는 뷰가 표시될 때마다 호출됨** → TabView 탭 전환 시 반복 실행
- 초기화를 한 번만 수행하고 싶다면 **`onFirstAppear()` 커스텀 modifier** 사용

### 예시 1: @State를 캐시로 활용 (CIContext)

```swift
import CoreImage
import CoreImage.CIFilterBuiltins
import SwiftUI

struct SkippingWork1: View {
    @State private var context = CIContext()
    @State private var name = "Paul"

    var body: some View {
        VStack {
            TextField("Enter your name", text: $name)
                .textFieldStyle(.roundedBorder)
                .padding()

            Image(uiImage: generateQRCode(from: "\(name)"))
                .resizable()
                .interpolation(.none)
                .frame(width: 200, height: 200)
        }
    }

    func generateQRCode(from string: String) -> UIImage {
        let filter = CIFilter.qrCodeGenerator()
        filter.message = Data(string.utf8)

        if let output = filter.outputImage {
            if let cgImage = context.createCGImage(output, from: output.extent) {
                return UIImage(cgImage: cgImage)
            }
        }

        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
}
```

### 예시 2: onAppear()의 반복 호출 문제

```swift
struct SkippingWork2: View {
    var body: some View {
        TabView {
            ForEach(1..<6) { i in
                ExampleView(number: i)
                    .tabItem { Label(String(i), systemImage: "\(i).circle") }
            }
        }
    }
}

struct ExampleView: View {
    let number: Int

    var body: some View {
        Text("View \(number)")
            .onAppear {
                print("View \(number) appearing")
            }
    }
}
```

### 예시 3: onFirstAppear() modifier

```swift
struct OnFirstAppearModifier: ViewModifier {
    @State private var hasLoaded = false
    var perform: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            guard hasLoaded == false else { return }
            hasLoaded = true
            perform()
        }
    }
}

extension View {
    func onFirstAppear(perform: @escaping () -> Void) -> some View {
        modifier(OnFirstAppearModifier(perform: perform))
    }
}

// 사용
Text("View \(number)")
    .onFirstAppear {
        print("View \(number) appearing")
    }
```

### 플랫폼별 modifier로 불필요한 코드 제거

```swift
public extension View {
    func watchOS<Content: View>(_ modifier: @escaping (Self) -> Content) -> some View {
        #if os(watchOS)
        modifier(self)
        #else
        self
        #endif
    }
}

// 사용 — watchOS 외 플랫폼에서는 컴파일러가 최적화로 제거
Text("Hello, world!")
    .watchOS { $0.padding(0) }
```