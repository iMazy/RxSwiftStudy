//: A UIKit based Playground for presenting user interface
  
import RxSwift

let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
interval.subscribe ({ event in
    print(event.element)
    print("888")
})
