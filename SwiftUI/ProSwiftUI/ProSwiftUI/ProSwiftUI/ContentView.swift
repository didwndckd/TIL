//
//  ContentView.swift
//  ProSwiftUI
//
//  Created by yjc on 1/6/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Layout and Identity") {
                    NavigationLink("Parents and Children", destination: ParentsAndChildrenView())
                    NavigationLink("Fixing View Sizes", destination: FixingViewSizesView())
                    NavigationLink("Layout Neutrality", destination: LayoutNeutralityView())
                    NavigationLink("Multiple Frames", destination: MultipleFramesView())
                    NavigationLink("Inside TupleView", destination: InsideTupleViewView())
                    NavigationLink("Understanding Identity", destination: UnderstandingIdentityView())
                    NavigationLink("Optional Views", destination: OptionalViewsView())
                }

                Section("Animations and Transitions") {
                    Text("Animations and Transitions")
                }

                Section("Environment and Preferences") {
                    Text("Environment and Preferences")
                }

                Section("Custom Layouts") {
                    Text("Custom Layouts")
                }

                Section("Drawing and Effects") {
                    Text("Drawing and Effects")
                }

                Section("Performance") {
                    Text("Performance")
                }
            }
            .navigationTitle("Pro SwiftUI")
        }
    }
}

#Preview {
    ContentView()
}
