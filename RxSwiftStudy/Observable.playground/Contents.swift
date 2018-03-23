
import RxSwift
import RxCocoa

///////////////////////////////////////////////////////////////////////////////
/// Observable
/// 可被监听的序列
/// 创建可观察序列
let numbers: Observable<Int> = Observable.create { (observer) -> Disposable in
    observer.onNext(0)
    observer.onNext(1)
    observer.onNext(2)
    observer.onNext(3)
    observer.onNext(4)
    observer.onNext(5)
    observer.onNext(6)
    observer.onNext(7)
    observer.onNext(8)
    observer.onNext(9)
    observer.onCompleted()
    
    return Disposables.create()
}
/// 订阅可观察者
numbers.subscribe(onNext: { (number) in
    print(number)
}, onCompleted: {
    print("completed")
}, onDisposed: {
    print("disposed")
})

/// Event 事件
public enum Event<Element> {
    case next(Element)
    case error(Swift.Error)
    case completed
}


///////////////////////////////////////////////////////////////////////////////
/// Single
/// 要不发出一个元素 要不产生一个error
let single: Single<String> = Single.create { (_) -> Disposable in
    return Disposables.create()
}

single.subscribe(onSuccess: { (str) in
    print(str)
}) { (error) in
    print(error)
}

/// 完成 并返回一个值
/// 失败 并获取失原因
public enum SingleEvent<Element> {
    case success(Element)
    case error(Swift.Error)
}

///////////////////////////////////////////////////////////////////////////////
/// Completable
/// 发出 0 个元素, 要不产生一个 completed 事件 要不产生一个 error

let complete: Completable = Completable.create { (_) -> Disposable in
    return Disposables.create()
}

complete.subscribe(onCompleted: {
    print("完成") // 只要完成的事件 没有值
}) { (error) in
    print("error: \(error)")
}

/// 完成 无返回值
/// 失败 并获取失原因
public enum CompletableEvent {
    case completed
    case error(Swift.Error)
}


///////////////////////////////////////////////////////////////////////////////
/// Maybe
/// 介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件

let maybe: Maybe<Bool> = Maybe.create { (_) -> Disposable in
    return Disposables.create()
}

maybe.subscribe(onSuccess: { (success) in
    print(success) // or
}, onError: { (error) in
    print(error) // or
}, onCompleted: {
    print("completed") // or
})


///////////////////////////////////////////////////////////////////////////////
/// Driver
/// 主要用于 UI 层
/// 不会产生 error
/// 一定在主线程 MainScheduler 监听

let driver: Observable<String> = Observable.create { (observer) -> Disposable in
    observer.onNext("hello")
    observer.onCompleted()
    return Disposables.create()
}

let textField = UITextField()
/// 将字符序列转成 Driver
textField.rx.text.asDriver().do(onNext: { (text) in
    print(text ?? "")
}, onCompleted: {
    print("completed")
})





