//
//  DBModel.swift
//  RxSwiftStudy
//
//  Created by  Mazy on 2018/5/26.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import ObjectMapper

/// 豆瓣接口模型
class DBModel: Mappable {
    var channels: [DBChannel]?
    
    init() {
        
    }
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        channels <- map["channels"]
    }
    
}

class DBChannel: Mappable {
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
        name        <- map["name"]
        nameEn      <- map["name_en"]
        channelId   <- map["channel_id"]
        seqId       <- map["seq_id"]
        abbrEn      <- map["abbr_en"]
    }
}
