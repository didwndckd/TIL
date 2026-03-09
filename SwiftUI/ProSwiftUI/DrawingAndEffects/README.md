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

## Falling Snow

### 핵심 개념

- **Frame-independent movement**: `delta = 현재 시간 - 마지막 업데이트 시간`을 계산하여 이동량에 곱함. 60fps든 120fps(ProMotion)든 동일한 속도로 이동
- **`Particle`이 class인 이유**: 생성 후에도 `x`, `y`를 매 프레임 갱신해야 하므로 참조 타입 필요. 이전 예제의 `Particle`은 struct(생성 후 불변)
- **`drawLayer`**: 모든 파티클을 별도 레이어에 먼저 합성한 뒤 메인 컨텍스트에 한 번에 그림. 겹치는 영역이 하나의 연속된 도형으로 취급됨
- **`alphaThreshold(min:color:)`**: 지정 알파 범위(0.5~1.0) 안의 픽셀만 단색으로 치환, 나머지는 투명 처리. blur와 조합하면 **메타볼(metaball)** 효과 — 가까운 파티클이 유기적으로 합쳐짐

### Drawing with Canvas와의 차이

| | Drawing with Canvas | Falling Snow |
|---|---|---|
| `Particle` 타입 | struct (불변) | class (매 프레임 위치 갱신) |
| 이동 방식 | 없음 (생성 위치 고정) | frame-independent movement (`delta × speed`) |
| 생성 위치 | 드래그 위치 | 화면 상단 랜덤 X좌표 |
| 수명 | 1초 | 2초 |
| blendMode | `.plusLighter` | 미사용 |
| drawLayer | 미사용 | 사용 (메타볼 효과의 전제 조건) |

### 버전별 진화

**V1 — 기본 눈 효과**: blur만 적용하여 부드러운 눈송이

```swift
struct FallingSnowView1: View {
    @State private var particleSystem = ParticleSystem()

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { ctx, size in
                let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                particleSystem.update(date: timelineDate, size: size)
                ctx.addFilter(.blur(radius: 10))

                ctx.drawLayer { ctx in
                    for particle in particleSystem.particles {
                        ctx.opacity = particle.deathDate - timelineDate
                        let frame = CGRect(x: particle.x, y: particle.y, width: 32, height: 32)
                        ctx.fill(Circle().path(in: frame), with: .color(.white))
                    }
                }
            }
        }
        .ignoresSafeArea()
        .background(.black)
    }
}
```

**V2 — 메타볼 + 그라디언트 마스크**: `alphaThreshold` 추가로 메타볼 효과, `LinearGradient.mask`로 높이에 따른 색상 변화 (라바램프 느낌)

```swift
struct FallingSnowView2: View {
    @State private var particleSystem = ParticleSystem()

    var body: some View {
        LinearGradient(colors: [.red, .indigo], startPoint: .top, endPoint: .bottom).mask {
            TimelineView(.animation) { timeline in
                Canvas { ctx, size in
                    let timelineDate = timeline.date.timeIntervalSinceReferenceDate
                    particleSystem.update(date: timelineDate, size: size)
                    ctx.addFilter(.alphaThreshold(min: 0.5, color: .white))
                    ctx.addFilter(.blur(radius: 10))

                    ctx.drawLayer { ctx in
                        for particle in particleSystem.particles {
                            ctx.opacity = particle.deathDate - timelineDate
                            let frame = CGRect(x: particle.x, y: particle.y, width: 32, height: 32)
                            ctx.fill(Circle().path(in: frame), with: .color(.white))
                        }
                    }
                }
            }
        }
        .ignoresSafeArea()
        .background(.black)
    }
}
```

### 공통 데이터 모델

```swift
class Particle {
    var x: Double
    var y: Double
    let xSpeed: Double
    let ySpeed: Double
    let deathDate = Date.now.timeIntervalSinceReferenceDate + 2

    init(x: Double, y: Double, xSpeed: Double, ySpeed: Double) {
        self.x = x; self.y = y; self.xSpeed = xSpeed; self.ySpeed = ySpeed
    }
}

class ParticleSystem {
    var particles = [Particle]()
    var lastUpdate = Date.now.timeIntervalSinceReferenceDate

    func update(date: TimeInterval, size: CGSize) {
        let delta = date - lastUpdate
        lastUpdate = date

        for (index, particle) in particles.enumerated() {
            if particle.deathDate < date {
                particles.remove(at: index)
            } else {
                particle.x += particle.xSpeed * delta
                particle.y += particle.ySpeed * delta
            }
        }

        particles.append(Particle(
            x: .random(in: -32...size.width), y: -32,
            xSpeed: .random(in: -50...50), ySpeed: .random(in: 100...500)
        ))
    }
}
```

### 주요 포인트

- `alphaThreshold`와 `blur`의 **순서가 중요**: `alphaThreshold` → `blur` 순으로 적용해야 메타볼 효과 발생. 필터는 선언 역순으로 적용됨 (blur 먼저 → alphaThreshold)
- `drawLayer`가 없으면 각 원이 개별적으로 알파 테스트를 받아 메타볼 합성이 일어나지 않음
- `LinearGradient.mask`: TimelineView 전체를 마스크로 사용 — 흰색(불투명) 영역만 그라디언트가 보임
- `xSpeed: -50...50` 범위의 작은 수평 이동이 자연스러운 낙하감을 줌
- `ySpeed: 100...500` 범위의 큰 편차가 깊이감(depth) 생성