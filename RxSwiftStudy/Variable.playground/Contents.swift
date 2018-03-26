//: A UIKit based Playground for presenting user interface
  
import RxSwift
import RxCocoa

///////////////////////////////////////////////////////////////////////////////
/// Variable
/// - Variable: 是swift var 的 Rx 版, 来声明变量
/// - 通过调用 asObservable() 方法转换成序列
/// - Variable 封装了一个 BehaviorSubject，所以它会持有当前值，并且 Variable 会对新的观察者发送当前值。它不会产生 error 事件。Variable 在 deinit 时，会发出一个 completed 事件。

let disposeBag = DisposeBag()

struct Model {
    var name: String?
}

// 在 ViewController 中
let model: Variable<Model?> = Variable(nil)

/// ...
model.asObservable().subscribe(onNext: { model in
    //updateUI(with: model)
}).disposed(by: disposeBag)

//model.value = getModel()

func updateUI(with model: Model?) {
    /// ...
}

func getModel() -> Model {
    // ...
    return Model()
}

