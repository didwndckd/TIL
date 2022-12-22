//
//  CustomSubscriber.swift
//  CombinePlayground
//
//  Created by YJC on 2022/12/22.
//

import Foundation
import Combine

final class CustomSubscriber<Input, Failure: Error>: Subscriber {
    
    
    private var receiveSubscription: ((Subscription) -> Void)?
    private var receiveInput: ((Input) -> Subscribers.Demand)?
    private var receiveCompletion: ((Subscribers.Completion<Failure>) -> Void)?
    
    init(receiveSubscription: ((Subscription) -> Void)?,
         receiveInput: ((Input) -> Subscribers.Demand)?,
         receiveCompletion: ((Subscribers.Completion<Failure>) -> Void)?) {
        self.receiveSubscription = receiveSubscription
        self.receiveInput = receiveInput
        self.receiveCompletion = receiveCompletion
    }
    
    deinit {
        print("deinit -> \(type(of: self))")
    }
    
    func receive(subscription: Subscription) {
        print(self, #function, "subscription: \(subscription)")
        self.receiveSubscription?(subscription)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        print(self, #function, "input: \(input)")
        return self.receiveInput?(input) ?? .none
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        print(self, #function, "completion: \(completion)")
        self.receiveCompletion?(completion)
    }
}
