//
//  ContentViewModel.swift
//  CombinePlayground
//
//  Created by YJC on 2022/12/22.
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
        var customSubscriberDemand = 0
    }
    
    enum Action {
        case createCollectionJust
        case createJust
        case cancel
        case sink
        case assign
        case customSubscriber
        case customSubscriberDemand(Int)
    }
    
    func action(_ action: Action) {
        switch action {
        case .createCollectionJust: self.createCollectionJust()
        case .createJust: self.createJust()
        case .cancel: self.cancel()
        case .sink: self.sink()
        case .assign: self.assign()
        case .customSubscriber: self.customSubscriber()
        case .customSubscriberDemand(let addition):
            self.state.customSubscriberDemand += addition
        }
    }
}

extension ContentViewModel {
    private func bind() {
//        self.$state
//            .sink(receiveValue: { print("receive state \($0)") })
//            .store(in: &self.cancelStore)
    }
}

extension ContentViewModel {
    private func switchPublisher<P: Publisher>(_ publisher: P) where P.Output == String, P.Failure == Never {
        printWithSeparator(#function, publisher)
        self.publisher = publisher.eraseToAnyPublisher()
    }
}

extension ContentViewModel {
    private func createCollectionJust() {
        printWithSeparator(#function)
        let datas = self.state.input.split(separator: " ").map { String($0) }
        self.switchPublisher(CollectionJust<String, Never>(datas: datas))
    }
    
    private func createJust() {
        let publisher = self.state.input
            .split(separator: " ")
            .publisher
            .delay(for: 1, scheduler: RunLoop.main)
            .print("Just ->")
            .map { String($0) }
            .receive(on: DispatchQueue.main)
        
        self.switchPublisher(publisher)
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
//                    self?.state.result = "\(completion)"
                },
                receiveValue: { [weak self] value in
                    print("sink - receiveValue: \(value)")
                    self?.state.result = "\(value)"
                })
    }
    
    private func assign() {
        printWithSeparator(#function)
        self.cancelable = self.publisher
            .assign(to: \.state.result, on: self)
    }
    
    private func customSubscriber() {
        let subscriber = CustomSubscriber<String, Never>(receiveSubscription: { [weak self] subscription in
            let demandRawValue = self?.state.customSubscriberDemand ?? 0
            let demand: Subscribers.Demand = demandRawValue > 0 ? .max(demandRawValue): .unlimited
            subscription.request(demand)
        }, receiveInput: { [weak self] input in
            self?.state.result = input
            return .none
        }, receiveCompletion: { completion in
//            print("customSubscriber - completion: \(completion)")
        })
        
        self.publisher.subscribe(subscriber)
    }
}

