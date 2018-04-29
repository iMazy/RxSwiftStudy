//
//  RxURLSessionModelViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/29.
//  Copyright © 2018 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

/// 数据错误映射
public enum RxObjectMapperError: Error {
    case parsingError
}

//扩展Observable：增加模型映射方法
public extension Observable where Element:Any {
    // 将json 转成对象
    public func mapObject<T>(type: T.Type) -> Observable<T> where T: Mappable {
        let mapper = Mapper<T>()
        return self.map({ (element) -> T in
            guard let parsedElement = mapper.map(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            return parsedElement
        })
    }
    
    //将JSON数据转成数组
    public func mapArray< T>(type:T.Type) -> Observable<[T]> where T:Mappable {
        let mapper = Mapper<T>()
        
        return self.map { (element) -> [T] in
            guard let parsedArray = mapper.mapArray(JSONObject: element) else {
                throw RxObjectMapperError.parsingError
            }
            
            return parsedArray
        }
    }
}

/// 豆瓣接口模型
class Douban: Mappable {
    var channels: [Channel]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        channels <- map["channels"]
    }
    
}

class Channel: Mappable {
    var name: String?
    var nameEn: String?
    var channelId: String?
    var seqId: Int?
    var abbrEn: String?
    
    init() { }
    
    required init?(map: Map) {
    }
    
    // Mappable
    func mapping(map: Map) {
        name <- map["name"]
        nameEn <- map["name_en"]
        channelId <- map["channel_id"]
        seqId <- map["seq_id"]
        abbrEn <- map["abbr_en"]
    }
}

class RxURLSessionModelViewController: BaseViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_id")
        view.addSubview(tableView)
        
        // 创建 URL
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        
        // 创建request
        let request = URLRequest(url: url!)
        // 获取列表数据
        let data = URLSession.shared.rx.json(request: request).mapObject(type: Douban.self).map({ $0.channels ?? [] })
        // 将数据绑定到表格
        data.bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id")!
            cell.textLabel?.text = "\(row)：\(element.name!)"
            return cell
        }.disposed(by: disposeBag)
        
    }
    
    func mapObjectToModel() {
        // 创建 URL
        let urlString = "https://www.douban.com/j/app/radio/channels"
        let url = URL(string: urlString)
        
        // 创建request
        let request = URLRequest(url: url!)
        // 获取列表数据
        URLSession.shared.rx.json(request: request).mapObject(type: Douban.self).subscribe(onNext: { (douban: Douban) in
            if let channels = douban.channels {
                print("--- 共\(channels.count)个频道 ---")
                for channel in channels {
                    if let name = channel.name, let channelId = channel.channelId {
                        print("name: \(name), id: \(channelId)")
                    }
                }
            }
        }).disposed(by: disposeBag)
    }
}
