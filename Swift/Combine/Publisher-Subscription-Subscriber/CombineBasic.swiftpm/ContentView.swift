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
                self.createDoubleJustView
                self.sinkView
                self.assignView
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
        Text(self.viewModel.state.result)
    }
    
    @ViewBuilder
    private var createDoubleJustView: some View {
        Button("createDoubleJust") {
            self.viewModel.action(.createDoubleJust)
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
}
