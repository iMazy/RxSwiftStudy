//
//  RefreshViewModel.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/28.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import ObjectMapper

protocol XMViewModelType {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
}

class RefreshViewModel {
    var disposeBag = DisposeBag()
    private var vmDatas = BehaviorRelay<[String]>(value: [])
    private var page: Int = 1
}

extension RefreshViewModel: XMViewModelType {
    struct Input {
        let requestCommand = PublishSubject<Bool>()
    }
    
    struct Output {
        
        let sections: Driver<[String]>
        let refreshEnd: BehaviorRelay<Bool>
        init(sections: Driver<[String]>) {
            self.sections = sections
            refreshEnd = BehaviorRelay(value: false)
        }
    }
    
    func transform(input: Input) -> Output {
        let tempSctions = vmDatas.asObservable().asDriver(onErrorJustReturn: [])
        let output = Output(sections: tempSctions)
        input.requestCommand.subscribe(onNext: { [weak self] (isPull) in
            guard let `self` = self else { return }
            output.refreshEnd.accept(false)
            var dataSource: [String] = ["0","1","2","3","4","5","6","7","8","9","10"] + ["0","1","2","3","4"]
            if isPull {
                dataSource = dataSource + ["0","1","2","3","4","5","6","7","8","9","10"] + ["0","1","2","3","4"]
            } else {
                dataSource = dataSource + ["6666"]
            }
            // 更新数据
            DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 2) {
                self.vmDatas.accept(dataSource)
                output.refreshEnd.accept(true)
            }
        }).disposed(by: disposeBag)
        return output
    }
}
