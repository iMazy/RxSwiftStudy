//
//  RxMVVMLoginViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/20.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxMVVMLoginViewController: BaseViewController {
    
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var usernameValidation: UILabel!
    @IBOutlet weak var passwordValidation: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = LoginViewModel(input: (username: usernameField.rx.text.orEmpty.asObservable(), password: passwordField.rx.text.orEmpty.asObservable(), loginTap: loginButton.rx.tap.asObservable()))
        
        loginButton.rx.tap.asObservable().bind(to: viewModel.loginTap).disposed(by: disposeBag)
        
        viewModel.validationUsername.bind(to: usernameValidation.rx.validationResult).disposed(by: disposeBag)
        
        viewModel.validationPassword.bind(to: passwordValidation.rx.validationResult).disposed(by: disposeBag)
        
        viewModel.loginEnable.subscribe(onNext: { [unowned self] valid in
            self.loginButton.isEnabled = valid
            self.loginButton.alpha = valid ? 1.0 : 0.5
        }).disposed(by: disposeBag)
        
        viewModel.logined.subscribe(onNext: { logined in
            print("User login is \(logined)")
        }).disposed(by: disposeBag)
        
        let tapBackground = UITapGestureRecognizer()
        tapBackground.rx.event.subscribe(onNext: { [unowned self] _ in
            self.view.endEditing(true)
        }).disposed(by: disposeBag)
        
        view.addGestureRecognizer(tapBackground)
        
        usernameField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [unowned self] in
            self.usernameField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        passwordField.rx.controlEvent(.editingDidEnd).subscribe(onNext: { [unowned self] in
            self.passwordField.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        loginButton.rx.controlEvent(.editingDidEndOnExit).bind(to: viewModel.loginTap).disposed(by: disposeBag)
    }

}
