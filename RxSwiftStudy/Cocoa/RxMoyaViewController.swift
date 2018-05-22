//
//  RxMoyaViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/5/2.
//  Copyright © 2018 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import ObjectMapper

class RxMoyaViewController: BaseViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_id")
        view.addSubview(tableView)
        
        // 获取列表数据
        let data = DoubanProvider.rx.request(.channels).mapObject(Douban.self).map{ $0.channels ?? [] }.asObservable()
        
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id")!
            cell.textLabel?.text = "\(element.name!)"
            cell.accessoryType = .disclosureIndicator
            return cell
        }.disposed(by: disposeBag)
        
        // 单元格点击
        tableView.rx.modelSelected(Channel.self)
            .map{ $0.channelId! }
            .flatMap{ DoubanProvider.rx.request(.playlist($0)) }.mapObject(PlayList.self)
            .subscribe(onNext: { playlist in
            // 解析数据
                if playlist.song.count > 0 {
                    let artist = playlist.song[0].artist!
                    let title = playlist.song[0].title!
                    print("歌手: \(artist) \n歌曲: \(title)")
                }
        }).disposed(by: disposeBag)
        
    }

    func moyaBaseUse()  {
        // 获取数据
        DoubanProvider.rx.request(.channels)
            .subscribe { event in
                switch event {
                case .success(let response):
                    // 数据处理
                    let str = String(data: response.data, encoding: String.Encoding.utf8)
                    print("返回的数据是: ", str ?? "")
                case .error(let error):
                    print("数据请求失败! 错误原因: ", error)
                }
            }.disposed(by: disposeBag)
        
        // Way 2
        DoubanProvider.rx.request(.channels)
            .subscribe(onSuccess: { response in
                // 数据处理
                let str = String(data: response.data, encoding: String.Encoding.utf8)
                print("返回的数据是: ", str ?? "")
            }, onError: { error in
                print("数据请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
        
        // To Json
        DoubanProvider.rx.request(.channels)
            .subscribe(onSuccess: { response in
                // 数据处理
                let json = try? response.mapJSON() as! [String: Any]
                print("--- 请求成功, 返回的数据: ---")
                print(json!)
            }, onError: { error in
                print("数据请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
        
        // to json way 3
        DoubanProvider.rx.request(.channels)
            .mapJSON()
            .subscribe(onSuccess: { data in
                // 数据处理
                let json = data as! [String: Any]
                print("--- 请求成功, 返回的数据: ---")
                
            }, onError: { error in
                print("数据请求失败! 错误原因: ", error)
            }).disposed(by: disposeBag)
        
        // to dict observable
        let _ = DoubanProvider.rx.request(.channels).mapJSON().map { data -> [[String : Any]] in
            if let json = data as? [String: Any], let channels = json["channels"] as? [[String: Any]] {
                return channels
            } else {
                return []
            }
            }.asObservable()
        
        // json 转模型
        DoubanProvider.rx.request(.channels).mapObject(Douban.self).subscribe(onSuccess: { (douban) in
            if let channels = douban.channels {
                print("--- 总共\(channels.count)个频道 ---")
                for channel in channels {
                    if let name = channel.name, let channelID = channel.channelId {
                        print("\(name)  (id: \(channelID)")
                    }
                }
            }
        }, onError: { error in
            print("数据请求失败! 错误原因: ", error)
        }).disposed(by: disposeBag)
    }
}

// 歌曲列表模型
struct PlayList: Mappable {
    
    var r: Int!
    var isShowQuickStart: Int!
    var song: [Song]!
    
    init?(map: Map) {
    }
    
    mutating func mapping(map: Map) {
        r <- map["r"]
        isShowQuickStart <- map["is_show_quick_start"]
        song <- map["song"]
    }
}

// 歌曲模型
struct Song: Mappable {
    
    var title: String!
    var artist: String!
    
    init?(map: Map) { }
    
    mutating func mapping(map: Map) {
        title  <- map["title"]
        artist <-  map["artist"]
    }
}
