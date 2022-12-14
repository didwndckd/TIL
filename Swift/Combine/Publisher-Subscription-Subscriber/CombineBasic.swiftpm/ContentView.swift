import SwiftUI
import Combine

struct ContentView: View {
    
    @ObservedObject
    private var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            self.controlView.padding()
            self.resultView
            
            List {
                self.createCollectionJustView
                self.createJustView
                self.sinkView
                self.assignView
                self.customSubscriberView
            }
        }
    }
}

extension ContentView {
    @ViewBuilder
    private var controlView: some View {
        HStack {
            TextField("input", text: self.$viewModel.state.input)
                .textFieldStyle(.roundedBorder)
            
            Button("cancel") {
                self.viewModel.action(.cancel)
            }
        }
    }
    
    @ViewBuilder
    private var resultView: some View {
        Text(self.viewModel.state.resultText)
    }
    
    @ViewBuilder
    private var createCollectionJustView: some View {
        Button("createCollectionJust") {
            self.viewModel.action(.createCollectionJust)
        }
    }
    
    @ViewBuilder
    private var createJustView: some View {
        Button("createJust") {
            self.viewModel.action(.createJust)
        }
    }
    
    @ViewBuilder
    private var sinkView: some View {
        Button("sink") {
            self.viewModel.action(.sink)
        }
    }
    
    @ViewBuilder
    private var assignView: some View {
        Button("assign") {
            self.viewModel.action(.assign)
        }
    }
    
    @ViewBuilder
    private var customSubscriberView: some View {
        
        VStack(alignment: .leading) {
            Text("customSubscriber")
            HStack {
                Stepper(label: { Text("\(self.viewModel.state.customSubscriberDemand)") },
                        onIncrement: { self.viewModel.action(.customSubscriberDemand(1)) },
                        onDecrement: { self.viewModel.action(.customSubscriberDemand(-1)) },
                        onEditingChanged: { _ in })
                
                Spacer()
                
                Button("fire", action: {
                    self.viewModel.action(.customSubscriber)
                })
            }
            
        }
    }
}
