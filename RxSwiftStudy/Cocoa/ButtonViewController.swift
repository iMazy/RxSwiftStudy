//
//  ButtonViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/3/31.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ButtonViewController: BaseViewController {

    var button = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        button.frame = CGRect(x: 20, y: 100, width: 200, height: 30)
        button.setTitle("click me!", for: .normal)
        button.setTitleColor(.red, for: .normal)
        view.addSubview(button)
        
        /// 按钮点击事件的绑定
        button.rx.tap.subscribe(onNext: {
            print("我被点击了")
        }).disposed(by: disposeBag)
        
        /// 另一种写法
        button.rx.tap.bind {
            print("我也被点击了")
        }.disposed(by: disposeBag)
        
        /// 按钮title 的绑定
        let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer.map({ "计数\($0)" })
            .bind(to: button.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        /// 属性文本的绑定
        let timer1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        timer1.map(attributeStringWith)
            .bind(to: button.rx.attributedTitle())
            .disposed(by: disposeBag)
        
        /// 按钮图标的绑定
//        timer.map({
//            let name = $0 % 2 == 0 ? "back" : "forward"
//            return UIImage(named: name)!
//        }).bind(to: button.rx.image())
//            .disposed(by: disposeBag)
        
        /// 设置背景图片
//        timer.map({
//            let name = $0 % 2 == 0 ? "back" : "forward"
//            return UIImage(named: name)!
//        }).bind(to: button.rx.backgroundImage())
//            .disposed(by: disposeBag)
        
        /// 按钮是否可用(isEnabled)
        let switch1 = UISwitch()
        switch1.rx.isOn.bind(to: button.rx.isEnabled).disposed(by: disposeBag)
        
        multipleButton()
    }
    
    func multipleButton() {
        
        let button1 = UIButton(type: .system)
        button1.frame = CGRect(x: 20, y: 200, width: 200, height: 30)
        button1.setTitle("按钮1", for: .normal)
        button1.setTitleColor(.red, for: .normal)
        view.addSubview(button1)
        
        let button2 = UIButton(type: .system)
        button2.frame = CGRect(x: 20, y: 250, width: 200, height: 30)
        button2.setTitle("按钮2", for: .normal)
        button2.setTitleColor(.red, for: .normal)
        view.addSubview(button2)
        
        let button3 = UIButton(type: .system)
        button3.frame = CGRect(x: 20, y: 300, width: 200, height: 30)
        button3.setTitle("按钮3", for: .normal)
        button3.setTitleColor(.red, for: .normal)
        view.addSubview(button3)
        
        button1.isSelected = true
        
        let buttons = [button1, button2, button3]
        
        //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
        let selectedButton = Observable.from(
                buttons.map { button in
                    button.rx.tap.map {
                        button
                    }
                }
            ).merge()
        
//        let selectedButton1 = Observable.from( buttons.map({ button in
//            button.rx.tap.map{ button }
//        }))
        
        for btn in buttons {
            selectedButton.map({ $0 == btn }).bind(to: btn.rx.isSelected).disposed(by: disposeBag)
        }
    }
    
    func attributeStringWith(ms: Int) -> NSMutableAttributedString {
        let attrbute = NSMutableAttributedString(string: "hello world! \(ms)")
        attrbute.addAttribute(.backgroundColor, value: UIColor.orange, range: NSMakeRange(0, 5))
        return attrbute
    }

}
