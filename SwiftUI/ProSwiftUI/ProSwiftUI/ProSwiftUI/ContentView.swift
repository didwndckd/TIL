//
//  ContentView.swift
//  ProSwiftUI
//
//  Created by yjc on 1/6/26.
//

import SwiftUI

struct CustomFont: ViewModifier {
    func body(content: Content) -> some View {
        content.font(.largeTitle)
    }
}

@resultBuilder
struct S {
    static func buildBlock(_ components: Int...) -> Int {
        components.reduce(0, +)
    }
    static func buildEither(first component: Int) -> Int {
        component
    }
    
}

@resultBuilder
struct IntArrayBuilder {
  static func buildBlock(_ parts: Int...) -> [Int] { parts }
  static func buildEither(first: [Int]) -> [Int] { first }
  static func buildEither(second: [Int]) -> [Int] { second }
  static func buildIf(_ part: [Int]?) -> [Int] { part ?? [] }
  static func buildExpression(_ value: Int) -> [Int] { [value] }
}

func makeInts(@IntArrayBuilder _ content: () -> [Int]) -> [Int] {
  content()
}

struct ContentView: View {
    var body: some View {
        Text("Hello")
            .background(Bool.random() ? Color.blue : nil)
            .onTapGesture {
                print(type(of: self.body))
            }
    }
}

#Preview {
    ContentView()
}
