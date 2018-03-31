//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

///////////////////////////////////////////////////////////////////////////////
/// Create
/// Create 操作符用来创建一个 Observable

/// 创建可观察对象
let id = Observable<Int>.create {  observer in
    observer.onNext(0)
    observer.onNext(1)
    observer.onNext(2)
    observer.onNext(3)
    observer.onNext(4)
    observer.onCompleted()
    return Disposables.create()
}

/// 订阅可观察对象
id.subscribe(onNext: { id in
    print(id)
}, onCompleted: {
    print("completed")
})


///////////////////////////////////////////////////////////////////////////////
/// deferred
/// deferred 直到订阅发生, 才会创建 Observable, 并且为每位订阅者创建全新的 Observable

let deferID = Observable<Int>.deferred { () -> Observable<Int> in
    return Observable<Int>.create({ observer in
        observer.onNext(666)
        observer.onCompleted()
        return Disposables.create()
    })
}

///////////////////////////////////////////////////////////////////////////////
/// Empty
/// 创建一个只有一个完成事件的 Observable

let emptyId = Observable<Int>.empty()

/// 等价于
let emptyId1 = Observable<Int>.create { observer -> Disposable in
    observer.onCompleted()
    return Disposables.create()
}


///////////////////////////////////////////////////////////////////////////////
/// Never
/// 创建一个不会产生任何事件的 Observable

let neverID = Observable<Int>.never()

/// 等价于
let neverID2 = Observable<Int>.create { (observer) -> Disposable in
    return Disposables.create()
}


///////////////////////////////////////////////////////////////////////////////
/// From
/// 将其他类型或者数据结构转换为 Observable

/// eg: 1 将一个数组转换为 Observable
let numbers = Observable.from([0, 1, 2])
/// 等价于
let numbers1 = Observable<Int>.create { (observer) -> Disposable in
    observer.onNext(0)
    observer.onNext(1)
    observer.onNext(2)
    observer.onCompleted()
    return Disposables.create()
}

/// eg: 2 将一个可选值转换为 Observable
let optional: String? = nil
let value = Observable.from(optional: optional)
/// 等价于
let optional1 = Observable<String>.create { (observer) -> Disposable in
    if let element = optional {
        observer.onNext(element)
    }
    observer.onCompleted()
    return Disposables.create()
}


///////////////////////////////////////////////////////////////////////////////
/// Interval
/// 创建一个每隔一段时间, 发出一个索引数的 Observable

let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
interval.subscribe ({ event in
    print(event)
})


///////////////////////////////////////////////////////////////////////////////
/// Just
/// 创建一个只产生唯一一个元素的 Observable

let justID = Observable.just(0)
/// 等价于
let justID1 = Observable<Int>.create { (observer) -> Disposable in
    observer.onNext(0)
    observer.onCompleted()
    return Disposables.create()
}


///////////////////////////////////////////////////////////////////////////////
/// Range
/// 创建一个发射特定整数序列的 Observable
let rangeID = Observable<Int>.range(start: 0, count: 10)
rangeID.subscribe(onNext: { (num) in
    print(num)
}, onCompleted: {
    print("completed")
})


///////////////////////////////////////////////////////////////////////////////
/// RepeatElement
/// 创建一个重复发出某个元素的 Observable

let repeatID = Observable.repeatElement(666)
//repeatID.subscribe(onNext: { element in
//    print(element)
//})


///////////////////////////////////////////////////////////////////////////////
/// StartWith
/// 创建一个以某个元素开始的 Observable
Observable.of("🐶", "🐱", "🐭", "🐹")
    .startWith("1")
    .startWith("2")
    .startWith("3")
    .startWith("4", "A", "B")
    .subscribe(onNext: { element in
    print(element)
})


///////////////////////////////////////////////////////////////////////////////
/// Timer
/// 创建一个每隔一段时间产生一个元素的 Observable
let timerID = Observable<Int>.timer(1, scheduler: MainScheduler.instance)

timerID.subscribe(onNext: { (num) in
    print(num)
})


///////////////////////////////////////////////////////////////////////////////
/// Generate
/// 该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的 Observable 序列
let generateID = Observable<Int>.generate(initialState: 0,
                                          condition: { $0 <= 10},
                                          iterate: { $0 + 2 })


//let generateID = Observable<Int>.generate(initialState: 0, condition: { (num) -> Bool in
//    return num <= 10
//}) { (num) -> Int in
//    num + 2
//}

/// 等价于:
// 使用of()方法
let generateIDs = Observable.of(0 , 2 ,4 ,6 ,8 ,10)

generateID.subscribe(onNext: { (num) in
    print(num)
})

