import Foundation
import Combine

Just(1)
    .sink(
        receiveCompletion: { completion in
        print("completion: \(completion)")
    }, receiveValue: { value in
        print("value: \(value)")
    })
