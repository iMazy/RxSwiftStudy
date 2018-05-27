//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

///////////////////////////////////////////////////////////////////////////////
/// Contains
///
Observable.of("🐶", "🐱", "🐭", "🐹").subscribe(onNext: {
    print($0.contains("🐭"))
}).disposed(by: disposeBag)



///////////////////////////////////////////////////////////////////////////////
/// Amb
/// 当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables。

let subject1 = PublishSubject<Int>()
let subject2 = PublishSubject<Int>()
let subject3 = PublishSubject<Int>()

subject1
    .amb(subject2)
    .amb(subject3)
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

subject2.onNext(1)
subject1.onNext(20)
subject2.onNext(2)
subject1.onNext(40)
subject3.onNext(0)
subject2.onNext(3)
subject1.onNext(60)
subject3.onNext(0)
subject3.onNext(0)


///////////////////////////////////////////////////////////////////////////////
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


///////////////////////////////////////////////////////////////////////////////
/// SkipWhile
/// 跳过 Observable 中的头几个元素, 直到元素的判定为否

Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").skipWhile({ $0 != "🐵" })
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


///////////////////////////////////////////////////////////////////////////////
/// TakeUntil
/// 忽略掉第二个 Observable 产生事件后发出的那部分元素
print("-----")
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").takeUntil(end)
    .subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)


///////////////////////////////////////////////////////////////////////////////
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
