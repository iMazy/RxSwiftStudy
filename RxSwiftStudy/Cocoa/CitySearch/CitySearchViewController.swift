//
//  CitySearchViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/21.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CitySearchViewController: BaseViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var citiesSource: [String] = [] // Data source for UITableView
    let allCities = ["ChangSha",
                     "HangZhou",
                     "ShangHai",
                     "BeiJing",
                     "ShenZhen",
                     "New York",
                     "London",
                     "Oslo",
                     "Warsaw",
                     "Berlin",
                     "Praga"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        edgesForExtendedLayout = []
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        
        let searchResult = searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] query -> Observable<[String]> in
            print("query: \(query)")
            if query.isEmpty {
                return Observable.just(self.allCities)
            } else {
                return Observable.just(self.allCities.filter({ $0.uppercased().contains(query.uppercased()) }))
            }
        }.share(replay: 1)
        
        searchResult.bind(to: tableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellID")!
            cell.textLabel?.text = element
            return cell
            }.disposed(by: disposeBag)
    }

    func tableViewWithRxDataSource() {
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: {
            (_, tv, indexPath, element) in
            let cell = tv.dequeueReusableCell(withIdentifier: "cellID")!
            cell.textLabel?.text = element
            return cell
        })
        
        let searchResult = searchBar.rx.text.orEmpty.debounce(0.5, scheduler: MainScheduler.instance).distinctUntilChanged().filter({ !$0.isEmpty }).flatMapLatest { [unowned self] query -> Observable<[String]> in
            print(query)
            return Observable.just(self.allCities.filter({ $0.hasPrefix(query) }))
            }.share(replay: 1)
        
        searchResult.map({ [SectionModel(model: "", items: $0)] }).bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        tableView.rx.modelSelected(String.self).subscribe(onNext: { value in
            print(value)
        }).disposed(by: disposeBag)
        
    }
}
