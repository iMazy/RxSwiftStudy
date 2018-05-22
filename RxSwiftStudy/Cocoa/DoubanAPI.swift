//
//  DoubanAPI.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/5/2.
//  Copyright © 2018 Happy Iterating Inc. All rights reserved.
//

import Foundation
import Moya

// 初始化豆瓣FM 请求的 provider
let DoubanProvider = MoyaProvider<DoubanAPI>()

public enum DoubanAPI {
    case channels           // 获取频道列表
    case playlist(String)   // 获取歌曲
}

extension DoubanAPI: TargetType {
    
    // 服务器地址
    public var baseURL: URL {
        switch self {
        case .channels:
            return URL(string: "https://www.douban.com")!
        case .playlist(_):
            return URL(string: "https://douban.fm")!
        }
    }
    
    // 请求的具体路径
    public var path: String {
        switch self {
        case .channels:
            return "/j/app/radio/channels"
        case .playlist(_):
            return "/j/mine/playlist"
        }
    }
    
    // 请求类型
    public var method: Moya.Method {
        return .get
    }
    
    // 这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
    public var sampleData: Data {
        return "{}".data(using: String.Encoding.utf8)!
    }
    
    // 请求任务事件（这里附带上参数）
    public var task: Task {
        switch self {
        case .playlist(let channel):
            var params: [String: Any] = [:]
            params["channel"] = channel
            params["type"] = "n"
            params["from"] = "mainsite"
            return .requestParameters(parameters: params, encoding: URLEncoding.default)
        default:
            return .requestPlain
        }
    }
    
    // 是否执行Alamofire验证
    public var validate: Bool {
        return false
    }
    
    public var headers: [String : String]? {
        return nil
    }
}
