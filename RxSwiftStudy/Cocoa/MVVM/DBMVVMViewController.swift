//
//  DBMVVMViewController.swift
//  RxSwiftStudy
//
//  Created by  Mazy on 2018/5/26.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit

class DBMVVMViewController: BaseViewController {

    private var tableView: UITableView!
    private var viewModel: DBViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // init tableView
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_id")
        view.addSubview(tableView)
        
        // init viewModel
        viewModel = DBViewModel()
        
        // add hud
        
        // 将数据绑定到表格
        viewModel.channelObservable.do(onNext: { element in
            // dismiss hud
            print("request Next：", element)
        }).bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id")!
            cell.textLabel?.text = "\(element.name!)"
            cell.accessoryType = .disclosureIndicator
            return cell
            }.disposed(by: disposeBag)
    }
}
