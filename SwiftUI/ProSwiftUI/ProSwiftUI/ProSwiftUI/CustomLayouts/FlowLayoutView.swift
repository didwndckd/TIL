import SwiftUI

// MARK: - FlowLayout
// 컨텐츠 크기만큼 가로로 채우고, 넘치면 다음 줄로 배치하는 레이아웃
// lineLimit으로 표시할 줄 수를 제한할 수 있음 (0이면 무제한)
private struct FlowLayout: Layout {
    let itemSpacing: CGFloat
    let lineSpacing: CGFloat
    let lineLimit: Int
    
    struct FrameItem {
        let isShow: Bool
        let frame: CGRect
        
        var viewFrame: CGRect {
            if isShow {
                return frame
            } else {
                return CGRect(origin: frame.origin, size: .zero)
            }
        }
    }

    /// 각 뷰의 프레임을 한 번에 계산하는 헬퍼
    /// sizeThatFits()와 placeSubviews() 양쪽에서 재사용
    func frames(for subviews: Subviews, in totalWidth: Double) -> [FrameItem] {
        var viewFrames = [FrameItem]()

        var lineX = 0.0
        var lineY = 0.0
        var lineHeight = 0.0
        var currentLine = 1
        var isOverFlowed: Bool = false

        for subview in subviews {
            let viewSize = subview.sizeThatFits(.unspecified)

            let requiredSpacing = lineX > 0 ? itemSpacing : 0
            let requiredWidth = lineX + requiredSpacing + viewSize.width

            if requiredWidth > totalWidth {
                // 가로 범위 초과 시 다음 줄로
                if lineHeight > 0 {
                    currentLine += 1
                    if lineLimit > 0, currentLine > lineLimit {
                        isOverFlowed = true
                    }
                    lineY += lineHeight + lineSpacing
                }
                lineX = 0
                lineHeight = 0
            } else if lineX > 0 {
                lineX += itemSpacing
            }

            let frame = CGRect(x: lineX, y: lineY, width: viewSize.width, height: viewSize.height)
            viewFrames.append(.init(isShow: !isOverFlowed, frame: frame))

            if !isOverFlowed {
                lineHeight = max(lineHeight, viewSize.height)
                lineX += viewSize.width
            }
        }

        return viewFrames
    }

    func sizeThatFits(
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) -> CGSize {
        let width = proposal.replacingUnspecifiedDimensions().width
        let items = frames(for: subviews, in: width)
        let visibleFrames = items.filter(\.isShow).map(\.viewFrame)
        let maxY = visibleFrames.max { $0.maxY < $1.maxY }?.maxY ?? 0
        let maxX = visibleFrames.max { $0.maxX < $1.maxX }?.maxX ?? 0
        return CGSize(width: maxX, height: maxY)
    }

    func placeSubviews(
        in bounds: CGRect,
        proposal: ProposedViewSize,
        subviews: Subviews,
        cache: inout Void
    ) {
        let items = frames(for: subviews, in: bounds.width)

        for index in items.indices {
            let frame = items[index].viewFrame
            let position = CGPoint(
                x: bounds.minX + frame.midX,
                y: bounds.minY + frame.midY
            )
            subviews[index].place(
                at: position,
                anchor: .center,
                proposal: ProposedViewSize(frame.size)
            )
        }
    }
}

// MARK: - View

struct FlowLayoutView: View {
    let tags = ["SwiftUI", "Layout", "Flow", "Custom", "ViewBuilder", "Cache",
                "ProposedViewSize", "LayoutSubview", "Animation", "Transition",
                "Environment", "Preference", "GeometryReader", "ScrollView", "LazyVStack"]

    @State private var lineLimit = 0

    var body: some View {
        VStack(spacing: 24) {
            Text("가로 공간을 채운 뒤 넘치면 다음 줄로 배치")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Stepper("Line Limit: \(lineLimit == 0 ? "∞" : "\(lineLimit)")", value: $lineLimit.animation(), in: 0...5)
                .padding(.horizontal)

            FlowLayout(itemSpacing: 8, lineSpacing: 8, lineLimit: lineLimit) {
                ForEach(tags, id: \.self) { tag in
                    Text(tag)
                        .font(.subheadline)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            Capsule()
                                .fill(Color.accentColor.opacity(0.15))
                        )
                }
            }
            // lineLimit 초과 뷰는 size .zero로 배치되지만 뷰 자체는 렌더링되므로
            // clipped로 잘라내야 함. antialiased는 clipping 시 부드러운 경계 처리
            .clipped(antialiased: lineLimit > 0)
            .border(.pink)
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationTitle("Flow Layout")
    }
}

#Preview {
    NavigationStack {
        FlowLayoutView()
    }
}
