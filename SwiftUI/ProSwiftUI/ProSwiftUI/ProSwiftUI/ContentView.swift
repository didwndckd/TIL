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
    var body: some View {
        Text("Hello, World!")
            .frame(idealWidth: 300, idealHeight: 200)
            .background(.red)
    }
}

#Preview {
    ContentView()
}
