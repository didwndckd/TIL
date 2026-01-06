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
        ScrollView {
            Color.red
                    .frame(minWidth: nil, idealWidth: nil, maxWidth: nil, minHeight: nil, idealHeight: 400, maxHeight: 400)

        }
    }
}

#Preview {
    ContentView()
}
