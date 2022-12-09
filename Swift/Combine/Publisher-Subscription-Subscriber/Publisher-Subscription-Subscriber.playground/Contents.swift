import Foundation
import Combine

struct CustomJust<Output, Failure: Error>: Publisher {
    private let data: Output
    
    init(_ data: Output) {
        self.data = data
    }

    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        Swift.print("CustomJust 구독 시작 -> \(type(of: subscriber))")
//        let inner = CustomJustSubscription(subscriber: subscriber, data: self.data)
//        subscriber.receive(subscription: inner)
//
        subscriber.receive(data)
        subscriber.receive(data)
        subscriber.receive(completion: .finished)
    }
}

extension CustomJust {
    private final class CustomJustSubscription<S: Subscriber>: Subscription where S.Input == CustomJust.Output, S.Failure == CustomJust.Failure {
        
        private let data: CustomJust.Output
        private let subscriber: S
        private var demand: Subscribers.Demand = .none
        
        deinit {
            Swift.print("CustomJustSubscription deinit")
        }
        
        init(subscriber: S, data: CustomJust.Output) {
            Swift.print("CustomJustSubscription init")
            self.subscriber = subscriber
            self.data = data
        }
        
        func request(_ demand: Subscribers.Demand) {
            Swift.print("CustomJustSubscription 데이터 요청: \(demand)")
            self.demand = demand
            
            guard self.demand > .none else {
                self.subscriber.receive(completion: .finished)
                return
            }
             
            self.demand = self.subscriber.receive(data)
            
            Swift.print("CustomJustSubscription receive 이후 \(self.demand)")
            
            if self.demand == .none {
                self.subscriber.receive(completion: .finished)
            }
        }
        
        func cancel() {
            Swift.print("CustomJustSubscription cencel")
            self.subscriber.receive(completion: .finished)
        }
    }
}

final class CustomJustSubscriber<Input, Failure: Error>: Subscriber {
    
    init() {
        print("CustomJustSubscriber init")
    }
    deinit {
        print("CustomJustSubscriber deinit")
    }
    
    func receive(subscription: Subscription) {
        print("CustomJustSubscriber 구독 시작: \(type(of: subscription))")
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        print("CustomJustSubscriber 값 받음: \(input)")
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        print("CustomJustSubscriber 구독 종료: \(completion)")
    }
}

let p = CustomJust<String, Never>("abc")
    .handleEvents(receiveSubscription: { print("p -> receiveSubscription subscription: \(type(of: $0))") },
                  receiveOutput: { print("p -> receiveOutput output: \($0)") },
                  receiveCompletion: { print("p -> receiveCompletion completion: \($0)")},
                  receiveCancel: { print("p -> receiveCancel") },
                  receiveRequest: { print("p -> receiveRequest demand: \($0)") })

print("===================CustomJustSubscriber===================")
let s = CustomJustSubscriber<String, Never>()

p.subscribe(s)

print("===================Sink=====================")

var store = Set<AnyCancellable>()

p.sink(receiveCompletion: { print("sink completion: \($0)") },
       receiveValue: { print("receive value: \($0)") })
.store(in: &store)

print("===================Assign=====================")

final class Test {
    var data: String = "" {
        didSet { print("Test 데이터 변경: \(self.data)") }
    }
}

let testObj = Test()
let cancelable = p.assign(to: \.data, on: testObj)

cancelable.cancel()

cancelable.store(in: &store)

print("===================Just, CustomJustSubscriber=====================")
