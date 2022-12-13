//
//  ContentViewModel.swift
//  CombineBasic
//
//  Created by YJC on 2022/12/12.
//

import Foundation
import Combine

func printWithSeparator(_ items: Any...) {
    print("===========================", items.map { "\($0)" }.joined(separator: " "), "===========================")
}

final class ContentViewModel: ObservableObject {
    private var cancelStore = Set<AnyCancellable>()
    private var cancelable: AnyCancellable?
    private var publisher: AnyPublisher<String, Never>
    
    
    @Published var state = State()
    
    init() {
        self.publisher = CollectionJust<String, Never>(datas: ["DoubleJust"])
            .eraseToAnyPublisher()
        self.bind()
    }
}

extension ContentViewModel {
    struct State {
        var input: String = ""
        var result: String = ""
        var resultText: String {
            return self.result.isEmpty ? "Result": self.result
        }
    }
    
    enum Action {
        case createCollectionJust
        case cancel
        case sink
        case assign
    }
    
    func action(_ action: Action) {
        switch action {
        case .createCollectionJust: self.createCollectionJust()
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
        printWithSeparator(#function, publisher)
        self.publisher = publisher
//            .handleEvents(receiveSubscription: { print("publisher -> receiveSubscription subscription: \(type(of: $0))") },
//                          receiveOutput: { print("publisher -> receiveOutput output: \($0)") },
//                          receiveCompletion: { print("publisher -> receiveCompletion completion: \($0)") },
//                          receiveCancel: { print("publisher -> receiveCancel") },
//                          receiveRequest: { print("publisher -> receiveRequest demand: \($0)") })
            .eraseToAnyPublisher()
    }
}

extension ContentViewModel {
    private func createCollectionJust() {
        printWithSeparator(#function)
        let datas = self.state.input.split(separator: " ").map { String($0) }
        self.switchPublisher(CollectionJust<String, Never>(datas: datas))
    }
    
    private func cancel() {
        printWithSeparator(#function)
        self.cancelable = nil
    }
    
    private func sink() {
        printWithSeparator(#function)
        
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
        printWithSeparator(#function)
        self.cancelable = self.publisher
            .assign(to: \.state.result, on: self)
    }
}
