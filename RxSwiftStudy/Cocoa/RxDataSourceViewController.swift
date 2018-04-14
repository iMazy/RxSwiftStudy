//
//  RxDataSourceViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/14.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxDataSourceViewController: BaseViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        muitilySectionViewByRxDataSources()
    }
    
    /// 多分区的 TableView
    func muitilySectionViewByRxDataSources() {
        // 创建表格
        tableView = UITableView(frame: view.bounds, style: .plain)
        // 注册单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(tableView)
        
        // 初始化数据
        let items = Observable.just([
            XMSessionModel(header: "基本控件",
                           items: ["UILabel的用法",
                                   "UIButton的用法",
                                   "UITextField的用法"]),
            XMSessionModel(header: "高级i控件",
                           items: ["UITableView的用法",
                                   "UICollectionView的用法"])
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<XMSessionModel>( configureCell: {
            (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            cell.textLabel?.text = "\(indexPath.row): \(element)"
            return cell
        })
        
        // 设置分区头标题
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].header
        }
        
        // 设置分区尾部标题
        dataSource.titleForFooterInSection = { dataSource, index in
            return "footer"
        }
        
        // 数据绑定
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    /// 自定义 SectionModel 的 tableView
    func customSectionByRxDataSources() {
        // 创建表格
        tableView = UITableView(frame: view.bounds, style: .plain)
        // 注册单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(tableView)
        
        // 初始化数据
        let sections = Observable.just([
            XMSessionModel(header: "",
                           items: ["UILabel的用法",
                                   "UIButton的用法",
                                   "UITextField的用法"])
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<XMSessionModel>( configureCell: {
            (dataSource, tableView, indexPath, item) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID") ?? UITableViewCell(style: .default, reuseIdentifier: "cellID")
            cell.textLabel?.text = "\(indexPath.row): \(item)"
            return cell
        })
        
        // 数据绑定
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    /// 系统单分区 TableView
    func systemSectionByRxDataSources() {
        // 创建表格
        tableView = UITableView(frame: view.bounds, style: .plain)
        // 注册单元格
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        view.addSubview(tableView)
        
        // 初始化数据
        let items = Observable.just([
            SectionModel(model: "",
                         items: ["UILabel的用法",
                                 "UIButton的用法",
                                 "UITextField的用法"])
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: {
            (dataSource, tableView, indexPath, element) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            cell.textLabel?.text = "\(indexPath.row): \(element)"
            return cell
        })
        
        // 数据绑定
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}


// 自定义sectionModel
struct XMSessionModel {
    var header: String
    var items: [Item]
}

extension XMSessionModel: AnimatableSectionModelType {
    
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: XMSessionModel, items: [Item]) {
        self = original
        self.items = items
    }
}
