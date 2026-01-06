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
            .background(.blue)
            .frame(width: 250)
            .background(.red)
            .frame(minWidth: 400)
            .background(.yellow)
    }
}

#Preview {
    ContentView()
}
