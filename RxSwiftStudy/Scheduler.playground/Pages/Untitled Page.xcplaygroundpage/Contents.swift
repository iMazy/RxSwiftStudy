//: A UIKit based Playground for presenting user interface

import RxSwift

let disposeBag = DisposeBag()
///////////////////////////////////////////////////////////////////////////////
/// Schedulers
/// - Schedulers: 调度器, 类似于 线程 (GCD, Thread)
/// - Schedulers 是 Rx 实现 多线程的核心模块, 主要控制任务在哪个线程或队列执行

let rxData: Observable<Data> = Observable.create { (observer) -> Disposable in
    observer.onNext(Data(base64Encoded: "hello"))
    observer.onNext(Data(base64Encoded: "world"))
    observer.onCompleted()
    return Disposables.create()
}

/// eg:
rxData.subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)).observeOn(MainScheduler.instance).subscribe(onNext: { data in
    print(data)
}).disposed(by: disposeBag)

//: 使用 subscribeOn
/// 使用 subscribeOn 来决定数据序列的构建函数在哪个 Scheduler 上运行
/// 上例中, 获取 Data 需要花费时间, 所以用 subscribeOn 切换到后台 Schedulers 来获取 Data. 避免主线程被阻塞

//: - 使用 observeOn
/// 使用 observeOn 来决定在哪个 Scheduler 监听这个序列.

/// 一个比较典型的例子就是，在后台发起网络请求，然后解析数据，最后在主线程刷新页面。你就可以先用 subscribeOn 切到后台去发送请求并解析数据，最后用 observeOn 切换到主线程更新页面。


//: - MainScheduler
/// 代表主线程。如果你需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler 运行。

//: - SerialDispatchQueueScheduler
/// 抽象了串行 DispatchQueue。如果你需要执行一些串行任务，可以切换到这个 Scheduler 运行。

//: - ConcurrentDispatchQueueScheduler
/// 抽象了并行 DispatchQueue。如果你需要执行一些并发任务，可以切换到这个 Scheduler 运行。

//: - OperationQueueScheduler
/// OperationQueueScheduler 抽象了 NSOperationQueue。


