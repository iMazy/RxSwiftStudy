//
//  LoginViewModel.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/20.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import RxSwift

class LoginViewModel {
    
    let validationUsername: Observable<ValidationResult>
    let validationPassword: Observable<ValidationResult>
    
    let loginEnable: Observable<Bool>
    let logined: Observable<Bool>
//    let logining: Observable<Bool>
    
    let loginTap = PublishSubject<Void>()
    
    init(input:(
        username: Observable<String>,
        password: Observable<String>,
        loginTap: Observable<Void>)) {
        
        let API = GithubAPI.shared
        
        validationUsername = input.username.flatMapLatest({ username -> Observable<ValidationResult> in
            // 是否为空
            if username.count == 0 {
                return Observable.just(.empty)
            }
            
            // 是否数字和字母
            if  username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
                return Observable.just(.failed(message: "Username can only contain numbers or digits"))
            }
            
            let loadingValue = ValidationResult.validating
            
            return API.usernameAvailable(username).map({ available in
                if available {
                    return .ok(message: "Username available")
                } else {
                    return .failed(message: "Username already taken")
                }
            }).startWith(loadingValue)
            .observeOn(MainScheduler.instance)
                .catchErrorJustReturn(.failed(message: "Error contacting server"))
        }).share(replay: 1)
        
        validationPassword = input.password.map({ password in
            let numberOfCharactors = password.count
            if numberOfCharactors == 0 {
                return .empty
            }
            return .ok(message: "Password acceptable")
        }).share(replay: 1)
        
        loginEnable = Observable.combineLatest(validationUsername, validationPassword, resultSelector: { (username, password) in
            username.isValid && password.isValid
        }).distinctUntilChanged()
        .share(replay: 1)
        
        let usernameAndPassword = Observable.combineLatest(input.username, input.password) {($0, $1)}
        
        logined = self.loginTap.asObservable().withLatestFrom(usernameAndPassword).flatMapLatest({ (username, password) in
            return API.login(username, password: password).observeOn(MainScheduler.instance).catchErrorJustReturn(false)
        }).share(replay: 1)
    }
}
