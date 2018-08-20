//
//  GithubAPI.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/20.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GithubAPI {

    let urlSession: URLSession
    
    static let shared = GithubAPI(URLSession: Foundation.URLSession.shared)
    
    init(URLSession: URLSession) {
        self.urlSession = URLSession
    }
    
    func usernameAvailable(_ username: String) -> Observable<Bool> {
        let url = URL(string: "https://api.github.com/username=\(username.URLEscaped)")!
        let request = URLRequest(url: url)
        return urlSession.rx.response(request: request).map({ response, _ in
            return response.statusCode == 404
        }).catchErrorJustReturn(false)
    }
    
    func login(_ username: String, password: String) -> Observable<Bool> {
        guard let baseURL = URL(string: "https://api.github.com"), let url = URL(string: "login?username=\(username)&password=\(password)", relativeTo: baseURL) else { return Observable.just(false) }
        let request = URLRequest(url: url)
        return urlSession.rx.response(request: request).map({ response, _ in
            print(response)
            return response.statusCode == 200
        }).catchErrorJustReturn(false)
    }
}

extension String {
    var URLEscaped: String {
        return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
    }
}
