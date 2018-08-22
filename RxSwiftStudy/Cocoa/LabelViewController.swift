//
//  LabelViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/3/31.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LabelViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        bindTextToLabel()
    }
    
    /// 将数据绑定到 text 属性上（普通文本）
    func bindTextToLabel() {
        // 创建文本标签
        let label = UILabel(frame: CGRect(x: 100, y: 100, width: 300, height: 100))
        view.addSubview(label)
        
        Observable.just("hello").bind(to: label.rx.text).disposed(by: disposeBag)
        
        // 创建一个计时器（每0.1秒发送一个索引数）
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        
        timer.map { String(format: "%0.2d:%0.2d.%0.2d",
                           arguments: [($0 / 600) % 600, ($0 % 600) / 10, $0 % 10])}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
}
