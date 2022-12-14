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
        private var demand: Subscribers.Demand = .unlimited
        
        init(subscriber: S, datas: [Output]) {
            self.subscriber = subscriber
            self.datas = datas
        }
        
        deinit {
            Swift.print("deinit -> \(type(of: self))")
        }
        
        func request(_ demand: Subscribers.Demand) {
            Swift.print(type(of: self), #function, "demand:", demand)
            
            self.demand = demand
            
            self.excuteData()
        }
        
        func cancel() {
            Swift.print(type(of: self), #function)
            self.datas = []
        }
        
        private func excuteData() {
            Swift.print(type(of: self), #function, "datas: \(self.datas)")
            
            guard !self.datas.isEmpty, self.demand > .none else {
                self.subscriber.receive(completion: .finished)
                return
            }
            
            let data = self.datas.removeFirst()
            self.demand += self.subscriber.receive(data)
            self.demand -= 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                self.excuteData()
            })
        }
    }
}
