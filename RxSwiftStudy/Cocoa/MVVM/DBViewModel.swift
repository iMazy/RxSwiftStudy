//
//  DBViewModel.swift
//  RxSwiftStudy
//
//  Created by  Mazy on 2018/5/26.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class DBViewModel {

//    var centerVariable = Variable<CGPoint?>(.zero) // Create one variable that will be changed and observed
    var channelObservable: Observable<[DBChannel]>! // Create observable that will change
    
    init() {
        setup()
    }
    
    func setup() {
        let data = DoubanProvider.rx.request(.channels).mapObject(DBModel.self).map{ $0.channels ?? [] }.asObservable()
        channelObservable = data
    }
}


