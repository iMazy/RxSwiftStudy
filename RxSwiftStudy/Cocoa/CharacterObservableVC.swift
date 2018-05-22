//
//  CharacterObservableVC.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/3/31.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class CharacterObservableVC: BaseViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        convertToSingle()
        
        getPlayListWithSingle("0").subscribe(onSuccess: { (result) in
            print(result)
        }, onError: { error in
            print(error)
        }).disposed(by: disposeBag)
        
    }
    
    /// Single
    // 它要么只能发出一个元素，要么产生一个 error 事件。
    // 比较常见的例子就是执行 HTTP 请求，然后返回一个应答或错误
    
    /// SingleEvent
    /*
     public enum SingleEvent<Element> {
         case success(Element)
         case error(Swift.Error)
     }
     */
    
    /// asSingle 将 Observable 转换成 Single
    func convertToSingle() {
        Observable.of("🐵").asSingle()
            .subscribe(onSuccess: { (num) in
                print(num)
            }) { (error) in
                print(error)
        }.disposed(by: disposeBag)
    }
    
    func getPlayListWithSingle(_ channel: String) -> Single<[String: Any]> {
        
        return Single<[String: Any]>.create(subscribe: { (single) -> Disposable in
            
            let url = "https://douban.fm/j/mine/playlist?type=n&channel=\(channel)&from=mainsite"
            
            let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, _, error) in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                    let result = json as? [String: Any] else {
                    single(.error(DataError.cantParseJSON))
                    return
                }
                single(.success(result))
            })
            task.resume()
            
            return Disposables.create { task.cancel() }
        })
    }

}

//与数据相关的错误类型
enum DataError: Error {
    case cantParseJSON
}
