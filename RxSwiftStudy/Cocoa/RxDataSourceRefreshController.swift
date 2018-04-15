//
//  RxDataSourceRefreshController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/15.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class RxDataSourceRefreshController: BaseViewController {

    var tableView: UITableView!
    var refreshButton: UIBarButtonItem = UIBarButtonItem()
    var cancelButton: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton.title = "刷新"
        self.navigationItem.rightBarButtonItem = refreshButton
        cancelButton.title = "取消"
        self.navigationItem.leftBarButtonItem = cancelButton
        
        // 创建表格
        tableView = UITableView(frame: view.bounds, style: .plain)
        // 注册单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(tableView)
        
        // 初始化数据
        let randomResult = refreshButton.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance) // 在主线程中操作, 若1秒钟多次改变, 取最后一次
            .startWith(()) // 加这个是为了一开始就能自动请求一次数据
            .flatMapLatest({ self.getRandomResult().takeUntil(self.cancelButton.rx.tap) }) // 停止数据请求
            .share(replay: 1)
        
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>( configureCell: {
            (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            cell.textLabel?.text = "条目\(indexPath.row): \(element)"
            return cell
        })
        
        // 数据绑定
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    /// 获取数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据")
        let items = (0..<5).map { _ in Int(arc4random()) }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance) // 模拟网络请求 延迟2秒钟
    }
    
    func refreshTableViewDataSourceWithoutCancel() {
        refreshButton = UIBarButtonItem()
        refreshButton.title = "刷新"
        self.navigationItem.rightBarButtonItem = refreshButton
        
        // 创建表格
        tableView = UITableView(frame: view.bounds, style: .plain)
        // 注册单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(tableView)
        
        // 初始化数据
        let randomResult = refreshButton.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance) // 在主线程中操作, 若1秒钟多次改变, 取最后一次
            .startWith(()) // 加这个是为了一开始就能自动请求一次数据
            .flatMapLatest(getRandomResult)
            .share(replay: 1)
        
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>>( configureCell: {
            (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            cell.textLabel?.text = "条目\(indexPath.row): \(element)"
            return cell
        })
        
        // 数据绑定
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}
