//
//  DoubleJust.swift
//  CombineBasic
//
//  Created by YJC on 2022/12/12.
//

import Foundation
import Combine

struct CollectionJust<Output, Failure: Error>: Publisher {
    
    private let datas: [Output]
    
    init(datas: [Output]) {
        self.datas = datas
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        Swift.print(type(of: self), #function, "subscriber:", type(of: subscriber))
        let subscription = InnerSubscription(subscriber: subscriber, datas: self.datas)
        subscriber.receive(subscription: subscription)
    }
}

extension CollectionJust {
    final class InnerSubscription<S: Subscriber>: Combine.Subscription where Output == S.Input, Failure == S.Failure {
        private let subscriber: S
        private var datas: [Output]
        
        init(subscriber: S, datas: [Output]) {
            self.subscriber = subscriber
            self.datas = datas
        }
        
        deinit {
            Swift.print("deinit -> \(type(of: self))")
        }
        
        func request(_ demand: Subscribers.Demand) {
            Swift.print(type(of: self), #function, "demand:", demand)
            
            guard demand >= self.datas.count else {
                self.subscriber.receive(completion: .finished)
                return
            }
            
            self.excuteData()
        }
        
        func cancel() {
            Swift.print(type(of: self), #function)
            self.datas = []
        }
        
        private func excuteData() {
            Swift.print(type(of: self), #function, "datas: \(self.datas)")
            
            guard !self.datas.isEmpty else {
                self.subscriber.receive(completion: .finished)
                return
            }
            
            let data = self.datas.removeFirst()
            let newDemand = self.subscriber.receive(data)
            
            Swift.print(type(of: self), "newDemand: \(newDemand)")
//            guard newDemand > .none, self.datas.count > nextIndex else {
//                self.subscriber.receive(completion: .finished)
//                return
//            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.excuteData()
            })
        }
    }
}
