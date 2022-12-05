import Foundation
import Combine

struct SomePublisher<Output, Failure: Error>: Publisher {
    
    let data: Output
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        print("Publisher.\(#function)")
        let subscription = SomeSubscription()
        subscriber.receive(subscription: subscription)
    }
}

struct SomeSubscription: Subscription {
    var combineIdentifier: CombineIdentifier = .init()
    
    func request(_ demand: Subscribers.Demand) {
        print("Subscription.\(#function)")
    }
    
    func cancel() {
        print("cancel")
    }
}

struct SomeConnectablePublisher<Output, Failure: Error>: ConnectablePublisher {
    func connect() -> Cancellable {
        return AnyCancellable({})
    }
    
    func receive<S>(subscriber: S) where S : Subscriber, Failure == S.Failure, Output == S.Input {
        print("Publisher.\(#function)")
    }
}

struct SomeSubscriber<Input, Failure: Error>: Subscriber {
    var combineIdentifier: CombineIdentifier = .init()
    
    func receive(subscription: Subscription) {
        print("Subscriber.\(#function)")
        subscription.request(.unlimited)
    }
    
    func receive(_ input: Input) -> Subscribers.Demand {
        print("Subscriber.\(#function)")
        return .unlimited
    }
    
    func receive(completion: Subscribers.Completion<Failure>) {
        print("Subscriber.\(#function)")
    }
}

let s = SomeSubscriber<String, Never>(combineIdentifier: .init())
let p = SomePublisher<String, Never>(data: "data").subscribe(s)

print(p)



//Just("abc")
//    .subscribe(s)
//
//
//let f = Future<String, Never> { promiss in
////    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
////        promiss(.success("AAA"))
////    })
//    promiss(.success("AAA"))
//}
//
//var store = Set<AnyCancellable>()
//
//f.sink(receiveCompletion: { print("complete: \($0)")},
//       receiveValue: { print("value: \($0)")})
//.store(in: &store)
