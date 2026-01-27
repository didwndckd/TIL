//
//  ContentView.swift
//  ProSwiftUI
//
//  Created by yjc on 1/6/26.
//

import SwiftUI

struct AnimatableZIndexModifier: ViewModifier, Animatable {
    var animatableData: Double {
        get { index }
        set { print(newValue); index = newValue }
    }
    
    var index: Double

    func body(content: Content) -> some View {
        content
            .zIndex(index)
    }
}

struct AnimatableFontModifier: ViewModifier, Animatable {
    var size: Double

    var animatableData: Double {
        get { size }
        set { print(size); size = newValue }
    }

    func body(content: Content) -> some View {
        content
            .font(.system(size: size))
    }
}

extension View {
    func animatableZIndex(_ index: Double) -> some View {
        self.modifier(AnimatableZIndexModifier(index: index))
    }
    
    func animatableFont(size: Double) -> some View {
        self.modifier(AnimatableFontModifier(size: size))
    }
    
    func animatableForegroundColor(_ color: Color) -> some View {
            self
                .foregroundColor(.white)
                .colorMultiply(color)
        }
}

struct CountingText: View, Animatable {
    var animatableData: Double {
        get { value }
        set { value = newValue }
    }
    
    var value: Double
    var fractionLength = 8

    var body: some View {
        Text(value.formatted(.number.precision(.fractionLength(fractionLength))))
    }
}

struct TypewriterText: View, Animatable {
    var string: String
    var count = 0

    var animatableData: Double {
        get { Double(count) }
        set { count = Int(max(0, newValue)) }
    }

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
}

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

#Preview {
    ContentView()
}
