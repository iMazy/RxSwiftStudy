//
//  RxRefreshViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/28.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PullToRefresh

class RxRefreshViewController: BaseViewController {

    var tableView: UITableView!
    var dataSource = ["0","1","2","3","4","5","6","7","8","9","10","0","1","2","3","4","5","6","7","8","9","10"]
    
    // ViewModel
    private var viewModel = RefreshViewModel()
    private var vmOutput: RefreshViewModel.Output?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        // 注册cell
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        view.addSubview(tableView)
        
//        let subjects = BehaviorSubject(value: self.dataSource)
        
//        dataSource = PublishSubject.just(["0","1","2","3","4","5","6","7","8","9","10"])
        // bindto
//        dataSource.bind(to: tableView.rx.items) { (tv, row, element) in
//            let cell = tv.dequeueReusableCell(withIdentifier: "cellid")!
//            cell.textLabel?.text = element
//            return cell
//        }.disposed(by: disposeBag)
        
        // drive
//        subjects.asDriver(onErrorJustReturn: []).drive(tableView.rx.items) { (tv, row, element) in
//            let cell = tv.dequeueReusableCell(withIdentifier: "cellid")!
//            cell.textLabel?.text = element
//            return cell
//        }.disposed(by: disposeBag)
        
        
        let vmInput = RefreshViewModel.Input()
        vmOutput = viewModel.transform(input: vmInput)
        
        // drive
        vmOutput?.sections.asDriver().asDriver(onErrorJustReturn: []).drive(tableView.rx.items) { (tv, row, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "cellid")!
            cell.textLabel?.text = element
            return cell
            }.disposed(by: disposeBag)
//
        tableView.addPullToRefresh(PullToRefresh()) { [unowned self] in
//            subjects.onNext(self.dataSource)
            vmInput.requestCommand.onNext(true)
            self.vmOutput?.refreshEnd.subscribe(onNext: { result in
                if result {                
                    self.tableView.endRefreshing(at: .top)
                    print(result)
                }
            }).disposed(by: self.disposeBag)
        }
        
        
        tableView.addPullToRefresh(PullToRefresh(position: .bottom)) { [unowned self] in
//            self.dataSource.append("666")
//            subjects.onNext(self.dataSource)
            vmInput.requestCommand.onNext(false)
            self.tableView.endRefreshing(at: .bottom)
        }
        
        tableView.startRefreshing(at: .top)
    }

    deinit {
        tableView.removeAllPullToRefresh()
    }

}
