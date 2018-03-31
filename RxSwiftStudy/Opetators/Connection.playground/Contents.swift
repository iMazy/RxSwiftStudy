//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

/// Connect

///////////////////////////////////////////////////////////////////////////////
/// Publish
/// publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
/// 将 Observable 转换为可被连接的 Observable

let intSequence = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()

intSequence.subscribe(onNext: {  print("Subscription 1:, Event: \($0)") })

DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()  + 2) {
    _ = intSequence.connect()
}

DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()  + 4) {
    _ = intSequence.subscribe(onNext: {  print("Subscription 2:, Event: \($0)") })
}

DispatchQueue.main.asyncAfter(deadline: DispatchTime.now()  + 6) {
    _ = intSequence.subscribe(onNext: {  print("Subscription 3:, Event: \($0)") })
}


///////////////////////////////////////////////////////////////////////////////
/// RefCount
/// refCount 操作符可以将可被连接的 Observable 转换为普通 Observable


//每隔1秒钟发送1个事件
let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    .publish()
    .refCount()

//第一个订阅者（立刻开始订阅）
_ = interval.subscribe(onNext: { print("订阅1: \($0)") })

//第二个订阅者（延迟5秒开始订阅）

DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
    _ = interval.subscribe(onNext: { print("订阅2: \($0)") })
}


///////////////////////////////////////////////////////////////////////////////
/// Replay
// replay 同上面的 publish 方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
// replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）。


//每隔1秒钟发送1个事件
let interval1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
    .replay(5)

//第一个订阅者（立刻开始订阅）
_ = interval1
    .subscribe(onNext: { print("订阅1: \($0)") })

//相当于把事件消息推迟了两秒
DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
    _ = interval1.connect()
}

//第二个订阅者（延迟5秒开始订阅）

DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5) {
    _ = interval1.subscribe(onNext: { print("订阅2: \($0)") })
}

