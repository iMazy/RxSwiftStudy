//
//  RxURLSessionViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/28.
//  Copyright © 2018 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxURLSessionViewController: BaseViewController {

    var startRequestButton: UIButton = UIButton()
    var cancelRequestButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建 URL
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        
        // 创建request
        let request = URLRequest(url: url!)
        
        // 请求数据 系统自带的转换
        do {
            URLSession.shared.rx.data(request: request).subscribe(onNext: { data in
                // 数据处理
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
                print("----- 请求成功, 请求的数据如下:-----")
                print(json!)
            }, onError: { error in
                print("请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
        }
        
        // 通过映射 转换为json
        do {
            // 在订阅前就进行转换也是可以的
            URLSession.shared.rx.data(request: request)
                .map{ try JSONSerialization.jsonObject(with: $0, options: .allowFragments) as! [String: Any] }
                .subscribe(onNext: { jsonData in
                    print("----- 请求成功, 请求的数据如下:-----")
                    print(jsonData)
                }).disposed(by: disposeBag)
        }
        
        // 通过rx.json
        do {
            URLSession.shared.rx.json(request: request).subscribe(onNext: { data in
                let json = data as! [String: Any]
                print("----- 请求成功, 请求的数据如下:-----")
                print(json)
            }).disposed(by: disposeBag)
        }
        
        // 通过rx.json
        do {
            URLSession.shared.rx.json(request: request)
                .map{ $0 as! [String: Any] }
                .subscribe(onNext: { json in
                print("----- 请求成功, 请求的数据如下:--888---")
                print(json)
            }).disposed(by: disposeBag)
        }
        
    }
    
    // 掉起和取消请求
    func startAndResumeRequest() {
        
        startRequestButton.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        startRequestButton.setTitle("发起请求", for: .normal)
        startRequestButton.backgroundColor = .red
        view.addSubview(startRequestButton)
        
        cancelRequestButton.frame = CGRect(x: 100, y: 200, width: 200, height: 30)
        cancelRequestButton.setTitle("取消请求", for: .normal)
        cancelRequestButton.backgroundColor = .red
        view.addSubview(cancelRequestButton)
        
        // 创建 URL
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        
        // 创建request
        let request = URLRequest(url: url!)
        
        // 发起请求按钮点击
        startRequestButton.rx.tap.asObservable().flatMap {
            URLSession.shared.rx
                .data(request: request)
                .takeUntil(self.cancelRequestButton.rx.tap) // 如果点击取消请求, 停止请求
            }.subscribe(onNext: { data in
                // 数据处理
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功. 返回的数据: ", str ?? "")
            }, onError: { error in
                print("请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
    }
    
    /// rx.data 与 rx.response 的区别：
    // - 如果不需要获取底层的 response，只需知道请求是否成功，以及成功时返回的结果，那么建议使用 rx.data。
    // - 因为 rx.data 会自动对响应状态码进行判断，只有成功的响应（状态码为 200~300）才会进入到 onNext 这个回调，否则进入 onError 这个回调。
    func rxDataRequest() {
        // 创建 URL
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        
        // 创建request
        let request = URLRequest(url: url!)
        
        // 请求数据
        URLSession.shared.rx.data(request: request).subscribe(onNext: { data in
            // 数据处理
            let str = String(data: data, encoding: String.Encoding.utf8)
            print("请求成功. 返回的数据: ", str ?? "")
        }, onError: { error in
            print("请求失败! 错误原因: ", error)
        }).disposed(by: disposeBag)
    }
    
    func rxRequest() {
        // 创建 URL
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        
        // 创建request
        let request = URLRequest(url: url!)
        
        // 请求数据
        URLSession.shared.rx.response(request: request).subscribe(onNext: { (response, data) in
            // 判断响应状态码
            if 200..<300 ~= response.statusCode {
                // 数据处理
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("返回的数据: ", str ?? "")
            } else {
                print("请求失败")
            }
        }).disposed(by: disposeBag)
    }
}
