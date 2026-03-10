//
//  LavaLamp.swift
//  ProSwiftUI
//
//  Created by yjc on 3/9/26.
//

import SwiftUI

class LavaLampParticle: Identifiable {
    let id = UUID()
    var size = Double.random(in: 100...250)
    var x = Double.random(in: -0.1...1.1)
    var y = Double.random(in: -0.25...1.25)
    var isMovingDown = Bool.random()
    var speed = Double.random(in: 0.01...0.1)
}

class LavaLampParticleSystem {
    let particles: [LavaLampParticle]
    var lastUpdate = Date.now.timeIntervalSinceReferenceDate
    
    init(count: Int) {
        particles = (0..<count).map { _ in LavaLampParticle() }
    }

    func update(date: TimeInterval) {
        let delta = date - lastUpdate
        lastUpdate = date

        for particle in particles {
            if particle.isMovingDown {
                particle.y += particle.speed * delta

                if particle.y > 1.25 {
                    particle.isMovingDown = false
                }
            } else {
                particle.y -= particle.speed * delta

                if particle.y < -0.25 {
                    particle.isMovingDown = true
                }
            }
        }
    }
}

struct LavaLampView1: View {
    @State private var particleSystem = LavaLampParticleSystem(count: 15)
    @State private var threshold = 0.5
    @State private var blur = 30.0

        var body: some View {
            VStack {
                LinearGradient(colors: [.red, .orange], startPoint: .top, endPoint: .bottom).mask {
                    TimelineView(.animation) { timeline in
                        Canvas { ctx, size in
                            particleSystem.update(date: timeline.date.timeIntervalSinceReferenceDate)
                            ctx.addFilter(.alphaThreshold(min: threshold))
                            ctx.addFilter(.blur(radius: blur))

                            ctx.drawLayer { ctx in
                                for particle in particleSystem.particles {
                                    guard let symbol = ctx.resolveSymbol(id: particle.id) else { continue }
                                    let point = CGPoint(x: particle.x * size.width, y: particle.y * size.height)
                                    ctx.draw(symbol, at: point)
                                }
                            }
                        } symbols: {
                            ForEach(particleSystem.particles) { particle in
                                Circle()
                                    .frame(width: particle.size, height: particle.size)
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                .background(.indigo)

                LabeledContent("Threshold") {
                    Slider(value: $threshold, in: 0.01...0.99)
                }
                .padding(.horizontal)

                LabeledContent("Blur") {
                    Slider(value: $blur, in: 0...40)
                }
                .padding(.horizontal)
            }
        }
}

#Preview {
    LavaLampView1()
}
