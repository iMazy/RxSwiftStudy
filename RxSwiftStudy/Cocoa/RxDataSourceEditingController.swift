//
//  RxDataSourceEditingController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/17.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class RxDataSourceEditingController: BaseViewController {

    var tableView: UITableView!
    var refreshButton: UIBarButtonItem = UIBarButtonItem()
    var addButton: UIBarButtonItem = UIBarButtonItem()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建表格视图
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_id")
        view.addSubview(tableView)
        
        // 创建导航栏按钮
        refreshButton.title = "刷新"
        navigationItem.leftBarButtonItem = refreshButton
        addButton.title = "+"
        navigationItem.rightBarButtonItem = addButton
        
        // 创建表格模型
        let initialVM = TableViewModel()
        
        // 刷新数据源
        let refreshCommand = refreshButton.rx.tap.asObservable()
            .startWith(())
            .flatMapLatest(getRandomResult)
            .map(TableEditingCommand.setItems)
        
        // 新增条目命令
        let addCommand = addButton.rx.tap.asObservable()
            .map{ "\(arc4random())" }
            .map(TableEditingCommand.addItem)
        
        // 移动位置命令
        let moveCommand = tableView.rx.itemMoved
            .map(TableEditingCommand.moveItem)
        
        // 删除位置命令
        let deleteCommand = tableView.rx.itemDeleted.asObservable()
            .map(TableEditingCommand.deleteItem)
        
        // 绑定单元格数据
        Observable.of(refreshCommand, addCommand, moveCommand, deleteCommand).merge().scan(initialVM) {
            (vm: TableViewModel, command: TableEditingCommand) -> TableViewModel in
                return vm.execute(command: command)
            }
            .startWith(initialVM)
            .map{
                [AnimatableSectionModel(model: "", items: $0.items)]
            }.share(replay: 1)
            .bind(to: tableView.rx.items(dataSource: RxDataSourceEditingController.dataSource()))
            .disposed(by: disposeBag)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 开启编辑模式
        tableView.setEditing(true, animated: true)
    }
    
    // 获取数据源
    func getRandomResult() -> Observable<[String]> {
        let items = (0..<5).map{ _ in "\(arc4random())" }
        return Observable.just(items)
    }
}

extension RxDataSourceEditingController {
    // 创建表格数据源
    static func dataSource() -> RxTableViewSectionedAnimatedDataSource<AnimatableSectionModel<String, String>> {
        return RxTableViewSectionedAnimatedDataSource(
            // 设置插入, 删除, 移动单元格动画效果
            animationConfiguration: AnimationConfiguration(insertAnimation: .top, reloadAnimation: .fade, deleteAnimation: .left),
            configureCell: { (dataSource, tableView, indexPath, element) in
                let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id")
                cell?.textLabel?.text = "条目\(indexPath.row): \(element)"
                return cell!
            },
            canEditRowAtIndexPath: {_, _ in
                return true // 单元格可删除
            },
            canMoveRowAtIndexPath: {_, _ in
                return true // 单元格可移动
            }
        )
    }
}
