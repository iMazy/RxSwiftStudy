//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
///////////////////////////////////////////////////////////////////////////////
/// Buffer
/// 缓存元素，然后将缓存的元素集合，周期性的发出来
let bufferID = Observable<Int>.create { (observer) -> Disposable in
    observer.onNext(1)
    observer.onNext(2)
    observer.onNext(3)
    observer.onNext(4)
    observer.onNext(5)
    observer.onNext(6)
    observer.onNext(7)
    observer.onCompleted()
    return Disposables.create()
}

bufferID.buffer(timeSpan: 0, count: 3, scheduler: MainScheduler.instance)
    .subscribe(onNext: { (nums) in
    print(nums)
}).disposed(by: disposeBag)

/*
 [1, 2, 3]
 [4, 5, 6]
 [7]
 */

///////////////////////////////////////////////////////////////////////////////
/// Map
/// 通过一个转换函数,将 Observable 的每个元素转换一遍

Observable.of(1, 3, 5, 7, 9)
    .map({ $0 * 10 })
    .subscribe(onNext: { value in
    print(value)
}).disposed(by: disposeBag)

/*
 10
 30
 50
 70
 90
 */


///////////////////////////////////////////////////////////////////////////////
/// concatMap
/// 它类似于最简单版本的flatMap，但是它按次序连接而不是合并那些生成的Observables，然后产生自己的数据序列

//Observable.of(1, 3, 5, 7, 9).concatMap({ return $0 })
//    .subscribe(onNext: { value in
//        print(value)
//    }).disposed(by: disposeBag)

/*
 10
 30
 50
 70
 90
 */

///////////////////////////////////////////////////////////////////////////////
/// FlatMap
/// 将 Observable 的元素转换成其他的 Observable, 然后将这些 Observable 合并
let first = BehaviorSubject(value: "👦🏻")
let second = BehaviorSubject(value: "🅰️")
let variable = Variable(first)

variable.asObservable()
    .flatMap({ $0 })
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

first.onNext("🐱")
variable.value = second

second.onNext("🅱️")
first.onNext("🐶")
/*
 👦🏻
 🐱
 🅰️
 🅱️
 🐶
 */

///////////////////////////////////////////////////////////////////////////////
/// GroupBy
/// 将源 Observable 分解为多个子 Observable，并且每个子 Observable 将源 Observable 中“相似”的元素发送出来
Observable<Int>.of(1, 3, 5, 29, 55, 7, 88, 9).groupBy(keySelector: { (num) -> Bool in
    return num > 10
}).subscribe({ (event) in
    switch event {
    case .next(let group):
        group.asObservable().subscribe({ event in
            print("key: \(group.key)  event: \(event)")
        }).disposed(by: disposeBag)
    default:
        break
    }
}).disposed(by: disposeBag)

//将奇数偶数分成两组
Observable<Int>.of(0, 1, 2, 3, 4, 5)
    .groupBy(keySelector: { (element) -> String in
        return element % 2 == 0 ? "偶数" : "基数"
    })
    .subscribe { (event) in
        switch event {
        case .next(let group):
            group.asObservable().subscribe({ (event) in
                print("key：\(group.key)    event：\(event)")
            }).disposed(by: disposeBag)
        default:
            print("")
        }
    }.disposed(by: disposeBag)

///////////////////////////////////////////////////////////////////////////////
/// Scan
/// 持续的将 Observable 的每一个元素应用一个函数，然后发出每一次函数返回的结果
Observable<Int>.of(0, 1, 2, 3, 4, 5).scan(0) { (aggregateValue, newValue) in
    aggregateValue + newValue
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)
/*
 0
 1
 3
 6
 10
 15
 */

///////////////////////////////////////////////////////////////////////////////
/// Window
/// 将 Observable 分解为多个子 Observable，周期性的将子 Observable 发出来
Observable<Int>.of(0, 1, 2, 3, 4, 5).window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance).asObservable().subscribe(onNext: { (observable) in
    observable.subscribe(onNext: { value in
        print(value)
    }).disposed(by: disposeBag)
}, onCompleted: {
    print("completed")
}, onDisposed: {
    print("disposed")
}).disposed(by: disposeBag)



