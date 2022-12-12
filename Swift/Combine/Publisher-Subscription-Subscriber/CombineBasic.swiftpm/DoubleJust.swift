//
//  DoubleJust.swift
//  CombineBasic
//
//  Created by YJC on 2022/12/12.
//

import Foundation
import Combine

struct DoubleJust<Output, Failure: Error>: Publisher {
    
    private let data: Output
    
    init(data: Output) {
        self.data = data
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        Swift.print(type(of: self), #function, "subscriber:", type(of: subscriber))
        let _ = subscriber.receive(self.data)
        let _ = subscriber.receive(self.data)
        subscriber.receive(completion: .finished)
    }
}
