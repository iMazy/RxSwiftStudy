//
//  RxTableViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/9.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxTableViewController: BaseViewController {

    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: view.bounds, style: .plain)

        // 注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        view.addSubview(tableView)

        // 初始化数据
        let items = Observable.just([
            "文本输入框的用法",
            "开关按钮的用法",
            "进度条的用法",
            "文本标签的用法"
            ])
    

        // 设置 tableView 数据 (原理是对 cellForRow 的封装)
        items.bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid")!
            cell.textLabel?.text = "\(row): \(element)"
            return cell
        }.disposed(by: disposeBag)

        // 获取选中项的索引
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项的indexPath为: \(indexPath)")
        }).disposed(by: disposeBag)

        // 获取选中项的内容
        tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("选中项的标题为: \(item)")
        }).disposed(by: disposeBag)

        // 获取选中项的索引和内容
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelSelected(String.self)).bind { [weak self] indexPath, item in
            print("~选中项的indexPath为: \(indexPath)")
            print("~选中项的标题为: \(item)")
        }.disposed(by: disposeBag)
        
        // 获取被取消选中项的索引
        tableView.rx.itemDeselected.subscribe(onNext: { [weak self] indexPath in
            print("被取消选中项的indexPath为: \(indexPath)")
        }).disposed(by: disposeBag)

        // 获取被取消选中项的内容
        tableView.rx.modelDeselected(String.self).subscribe(onNext: { item in
            print("被取消选中项的标题为: \(item)")
        }).disposed(by: disposeBag)

        // 获取选中项的索引和内容
        Observable.zip(tableView.rx.itemSelected, tableView.rx.modelDeselected(String.self)).bind { [weak self] indexPath, item in
            print("~被取消选中项的indexPath为: \(indexPath)")
            print("~被取消选中项的标题为: \(item)")
        }.disposed(by: disposeBag)
        
        // 打开 cell 的编辑功能
        tableView.setEditing(true, animated: true)
        // 获取删除项的索引
        tableView.rx.itemDeleted.subscribe(onNext: { indexPath in
            print("删除项的indexPath: \(indexPath)")
        }).disposed(by: disposeBag)

        tableView.rx.modelDeleted(String.self).subscribe(onNext: { item in
            print("删除项的item: \(item)")
        }).disposed(by: disposeBag)

        // 删除项的索引和内容
        Observable.zip(tableView.rx.itemDeleted, tableView.rx.modelDeleted(String.self)).bind { indexPath, item in
            print("~删除项的indexPath: \(indexPath)")
            print("~删除项的item: \(item)")
        }.disposed(by: disposeBag)
        
        // 单元格移动事件响应
        tableView.setEditing(true, animated: true)
        tableView.rx.itemMoved.subscribe(onNext: { sourceIndexPath, destinationIndexPath in
             print("移动项原来的的indexPath: \(sourceIndexPath)")
             print("移动项现在的的indexPath: \(destinationIndexPath)")
        }).disposed(by: disposeBag)

        // 获取插入项的索引
        tableView.rx.itemInserted.subscribe(onNext: { [weak self] indexPath in
            print("插入项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)

        // 获取点击的尾部图标的索引
        tableView.rx.itemAccessoryButtonTapped.subscribe(onNext: { [weak self] indexPath in
            print("尾部项的indexPath为：\(indexPath)")
        }).disposed(by: disposeBag)
        
        // 单元格将要显示出来的事件响应
        tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
            print("将要显示的indexPath为：\(indexPath)")
            print("将要显示的cell为：\(indexPath)")
        }).disposed(by: disposeBag)
    }
}
