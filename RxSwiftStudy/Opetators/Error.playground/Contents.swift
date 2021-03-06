//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

let disposeBag = DisposeBag()

class HHError: Error {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

///////////////////////////////////////////////////////////////////////////////
/// CatchError
/// 从一个错误事件中恢复，将错误事件替换成一个备选序列

let sequenceThatFails = PublishSubject<String>()
let recoverySequence = PublishSubject<String>()

sequenceThatFails.catchError { (error) -> Observable<String> in
        print("error: ", error)
        return recoverySequence
    }.subscribe(onNext: {
        print($0)
    }).disposed(by: disposeBag)

sequenceThatFails.onNext("😬")
sequenceThatFails.onNext("😨")
sequenceThatFails.onNext("😡")
sequenceThatFails.onNext("🔴")
sequenceThatFails.onError(HHError(name: "test"))
recoverySequence.onNext("😊")
recoverySequence.onNext("😊")

/*
 😬
 😨
 😡
 🔴
 error:  __lldb_expr_144.HHError
 😊
 😊
 */

print("-------")
/// catchErrorJustReturn
/// 会将error 事件替换成其他的一个元素，然后结束该序列。
sequenceThatFails.catchErrorJustReturn("😊😊😊")
    .subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

sequenceThatFails.onNext("😬")
sequenceThatFails.onNext("😨")
sequenceThatFails.onNext("😡")
sequenceThatFails.onNext("🔴")
sequenceThatFails.onError(HHError(name: "test"))

/*
 😊😊😊
 */

print("---Retry---")
///////////////////////////////////////////////////////////////////////////////
/// Retry
/// 如果源 Observable 产生一个错误事件，重新对它进行订阅，希望它不会再次产生错误

var count = 1
let canErrorSequence = Observable<String>.create { (observer) -> Disposable in
    observer.onNext("🍎")
    observer.onNext("🍐")
    observer.onNext("🍊")
    
    if count == 1 {
        observer.onError(HHError.init(name: "text"))
        print("Error encountered")
        count += 1
    }
    
    observer.onNext("🐶")
    observer.onNext("🐱")
    observer.onNext("🐭")
    observer.onCompleted()

    return Disposables.create()
    
}

canErrorSequence.retry().subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

/*
 🍎
 🍐
 🍊
 Error encountered
 🍎
 🍐
 🍊
 🐶
 🐱
 🐭
 */

print("---Debug---")
///////////////////////////////////////////////////////////////////////////////
/// Debug
/// 将 debug 调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发调试。
/// debug() 不传参数 打印当前方法名
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").debug().subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)

/// debug() 传参数 打印参数名
Observable.of("🐱", "🐷", "🐱", "🐱", "🐱", "🐵", "🐱").debug("调试:").subscribe(onNext: {
    print($0)
}).disposed(by: disposeBag)



