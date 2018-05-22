//: A UIKit based Playground for presenting user interface
  
import UIKit
import RxSwift
import RxCocoa

///////////////////////////////////////////////////////////////////////////////
/// Observer
/// 观察者
/// 监听事件, 对事件作出响应

/// 创建观察者最直接的方法就是在 observable 的 subscribe 方法后面描述, 事件发生时, 作出响应.
/// 观察者就是由后面的 onNext, onError, onCompleted 的这些闭包构建出来的

let button = UIButton()
button.rx.tap.subscribe(onNext: {
    /// observer do
}, onError: { (error) in
    print("error \(error.localizedDescription)")
}, onCompleted: {
    print("mission finished")
})


///////////////////////////////////////////////////////////////////////////////
/// AnyObserver
/// 用于描述任意一种观察者

/// eg:
let disposeBag = DisposeBag()
URLSession.shared.rx.data(request: URLRequest(url: URL(string: "www.baidu.com")!)).subscribe(onNext: { (data) in
    print("Data Task Success with count: \(data.count)")
}, onError: { (error) in
    print("Data Task Error: \(error)")
}).disposed(by: disposeBag)

/// 等价于如下
/// ===========
let observer: AnyObserver<Data> = AnyObserver { event in
    switch event {
    case .next(let data):
        print("Data Task Success with count: \(data.count)")
    case .error(let error):
        print("Data Task Error: \(error)")
    default:
        break
    }
}

URLSession.shared.rx.data(request: URLRequest(url: URL(string: "www.baidu.com")!))
    .subscribe(observer)
    .disposed(by: disposeBag)



///////////////////////////////////////////////////////////////////////////////
/// Binder
/// 不会处理事件
/// 默认在主线程执行 (MainSchedular)

/// 通过 Binder 创建自定义的 UI 观察者

let usernameLabel = UILabel()
let observer1: Binder<Bool> = Binder(usernameLabel) { (view, isHidden) in
    view.isHidden = isHidden
}

/// 复用
extension Reactive where Base: UIView {
    public var isHidden: Binder<Bool> {
        return Binder(self.base) { (view, hidden) in
            view.isHidden = hidden
        }
    }
}

/// 按钮是否可点击 button.rx.isEnabled:
extension Reactive where Base: UIControl {
    public var isEnabled: Binder<Bool> {
        return Binder(self.base) { control, value in
            control.isEnabled = value
        }
    }
}

/// label 的当前文本 label.rx.text

extension Reactive where Base: UILabel {
    public var text: Binder<String?> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }
}


