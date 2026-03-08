//
//  ContentView.swift
//  ProSwiftUI
//
//  Created by yjc on 1/6/26.
//

import SwiftUI
internal import Combine

struct ExampleView: View {
    @State private var counter = 0
    let color: Color

    var body: some View {
        Button {
            counter += 1
        } label: {
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

struct EqualWidthHStack: Layout {
    
    private func maximumSize(across subviews: Subviews) -> CGSize {
        var maximumSize = CGSize.zero

        for view in subviews {
            let size = view.sizeThatFits(.unspecified)

            if size.width > maximumSize.width {
                maximumSize.width = size.width
            }

            if size.height > maximumSize.height {
                maximumSize.height = size.height
            }
        }

        return maximumSize
    }
    
    private func spacing(for subviews: Subviews) -> [Double] {
        var spacing = [Double]()

        for index in subviews.indices {
            if index == subviews.count - 1 {
                spacing.append(0)
            } else {
                let distance = subviews[index].spacing.distance(to: subviews[index + 1].spacing, along: .horizontal)
                spacing.append(distance)
            }
        }

        return spacing
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let maxSize = maximumSize(across: subviews)
        let spacing = spacing(for: subviews)
        let totalSpacing = spacing.reduce(0, +)

        return CGSize(width: maxSize.width * Double(subviews.count) + totalSpacing, height: maxSize.height)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let maxSize = maximumSize(across: subviews)
        let spacing = spacing(for: subviews)
        let proposal = ProposedViewSize(width: maxSize.width, height: maxSize.height)
        var x = bounds.minX + maxSize.width / 2
//        var x = bounds.minX
        
        for index in subviews.indices {
            subviews[index].place(
                at: CGPoint(x: x, y: bounds.midY),
                anchor: .center,
//                anchor: .leading,
                proposal: proposal
            )
            x += maxSize.width + spacing[index]
        }
    }
}

struct RelativeHStack: Layout {
    var spacing = 0.0
    
    func frames(for subviews: Subviews, in totalWidth: Double) -> [CGRect] {
        let totalSpacing = spacing * Double(subviews.count - 1)
        let availableWidth = totalWidth - totalSpacing
        let totalPriorities = subviews.reduce(0) { $0 + $1.priority }
        var viewFrames = [CGRect]()
        var x = 0.0
        
        for subview in subviews {
            let subviewWidth = availableWidth * subview.priority / totalPriorities
            let proposal = ProposedViewSize(width: subviewWidth, height: nil)
            let size = subview.sizeThatFits(proposal)
            let frame = CGRect(x: x, y: 0, width: size.width, height: size.height)
            viewFrames.append(frame)
            x += size.width + spacing
        }

        return viewFrames
    }
    
    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) -> CGSize {
        let width = proposal.replacingUnspecifiedDimensions().width
        let viewFrames = frames(for: subviews, in: width)
        let height = viewFrames.max { $0.maxY < $1.maxY } ?? .zero
        return CGSize(width: width, height: height.maxY)
    }
    
    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout Void) {
        let viewFrames = frames(for: subviews, in: bounds.width)

        for index in subviews.indices {
            let frame = viewFrames[index]
            let position = CGPoint(x: bounds.minX + frame.minX, y: bounds.midY)
            subviews[index].place(at: position, anchor: .leading, proposal: ProposedViewSize(frame.size))
        }
    }
}

struct ContentView: View {
    var body: some View {
        RelativeHStack(spacing: 1) {
            Text("First")
                .frame(maxWidth: .infinity)
                .background(.red)
                .layoutPriority(1)

            Text("Second")
                .frame(maxWidth: .infinity)
                .background(.green)
                .layoutPriority(2)

            Text("Third")
                .frame(maxWidth: .infinity)
                .background(.blue)
                .layoutPriority(3)
        }
        .border(.yellow)
    }
}


#Preview {
    ContentView()
}
