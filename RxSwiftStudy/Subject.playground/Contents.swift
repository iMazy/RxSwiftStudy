//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

///////////////////////////////////////////////////////////////////////////////
/// Subject
/// 即是可被监听的序列,也是观察者
/// eg: UITextField / UISwith / UIDatePicker ...


/// Subject 分类
/// - AsyncSubject: 发射来自原始 Observable 的最后一个值, (如果有error, 只发送error, 否则发射完成事件)
/// - PublishSubject: 发射订阅时间点后的所有数据
/// - ReplaySubject: 无论何时订阅, 通过设置 bufferSize, 向前发射出 bufferSize 大小的 元素
/// - BehaviorSubject: 先发射订阅时间点前一个数据, 如果没有,发射默认值, 再发射后续的所有值


///////////////////////////////////////////////////////////////////////////////
/// AsyncSubject
/// - AsyncSubject: 发射来自原始 Observable 的最后一个值, (如果有error, 只发送error, 否则发射完成事件)
print("--------------------------AsyncSubject--------------------------------")
let disposeBag = DisposeBag()
let asyncSubject = AsyncSubject<String>()
asyncSubject
    .subscribe { print("subscription: 1 Event:", $0) }
    .disposed(by: disposeBag)

asyncSubject.onNext("🐶")
asyncSubject.onNext("🐱")
asyncSubject.onNext("🐹")
asyncSubject.onCompleted() // 注销这个 打印 error
/// 输出最后一个元素 并输出 completed event

enum SwiftError: Error {
    case error_ome
    case error_two
    case error_three
}
asyncSubject.onNext("🌹")
asyncSubject.onError(SwiftError.error_ome) /// 只会打印 error, 不会输出最后一个元素

///////////////////////////////////////////////////////////////////////////////
/// PublishSubject
/// - PublishSubject: 发射订阅时间点后的所有数据
print("--------------------------PublishSubject--------------------------------")
let publishSubject = PublishSubject<String>()
publishSubject
    .subscribe { print("Subscription: 1 Event: ", $0) }
    .disposed(by: disposeBag)

publishSubject.onNext("🐶")
publishSubject.onNext("🐱")

publishSubject
    .subscribe { print("Subscription: 2 Event: ", $0) }
    .disposed(by: disposeBag)

publishSubject.onNext("🅰️")
publishSubject.onNext("🅱️")



///////////////////////////////////////////////////////////////////////////////
/// ReplaySubject
/// - ReplaySubject: 无论何时订阅, 通过设置 bufferSize, 向前发射出 bufferSize 大小的 元素
print("--------------------------ReplaySubject--------------------------------")
let replaySubject = ReplaySubject<String>.create(bufferSize: 10)
replaySubject
    .subscribe { print("Subscription: 1 Event: ", $0) }
    .disposed(by: disposeBag)

replaySubject.onNext("🐶")
replaySubject.onNext("🐱")

replaySubject
    .subscribe { print("Subscription: 2 Event: ", $0) }
    .disposed(by: disposeBag)

replaySubject.onNext("🅰️")
replaySubject.onNext("🅱️")


///////////////////////////////////////////////////////////////////////////////
/// BehaviorSubject
/// - BehaviorSubject: 先发射订阅时间点前一个数据, 如果没有,发射默认值, 再发射后续的所有值
print("--------------------------BehaviorSubject--------------------------------")

let behaviorSubject = BehaviorSubject<String>(value: "🔴")
behaviorSubject
    .subscribe {  print("Subscription: 1 Event: ", $0) }
    .disposed(by: disposeBag)

behaviorSubject.onNext("🐶")
behaviorSubject.onNext("🐱")

behaviorSubject
    .subscribe { print("Subscription: 2 Event: ", $0) }
    .disposed(by: disposeBag)

behaviorSubject.onNext("🅰️")
behaviorSubject.onNext("🅱️")

behaviorSubject
    .subscribe { print("Subscription: 3 Event: ", $0) }
    .disposed(by: disposeBag)

behaviorSubject.onNext("🍐")
behaviorSubject.onNext("🍊")

