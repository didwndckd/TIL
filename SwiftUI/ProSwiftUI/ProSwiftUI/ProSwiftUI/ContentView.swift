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
                    NavigationLink("Animating the Unanimatable", destination: AnimatingTheUnanimatableView())
                    NavigationLink("Custom Timing Curves", destination: CustomTimingCurvesView())
                    NavigationLink("Overriding Animations", destination: OverridingAnimationsView())
                    NavigationLink("Advanced Transitions", destination: AdvancedTransitionsView())
                }

                Section("Environment and Preferences") {
                    NavigationLink("Custom Environment Key", destination: CustomEnvironmentKeyView())
                    NavigationLink("Overriding Environment", destination: OverridingEnvironmentView())
                    NavigationLink("Custom PreferenceKey", destination: CustomPreferenceKeyView())
                    NavigationLink("Anchor Preferences", destination: AnchorPreferencesView())
                }

                Section("Custom Layouts") {
                    NavigationLink("Adaptive Layouts", destination: AdaptiveLayoutsView())
                    NavigationLink("Radial Layout (with Animations)", destination: RadialLayoutView())
                    NavigationLink("Equal Width Layout", destination: EqualWidthLayoutView())
                    NavigationLink("Relative Width Layout", destination: RelativeWidthLayoutView())
                    NavigationLink("Masonry Layout(with Cache)", destination: MasonryLayoutView())
                    NavigationLink("Flow Layout", destination: FlowLayoutView())
                }

                Section("Drawing and Effects") {
                    NavigationLink("Drawing with Canvas", destination: DrawingWithCanvasView())
                    NavigationLink("Falling Snow", destination: FallingSnowView1())
                    NavigationLink("Falling Snow (Lava)", destination: FallingSnowView2())
                    NavigationLink("Lava Lamp", destination: LavaLampView())
                    NavigationLink("Blurred backgrounds", destination: BlurredBackgroundsView())
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
