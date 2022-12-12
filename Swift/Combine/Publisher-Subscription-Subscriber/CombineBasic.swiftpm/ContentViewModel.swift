//
//  ContentViewModel.swift
//  CombineBasic
//
//  Created by YJC on 2022/12/12.
//

import Foundation
import Combine

final class ContentViewModel: ObservableObject {
    private var cancelStore = Set<AnyCancellable>()
    
    private var publisher = DoubleJust<String, Never>(data: "DoubleJust").eraseToAnyPublisher()
    private var cancelable: AnyCancellable?
    
    @Published var state = State()
    
    init() {
        self.bind()
    }
}

extension ContentViewModel {
    struct State {
        var input: String = ""
        var result: String = ""
    }
    
    enum Action {
        case createDoubleJust
        case cancel
        case sink
        case assign
    }
    
    func action(_ action: Action) {
        switch action {
        case .createDoubleJust: self.createDoubleJust()
        case .cancel: self.cancel()
        case .sink: self.sink()
        case .assign: self.assign()
        }
    }
}

extension ContentViewModel {
    private func bind() {
        self.$state
            .sink(receiveValue: { print("receive state \($0)") })
            .store(in: &self.cancelStore)
    }
}

extension ContentViewModel {
    private func switchPublisher<P: Publisher>(_ publisher: P) where P.Output == String, P.Failure == Never {
        self.printWithSeparator(#function, publisher)
        self.publisher = publisher
//            .handleEvents(receiveSubscription: { print("publisher -> receiveSubscription subscription: \(type(of: $0))") },
//                          receiveOutput: { print("publisher -> receiveOutput output: \($0)") },
//                          receiveCompletion: { print("publisher -> receiveCompletion completion: \($0)") },
//                          receiveCancel: { print("publisher -> receiveCancel") },
//                          receiveRequest: { print("publisher -> receiveRequest demand: \($0)") })
            .eraseToAnyPublisher()
    }
    
    private func printWithSeparator(_ items: Any...) {
        print("===========================", items, "===========================")
    }
}

extension ContentViewModel {
    private func createDoubleJust() {
        self.printWithSeparator(#function)
        self.switchPublisher(DoubleJust<String, Never>(data: "DoubleJust ->" + self.state.input))
    }
    
    private func cancel() {
        self.printWithSeparator(#function)
        self.cancelable?.cancel()
        self.cancelable = nil
    }
    
    private func sink() {
        self.printWithSeparator(#function)
        
        self.cancelable = self.publisher
            .sink(
                receiveCompletion: { completion in
                    print("sink - receiveCompletion: \(completion)")
                },
                receiveValue: { value in
                    print("sink - receiveValue: \(value)")
                })
    }
    
    private func assign() {
        self.printWithSeparator(#function)
        self.cancelable = self.publisher
            .assign(to: \.state.result, on: self)
    }
}
