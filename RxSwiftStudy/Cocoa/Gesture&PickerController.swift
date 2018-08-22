//
//  Gesture&PickerController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/5.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxGesture

class Gesture_PickerController: BaseViewController {
    
    var tapView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tapView = UIView()
        view.backgroundColor = .red
        tapView.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        view.addSubview(tapView)
        
        
        // tap
        tapView.rx.tapGesture().when(.recognized)
            .subscribe(onNext: { _ in
            print("Tapped!!!")
        }).disposed(by: disposeBag)
        
        // double tap
        tapView.rx.tapGesture(numberOfTapsRequired: 2).when(.recognized)
            .subscribe(onNext: { _ in
            print("double tapped!!!")
        }).disposed(by: disposeBag)
        
        // swipe down
        tapView.rx.swipeGesture(.down).when(.recognized)
            .subscribe(onNext: { _ in
            print("Swipe down")
        }).disposed(by: disposeBag)
        
        // swipe horizontal
        tapView.rx.swipeGesture([.left, .right])
            .subscribe(onNext: { _ in
            print("Swipe horizontal")
        }).disposed(by: disposeBag)
        
        // long press
        tapView.rx.longPressGesture().when(.began)
            .subscribe(onNext: { _ in
            print("long press")
        }).disposed(by: disposeBag)
        
        // pan gesture
        let panGesture = tapView.rx.panGesture().share(replay: 1)
        
        panGesture.when(.changed).asTranslation()
            .subscribe(onNext: { [unowned self] translation, _ in
            self.tapView.transform = CGAffineTransform(translationX: translation.x, y: translation.y)
        }).disposed(by: disposeBag)
        
        panGesture.when(.ended).subscribe(onNext: { _ in
            print("pan gesture end")
        }).disposed(by: disposeBag)
        
        // rotation gesture
        let rotationGesture = tapView.rx.rotationGesture().share(replay: 1)
        
        rotationGesture.when(.changed).asRotation()
            .subscribe(onNext: { [unowned self] rotation, _ in
            self.tapView.transform = CGAffineTransform(rotationAngle: rotation)
        }).disposed(by: disposeBag)
        
        rotationGesture.when(.ended)
            .subscribe(onNext: { _ in
            print("rotation gesture end")
        }).disposed(by: disposeBag)
        
        // 缩放 pinch
        let pinchGesture = tapView.rx.pinchGesture().share(replay: 1)
        
        pinchGesture.when(.changed)
            .asScale()
            .subscribe(onNext: { [unowned self] scale, _ in
            self.tapView.transform = CGAffineTransform(scaleX: scale, y: scale)
        }).disposed(by: disposeBag)
        
        pinchGesture.when(.ended)
            .subscribe(onNext: { _ in
                print("pinch end")
            }).disposed(by: disposeBag)
        
        view.rx.screenEdgePanGesture(edges: .right)
            .when(.recognized)
            .subscribe(onNext: { _ in
            print("rigjt edge")
        }).disposed(by: disposeBag)
        
        tapView.rx.anyGesture(.tap(), .swipe([.up, .right]))
            .when(.recognized)
            .subscribe(onNext: { _ in
            print("tap or up down")
        }).disposed(by: disposeBag)
        
        gestureEvent()
        
    }

    func gestureEvent() {
        
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event.subscribe(onNext: { _ in
            print("tapped")
        }).disposed(by: disposeBag)
        
        tapGesture.rx.event.bind { _ in
            print("tapped")
        }.disposed(by: disposeBag)
        
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
