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
        timer.map({
            let name = $0 % 2 == 0 ? "back" : "forward"
            return UIImage(named: name)!
        }).bind(to: button.rx.image())
            .disposed(by: disposeBag)
        
        /// 设置背景图片
        timer.map({
            let name = $0 % 2 == 0 ? "back" : "forward"
            return UIImage(named: name)!
        }).bind(to: button.rx.backgroundImage())
            .disposed(by: disposeBag)
        
        /// 按钮是否被选中
        
    }
    
    func attributeStringWith(ms: Int) -> NSMutableAttributedString {
        let attrbute = NSMutableAttributedString(string: "hello world! \(ms)")
        attrbute.addAttribute(.backgroundColor, value: UIColor.orange, range: NSMakeRange(0, 5))
        return attrbute
    }

}
