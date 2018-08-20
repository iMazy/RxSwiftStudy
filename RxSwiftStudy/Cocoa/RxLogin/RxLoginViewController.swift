//
//  RxLoginViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/9.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxLoginViewController: BaseViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameValidLabel: UILabel!
    @IBOutlet weak var passwordValidLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginTipLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 验证用户名输入是否有效
        let usernameIsValid: Observable<Bool> = usernameField.rx.text.orEmpty.map { newUsername in newUsername.count > 5 }
        // 验证密码输入是否有效
        let passwordIsValid: Observable<Bool> = passwordField.rx.text.orEmpty.map { newPassword in newPassword.count > 5 }
        // 绑定
        usernameIsValid.bind(to: usernameValidLabel.rx.isHidden).disposed(by: disposeBag)
        passwordIsValid.bind(to: passwordValidLabel.rx.isHidden).disposed(by: disposeBag)
        
        // 验证是否满足登录条件
        let isLoginEnable: Observable<Bool> = Observable.combineLatest(usernameIsValid, passwordIsValid) { $0 && $1 }
        
        isLoginEnable.bind(to: loginButton.rx.isEnabled).disposed(by: disposeBag)
        
        // 发起登录操作
        let  usernameAndPassword: Observable<(String, String)> = Observable.combineLatest(usernameField.rx.text.orEmpty, passwordField.rx.text.orEmpty)
        
        let rxUser: Observable<User?> = loginButton.rx.tap.withLatestFrom(usernameAndPassword).do(onNext: { [weak self] _ in
            self?.loginTipLabel.text = "正在登录, 请稍等..."
            self?.view.endEditing(true)
        }).flatMapLatest(GithubApi.login)
        
        rxUser.observeOn(MainScheduler.instance).map({ user in
            user == nil ? "登录失败, 请稍后再试" : "\(user?.nickname ?? "") 您已成功登录"
        }).bind(to: loginTipLabel.rx.text).disposed(by: disposeBag)
    }
}

enum GithubApi {
    public static func login(username: String, password: String) -> Observable<User?> {
        guard let baseURL = URL(string: "https://api.github.com"), let url = URL(string: "login?username=\(username)&password=\(password)", relativeTo: baseURL) else { return Observable.just(nil) }
        return URLSession.shared.rx.json(url: url).catchErrorJustReturn(["id": "10000", "nickname": "mazy"]).map(User.init)
    }
}


struct User {
    let id: String
    let nickname: String
    
    init?(json: Any) {
        guard let dict = json as? [String: Any], let id = dict["id"] as? String, let nickname = dict["nickname"] as? String else { return nil }
        self.id = id
        self.nickname = nickname
    }
    
}
