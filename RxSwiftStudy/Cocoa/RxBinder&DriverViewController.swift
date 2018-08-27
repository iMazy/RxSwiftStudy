//
//  RxBinder&DriverViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/27.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxBinder_DriverViewController: BaseViewController {

    var label = UILabel()
    var label2 = UILabel()
    
    let refreshButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        label.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        view.addSubview(label)
        
        label2.frame = CGRect(x: 100, y: 200, width: 200, height: 30)
        view.addSubview(label2)
        
        refreshButton.setTitle("Refresh", for: .normal)
        refreshButton.setTitleColor(.red, for: .normal)
        refreshButton.frame = CGRect(x: 100, y: 300, width: 200, height: 30)
        view.addSubview(refreshButton)
        
        Observable.of("Hello RxSwift").bind(to: label.rx.text).disposed(by: disposeBag)
        
//        Observable.of("Hello RxSwift").asDriver(onErrorJustReturn: "").drive(label2.rx.text).disposed(by: disposeBag)
        
        let variable = Variable("你好 RxSwift")
        variable.asDriver().drive(label2.rx.text).disposed(by: disposeBag)
        
//        JSONSerialization
        func getCurrentTime() -> String {
            print("getCurrentTime")
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            return formatter.string(from: Date())
        }
        
        let time = refreshButton.rx.tap.map(getCurrentTime).share(replay: 1)
        
        time.bind(to: label.rx.text).disposed(by: disposeBag)
        time.bind(to: label2.rx.text).disposed(by: disposeBag)
//        time.drive(label.rx.text).disposed(by: disposeBag)
//        time.drive(label2.rx.text).disposed(by: disposeBag)
        
    }

}
