//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()


///////////////////////////////////////////////////////////////////////////////
/// CombineLatest
/// 当多个 Observables 中任何一个发出一个元素，就发出一个元素。这个元素是由这些 Observables 中最新的元素，通过一个函数组合起来的
let first = PublishSubject<String>()
let second = PublishSubject<String>()

Observable.combineLatest(first, second) { $0 + $1 }
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

first.onNext("1")
second.onNext("A")
second.onNext("B")
first.onNext("2")
second.onNext("C")
second.onNext("D")
second.onNext("E")
first.onNext("3")
first.onNext("4")

/*
 1A
 1B
 2B
 2C
 2D
 2E
 3E
 4E
 */

///////////////////////////////////////////////////////////////////////////////
/// Merge
/// 将多个 Observables 合并成一个
let intSubject = PublishSubject<String>()
let strSubject = PublishSubject<String>()

Observable.of(intSubject,  strSubject)
    .merge()
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)


intSubject.onNext("1")
strSubject.onNext("A")
strSubject.onNext("B")
intSubject.onNext("2")
strSubject.onNext("C")
strSubject.onNext("D")
strSubject.onNext("E")
intSubject.onNext("3")
intSubject.onNext("4")

/*
 1
 A
 B
 2
 C
 D
 E
 3
 4
 */

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
    }).disposed(by: disposeBag)

/*
 4
 A
 B
 3
 2
 1
 🐶
 🐱
 🐭
 🐹
 */


///////////////////////////////////////////////////////////////////////////////
/// Zip
/// 通过一个函数将多个 Observables 的元素组合起来，然后将每一个组合的结果发出来
print("0--------0")

Observable.zip(first, second) { $0 + $1 }.subscribe(onNext: { element in
    print(element)
}).disposed(by: disposeBag)

first.onNext("1")
second.onNext("A")
first.onNext("2")
second.onNext("B")
second.onNext("C")
second.onNext("D")
first.onNext("3")
first.onNext("4")


/*
 1A
 2A
 2B
 2B
 2C
 2D
 3D
 3C
 4D
 4D
 */
