//
//  RxAlamofireViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/5/2.
//  Copyright © 2018 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import Alamofire
import RxAlamofire

class RxAlamofireViewController: BaseViewController {

    var startRequestButton: UIButton = UIButton(type: .system)
    var cancelRequestButton: UIButton = UIButton(type: .system)
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_id")
        
        // 创建 URL 对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)!
        
        // json 转 模型
        let data = requestJSON(.get, url).map{ $1 }.mapObject(type: Douban.self).map{ $0.channels ?? [] }
        
        // 数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id")!
            cell.textLabel?.text = "\(row): \(element.name!)"
            return cell
        }.disposed(by: disposeBag)
    }
    
    func requestJsonToModel() {
        // 创建 URL 对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)!
        
        // json 转 模型
        requestJSON(.get, url).map{ $1 }.mapObject(type: Douban.self).subscribe(onNext: { (douban: Douban) in
            if let channels = douban.channels {
                print("--- 共有\(channels.count)个频道 ---")
                for channel in channels {
                    if let name = channel.name, let channelId = channel.channelId {
                        print("\(name)  (id: \(channelId)")
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
    
    func requestToJSON() {
        // 创建 URL 对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)!
        
        // 使用 responseJSON() 进行转换
        request(.get, url).responseJSON().subscribe(onNext: { dataResponse in
            let json = dataResponse.value as! [String: Any]
            print("--- 请求成功,返回的json数据 ---")
            print(json)
        }).disposed(by: disposeBag)
        
        // 最简单的获取json 数据方法
        requestJSON(.get, url).subscribe(onNext: { response, data in
            let json = data as! [String: Any]
            print("--- 请求成功,返回的json数据 ---")
            print(json)
        }).disposed(by: disposeBag)
    }
    
    
    func startAndCancelRequest() {
        startRequestButton.frame = CGRect(x: 100, y: 100, width: 200, height: 30)
        startRequestButton.setTitle("发起请求", for: .normal)
        view.addSubview(startRequestButton)
        
        cancelRequestButton.frame = CGRect(x: 100, y: 150, width: 200, height: 30)
        cancelRequestButton.setTitle("取消请求", for: .normal)
        cancelRequestButton.setTitleColor(.red, for: .normal)
        view.addSubview(cancelRequestButton)
        
        // 创建 URL 对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)!
        
        // request
        // 创建并发起请求
        startRequestButton.rx.tap.asObservable().flatMap{
            request(.get, url).responseString().takeUntil(self.cancelRequestButton.rx.tap) // 点击取消按钮 停止请求
            }.subscribe(onNext: { response, data in
                // 数据处理
                print("请求成功, 返回的数据: ", data)
            }, onError: { error in
                print("请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
    }
    
    func rxAlamofireBaseUse() {
        // 创建 URL 对象
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)!
        
        // request
        // 创建并发起请求
        request(.get, url).data().subscribe(onNext: { data in
            // 数据处理
            let str = String(data: data, encoding: String.Encoding.utf8)
            print("返回的数据: ", str ?? "")
        }, onError: { error in
            print("请求失败! 错误原因: ", error)
        }).disposed(by: disposeBag)
        
        
        // requestData
        // 使用 requestData 的话，不管请求成功与否都会进入到 onNext 这个回调中
        requestData(.get, url).subscribe(onNext: { response, data in
            // 数据处理
            print("状态码: ", response.statusCode)
            let str = String(data: data, encoding: String.Encoding.utf8)
            print("返回的数据: ", str ?? "")
        }).disposed(by: disposeBag)
        
        // 通过状态码过滤
        requestData(.get, url).subscribe(onNext: { response, data in
            // 判断响应状态码
            if 200..<300 ~= response.statusCode {
                let str = String(data: data, encoding: String.Encoding.utf8)
                print("请求成功, 返回的数据: ", str ?? "")
            } else {
                print("请求失败")
            }
        }).disposed(by: disposeBag)
        
        // 获取 String 类型的数据
        // 如果请求的数据是字符串类型的，我们可以在 request 请求时直接通过 responseString() 方法实现自动转换
        request(.get, url).responseString().subscribe(onNext: { response, data in
            // 数据处理
            print("状态码: ", response.statusCode)
            print("返回的数据: ", data)
        }).disposed(by: disposeBag)
        
        // 直接使用 requestString 去获取数据
        requestString(.get, url).subscribe(onNext: { response, data in
            // 数据处理
            print("状态码: ", response.statusCode)
            print("返回的数据: ", data)
        }).disposed(by: disposeBag)
    }

}
