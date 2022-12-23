import Foundation
import Combine

var cancelStore = Set<AnyCancellable>()

print("Just")
Just(1)
    .sink(
        receiveCompletion: { completion in
        print("completion: \(completion)")
    }, receiveValue: { value in
        print("value: \(value)")
    })
    .store(in: &cancelStore)

print("\nFuture")

Future<Int, Never>() { promiss in
    promiss(.success(1))
}
.sink(
    receiveCompletion: { completion in
        print("completion: \(completion)")
    }, receiveValue: { value in
        print("value: \(value)")
    })
.store(in: &cancelStore)

