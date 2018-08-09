//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()
///////////////////////////////////////////////////////////////////////////////
/// Debounce
/// 过滤掉高频产生的元素
Observable.range(start: 0, count: 10).debounce(0.1, scheduler: MainScheduler.instance).subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)




//定义好每个事件里的值以及发送的时间
let times = [
    [ "value": 1, "time": 0.1 ],
    [ "value": 2, "time": 1.1 ],
    [ "value": 3, "time": 1.2 ],
    [ "value": 4, "time": 1.2 ],
    [ "value": 5, "time": 1.4 ],
    [ "value": 6, "time": 2.1 ]
]

//生成对应的 Observable 序列并订阅
Observable.from(times)
    .flatMap { item in
        return Observable.of(Int(item["value"]!))
            .delaySubscription(Double(item["time"]!),
                               scheduler: MainScheduler.instance)
    }
    .debounce(0.5, scheduler: MainScheduler.instance) //只发出与下一个间隔超过0.5秒的元素
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)


///////////////////////////////////////////////////////////////////////////////
/// Distinct
/// 过滤掉(抑制)重复的元素
/// DistinctUntilChanged
/// 阻止 Observable 发出相同的元素
Observable<Int>.of(1, 3, 5, 6, 6, 6, 8, 7, 8, 8, 8, 9).distinctUntilChanged().subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

/*
 1
 3
 5
 6
 8
 7
 8
 9
 */


///////////////////////////////////////////////////////////////////////////////
/// ElementAt
/// 支发出 Observable 中的第 n 个元素
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
    .elementAt(1)
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

/*
 🐷
 */

///////////////////////////////////////////////////////////////////////////////
/// Filter
/// 只发射通过了微词判断的元素
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
    .filter({ $0 == "🐱" })
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

/*
 🐱
 🐱
 🐱
 🐱
 🐱
 */


///////////////////////////////////////////////////////////////////////////////
/// IgnoreElements
/// 忽略掉所有的元素, 只发出 error 或 completed 事件
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").ignoreElements().subscribe(onCompleted: {
    print("conpleted")
}) { (error) in
    print(error)
}.disposed(by: disposeBag)


///////////////////////////////////////////////////////////////////////////////
/// Sample
/// 不定期的对 Observable 取样
let source = PublishSubject<Int>()
let notify = PublishSubject<String>()

source.sample(notify).subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)
source.onNext(1)

notify.onNext("A")

source.onNext(2)

notify.onNext("B")
notify.onNext("C")

source.onNext(3)
source.onNext(4)

notify.onNext("D")

source.onNext(5)

notify.onCompleted()

/*
 1
 2
 4
 5
 */

///////////////////////////////////////////////////////////////////////////////
/// Skip
/// 跳过 Observable 的前 n 个元素
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱")
    .skip(3)
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)


print("---------------")
/// SkipUntil
/// 跳过 Observable 中的头几个元素, 直到另一个 Observable 发出一个元素
let begin = BehaviorSubject(value: 0)
let end = BehaviorSubject(value: 0)
begin.skipUntil(end)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

begin.onNext(1)
begin.onNext(2)
begin.onNext(3)

end.onNext(4)

begin.onNext(4)

end.onNext(4)

begin.onNext(5)




print("-----")
/// SkipWhile
/// 跳过 Observable 中的头几个元素, 直到元素的判定为否

Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").skipWhile({ $0 != "🐵" })
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)


/*
 🐵
 🐱
 */

///////////////////////////////////////////////////////////////////////////////
/// Take
/// 仅仅从 Observable 中发出头 n 个的元素
print("-----")
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").take(3)
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

/*
 🐱
 🐷
 🐱
 */

/// TakeLast
/// 仅仅从 Observable 中发出尾部 n 个的元素
print("-----")
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").takeLast(3)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

/*
 🐱
 🐵
 🐱
 */



/// TakeUntil
/// 忽略掉第二个 Observable 产生事件后发出的那部分元素
print("-----")
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").takeUntil(end)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


/// TakeWhile
/// 镜像一个 Observable 直到某个元素的判定为 false
print("-----")
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").takeWhile({ $0 == "🐱" })
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

/*
🐱
 */
