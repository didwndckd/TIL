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

struct ContentView: View {
    @State private var usesFixedSize = false
    
    var body: some View {
        Text("Hello, World!")
            .frame(width: 250)
            .frame(minHeight: 400)
    }
}

#Preview {
    ContentView()
}
