import RxSwift
import UIKit

//protocol ObseverType {
//    associatedtype E
//    func on(_ event: Event<E>)
//}


class IntegetPrinter: ObserverType {
    
    func on(_ event: Event<Int>) {
        switch event {
        case let .next(value):
            print("value:", value)
        case let .error(error):
            print("error:", error.localizedDescription)
        case .completed:
            print("completed")
        }
    }
    
}

let x: Observable<Int> = Observable.just(1)

let integerPrinter = IntegetPrinter()
let disposeBag = DisposeBag()

x.subscribe(integerPrinter).disposed(by: disposeBag)


let getGooglePage: Observable<Data> = Observable.create { (observer: AnyObserver<Data>) in
    
    let url: URL = URL(string: "https://google.com")!
    
    let dataTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
        
        if let data = data {
            observer.onNext(data)
            observer.onCompleted()
        }
        
        if let error = error {
            observer.onError(error)
        }
        
    })
    
    dataTask.resume()
    
    return Disposables.create { dataTask.cancel()
    
    }
    
}


let subscription: Disposable = getGooglePage.subscribe(onNext: { (data: Data) in
    print(data)
})

//let disposeBag = DisposeBag()
//subscription.disposed(by: disposeBag)

//subscription.dispose()



class Subject {
    let disposBag = DisposeBag()
    let numbers$ = PublishSubject<Int>()
    
    init() {
        numbers$
            .subscribe(onNext: { print("Observer1: \($0)") } )
            .disposed(by: disposeBag)
        numbers$.onNext(0)
        numbers$.onNext(1)
        
        numbers$
            .subscribe(onNext: { print("Observer 2: \($0)") })
            .addDisposableTo(disposeBag)
        
        numbers$.onNext(2)
        numbers$.onNext(3)
        numbers$.onCompleted()
    }
}

//Subject()



class ObservableExample {
    
    let one$: Observable<Int> = Observable.just(1)
    let error$: Observable<Int> = Observable.error(NSError(domain: "error", code: 1))
    let empty$: Observable<Int> = Observable.empty()
    let flag$: Observable<Bool> = Observable.of(true, false)
    let number$: Observable<Int> = Observable.from([1, 2, 3])
    let interval$: Observable<Int> = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    
    init() {
        
//        interval$.subscribe(onNext: { print($0) })
        
    }
    
}

ObservableExample()

class ObservableFilteringExample {
    
    init() {
        let interval$: Observable<Int> = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        // 0-1-2-3-4-5-6-7...
        
        let oddNumber$: Observable<Int> = interval$.filter { $0 % 2 == 1 }
        // --1---3---5---7
        
        let lessThan4$: Observable<Int> = interval$.filter { $0 < 4 }
        // 0-1-2-3--------...
        
        let firstThree$: Observable<Int> = interval$.take(3)
        // 0-1-2|
        
        let skipThree$: Observable<Int> = interval$.skip(3)
        // ------3-4-5-6-7...
        
        let numbers = [1,2,3,4,4,5,5,3]
        
        
        
        let number$ = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .map { i in numbers[i%numbers.count] } // 1-2-3-4-4-5-5-3-1-2-3-4...
        number$.distinctUntilChanged()
        // 1-2-3-4---5---3-1-2-3-4...
        
        
    }
   
}

//ObservableFilteringExample()


class Observable변형 {
    init() {
        let number$: Observable<Int> = Observable.from([1, 2, 3])
        // 123|
        
        let numbers$ = number$.toArray()
        // [1, 2, 3]|
        
        let interval$: Observable<Int> = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        // 0-1-2-3-4-5-6-7....
        
        let string$ = interval$.map({ $0.description })
        // "0"-"1"-"2"-"3"-"4"-"5"...
        
        let plusTen$ = interval$.map({ $0 + 10 })
        // 10-11-12-13-14....
        
        interval$.subscribe(onNext: {print($0)})
    }
}

//Observable변형()


class FlatMapObsevable {
    init() {
        let source$ = Observable<Int>
            .interval(.seconds(2), scheduler: MainScheduler.instance) .take(2)
        
        let target$ = source$.flatMap { value in return Observable<Int>
            .interval(.seconds(1), scheduler: MainScheduler.instance) .take(3)
            .map { innerValue in "source: \(value), target: \(innerValue)" }
        }
        
        target$
            .subscribe(onNext: { print($0) }) .disposed(by: disposeBag)
        
        
    }
}


//FlatMapObsevable()

func flatMapLatest() {
    let source$ = Observable<Int>
        .interval(.seconds(2), scheduler: MainScheduler.instance)
        .take(2)
    let target$ = source$.flatMapLatest { value in return Observable<Int>
        .interval(.seconds(1), scheduler: MainScheduler.instance)
        .take(3)
        .map { innerValue in "source: \(value), target: \(innerValue)" }
    }
    target$
        .subscribe(onNext: { print($0) }) .disposed(by: disposeBag)
}

//flatMapLatest()


func observableZip() {
    let disposeBag = DisposeBag()
    let number$ = Observable<Int>
        .interval(.milliseconds(300), scheduler: MainScheduler.instance)
        .take(5)
    
    let letter$ = Observable<Int>
        .interval(.milliseconds(500), scheduler: MainScheduler.instance)
        .take(3)
        .map { ["A", "B", "C"][$0] }
    
    let combined$ = Observable.zip(number$, letter$)
    combined$
        .subscribe(onNext: { print($0) })
        .disposed(by: disposeBag)
}

observableZip()













