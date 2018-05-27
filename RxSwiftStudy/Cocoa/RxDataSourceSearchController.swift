//
//  RxDataSourceSearchController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/15.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxDataSourceSearchController: BaseViewController {

    private var tableView: UITableView!
    private var refreshButton = UIBarButtonItem()
    private var searchBar = UISearchBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_id")
        view.addSubview(tableView)
        
        refreshButton.title = "刷新"
        navigationItem.rightBarButtonItem = refreshButton
        
        searchBar.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 56)
        tableView.tableHeaderView = searchBar
        
        // 获取表格数据
        let randomResult = refreshButton.rx.tap.asObservable()
            .startWith(()) // 一开始就请求数据
            .flatMapLatest(getRandomResult) // 获取数据
            .flatMap(filterResult) // 过滤数据
            .share(replay: 1)
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Int>> (configureCell: { (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id")!
            cell.textLabel?.text = "条目\(indexPath.row): \(element)"
            return cell
        })
        
        // 绑定单元格数据
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    
    /// 获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据")
        let items = (0..<5).map({ _ in Int(arc4random()) })
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }

    // 过滤数据
    func filterResult(data: [SectionModel<String, Int>]) -> Observable<[SectionModel<String, Int>]> {
        return self.searchBar.rx.text.orEmpty.flatMapLatest { query -> Observable<[SectionModel<String, Int>]> in
            print("正在筛选数据 条件为: \(query)")
            // 输入条件为空 直接返回原始数据
            if query.isEmpty {
                return Observable.just(data)
            }
            // 输入条件不为空, 返回包含又该文字的数据
            else {
                var newData: [SectionModel<String, Int>] = []
                for sectionModel in data {
                    let items = sectionModel.items.filter{ "\($0)".contains(query) }
                    newData.append(SectionModel(model: sectionModel.model, items: items))
                }
                return Observable.just(newData)
            }
        }
    }

}
