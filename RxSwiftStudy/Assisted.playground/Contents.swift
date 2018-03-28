//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

///////////////////////////////////////////////////////////////////////////////
/// Delay
/// 将 Observable 的每个元素延迟一段时间后执行
Observable.of("🐶", "🐱", "🐭", "🐹")
    .delay(1, scheduler: MainScheduler.instance)
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)


///////////////////////////////////////////////////////////////////////////////
/// Do
/// 当 Observable 产生某些事件时 执行某个操作
Observable<String>.of("🐶", "🐱", "🐭", "🐹").do()
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)


///////////////////////////////////////////////////////////////////////////////
/// Materialize/ Dematerialize
/// 将序列产出的事件 转换成元素

Observable.of(1, 2, 1)
    .materialize()
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)


Observable.of(1, 2, 1)
    .materialize()
    .dematerialize()
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

///////////////////////////////////////////////////////////////////////////////
/// Serialize
/// 强制一个 Observable 连续调用并保证行为正确


///////////////////////////////////////////////////////////////////////////////
/// TimerInterval
///


///////////////////////////////////////////////////////////////////////////////
/// TimeStamp
///


///////////////////////////////////////////////////////////////////////////////
/// TimeOut
/// 使用该操作符可以设置一个超时时间。如果源 Observable 在规定时间内没有发任何出元素，就产生一个超时的 error 事件

//定义好每个事件里的值以及发送的时间
let times = [
    [ "value": 1, "time": 0 ],
    [ "value": 2, "time": 0.5 ],
    [ "value": 3, "time": 1.5 ],
    [ "value": 4, "time": 4 ],
    [ "value": 5, "time": 5 ]
]

//生成对应的 Observable 序列并订阅
Observable.from(times)
    .flatMap { item in
        return Observable.of(Int(item["value"]!))
            .delaySubscription(Double(item["time"]!),
                               scheduler: MainScheduler.instance)
    }
    .timeout(2, scheduler: MainScheduler.instance) //超过两秒没发出元素，则产生error事件
    .subscribe(onNext: { element in
        print(element)
    }, onError: { error in
        print(error)
    })
    .disposed(by: disposeBag)


///////////////////////////////////////////////////////////////////////////////
/// Using
/// 使用 using 操作符创建 Observable 时，同时会创建一个可被清除的资源，一旦 Observable 终止了，那么这个资源就会被清除掉了。




///////////////////////////////////////////////////////////////////////////////
/// ToArray
/// 将 Observable 转换为另一个对象或数据结构
Observable<String>.of("🐶", "🐱", "🐭", "🐹").toArray().subscribe(onNext: { element in
    print(element)
}).disposed(by: disposeBag)
/*
 ["🐶", "🐱", "🐭", "🐹"]
 */
