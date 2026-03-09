# Drawing and Effects

## Drawing with Canvas

### 핵심 개념

- **`Canvas`**: SwiftUI에서 자유롭게 2D 드로잉을 수행하는 뷰. `GraphicsContext`와 `CGSize`를 제공받아 직접 그리기
- **`TimelineView(.animation)`**: 매 프레임마다 뷰를 다시 그리도록 스케줄링. 애니메이션에 최적화된 주기로 호출
- **`ParticleSystem`**: 클래스로 구현하여 SwiftUI 업데이트 없이 자유롭게 상태 변경. `@State`로 유지 (`ObservableObject` 불필요)
- **`GraphicsContext` 효과**:
  - `blendMode = .plusLighter`: 겹치는 색상이 밝아지는 가산 블렌딩
  - `addFilter(.blur(radius:))`: 가우시안 블러로 부드러운 글로우 효과
  - `opacity`: 파티클의 남은 수명에 비례하여 페이드아웃

### 파티클 시스템 구조

| 구성 요소 | 역할 |
|---|---|
| `Particle` | 위치(`CGPoint`)와 소멸 시간(`deathDate`) 저장. 생성 시 1초 후 소멸 설정 |
| `ParticleSystem` | 파티클 배열 관리. `update()`에서 만료 파티클 제거 + 새 파티클 생성 |
| `DragGesture(minimumDistance: 0)` | 터치 즉시 반응하여 파티클 생성 위치 갱신 |

### 전체 코드

```swift
struct Particle {
    let position: CGPoint
    let deathDate = Date.now.timeIntervalSinceReferenceDate + 1
}

class ParticleSystem {
    var particles = [Particle]()
    var position = CGPoint.zero

    func update(date: TimeInterval) {
        particles = particles.filter { $0.deathDate > date }
        particles.append(Particle(position: position))
    }
}

struct DrawingWithCanvasView: View {
    @State private var particleSystem = ParticleSystem()

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                particleSystem.update(date: timelineDate)
                ctx.blendMode = .plusLighter
                ctx.addFilter(.blur(radius: 10))

                for particle in particleSystem.particles {
                    let frame = CGRect(
                        x: particle.position.x - 16,
                        y: particle.position.y - 16,
                        width: 32,
                        height: 32
                    )

                    ctx.opacity = particle.deathDate - timelineDate
                    ctx.fill(
                        Circle().path(in: frame),
                        with: .color(.cyan)
                    )
                }
            }
        }
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { drag in
                    particleSystem.position = drag.location
                }
        )
        .ignoresSafeArea()
        .background(.black)
    }
}
```

### 주요 포인트

- `ParticleSystem`이 **class**인 이유: struct면 값 변경마다 SwiftUI가 불필요하게 뷰를 재생성. class는 참조 타입이므로 `Canvas` 내부에서 자유롭게 변경 가능
- `@State`로 생성하는 이유: `ObservableObject`가 아니므로 `@StateObject` 불필요. `@State`만으로 객체 수명 유지 가능
- `deathDate - timelineDate`를 opacity로 사용: 1초 수명 중 남은 시간이 곧 투명도 (1.0→0.0 자연 페이드아웃)
- `DragGesture(minimumDistance: 0)`: 기본값은 10pt 이동 후 시작이지만, 0으로 설정하면 터치 즉시 반응

##