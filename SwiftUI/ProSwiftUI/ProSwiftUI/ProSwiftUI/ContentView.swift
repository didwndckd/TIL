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

struct ContentView: View {
    @State private var isRed = false

    var body: some View {
        Text("Hello, World!")
            .foregroundColor(.white)
            .colorMultiply(isRed ? .red : .blue)
            .font(.largeTitle.bold())
            .onTapGesture {
                withAnimation {
                    isRed.toggle()
                }
            }
    }
}

#Preview {
    ContentView()
}
