//
//  BidirectionalBindingsController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/5.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class BidirectionalBindingsController: BaseViewController {
    
    @IBOutlet weak var textFiled: UITextField!
    
    @IBOutlet weak var userLabel: UILabel!
    
    var userVM = UserViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 将输入的数据 与 ViewModel 绑定
        /*
        userVM.username.asObservable().bind(to: textFiled.rx.text).disposed(by: disposeBag)
        textFiled.rx.text.orEmpty.bind(to: userVM.username).disposed(by: disposeBag)
        */
        
        // 方式2 使用 Operators
        _ = textFiled.rx.textInput <-> userVM.username
        
        // 将用户信息绑定到 label 上
        userVM.userinfo.bind(to: userLabel.rx.text).disposed(by: disposeBag)
    }

    @IBAction func resetAction() {
        userVM.username.value = "123456"
    }
   
}

struct UserViewModel {
    
    var username = Variable("")
    
    lazy var userinfo = {
        return self.username
            .asObservable()
            .map{ $0 == "123456" ? "密码正确" : "密码错误" }
            .share(replay: 1)
    }()
    
}











