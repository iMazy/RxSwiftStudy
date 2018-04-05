//
//  Gesture&PickerController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/5.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit

class Gesture_PickerController: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        gestureEvent()
        
    }

    func gestureEvent() {
        // 添加一个上滑的手势
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        // 方式一
        swipe.rx.event.subscribe(onNext: { [weak self] recognizer in
            let point = recognizer.location(in: self?.view)
            print("向上滑动 \(point.x) - \(point.y)")
        }).disposed(by: disposeBag)
        
        // 方式二
        swipe.direction = .down
        swipe.rx.event.bind { [weak self] recognizer in
            let point = recognizer.location(in: self?.view)
            print("向下滑动 \(point.x) - \(point.y)")
        }.disposed(by: disposeBag)
    }

}
