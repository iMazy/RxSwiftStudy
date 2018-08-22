//
//  NewCitySearchViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/8/22.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class NewCitySearchViewController: BaseViewController {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var favoriteSwitch: UISwitch!
    @IBOutlet weak var tableView: UITableView!
    
    // input
    var allCities = Variable<[(String, Bool)]>([])
    
    // output
    var cities = Variable<[(String, Bool)]>([])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        edgesForExtendedLayout = []
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellid")
        
        let sourceCities = [("Beijing", true),
                     ("Shanghai", false),
                     ("Guangzhou", false),
                     ("Shenzhen", false),
                     ("Zhuhai", true),
                     ("Changsha", false),
                     ("Tinajing", false),
                     ("Wuhan", true),
                     ("Xiangyang", true),
                     ("Yichang", false)]
        
        allCities.value = sourceCities
        
        Observable.combineLatest(allCities.asObservable(), favoriteSwitch.rx.isOn, searchField.rx.text.orEmpty) { (_cities, isFavorite, searchText) in
            print("\(_cities)  \(isFavorite) \(searchText)")
            return _cities.filter({ city -> Bool in
                return self.shouldDisplayCity(city, onlyFavorite: isFavorite, search: searchText)
            })
        }.bind(to: cities).disposed(by: disposeBag)
        
        // 设置 tableView 数据 (原理是对 cellForRow 的封装)
        cities.asObservable().bind(to: tableView.rx.items) { tableView, row, element in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellid")!
            cell.textLabel?.text = element.0 + (element.1 ? " ❤️" : "")
            return cell
            }.disposed(by: disposeBag)
        
        
    }
    
    func shouldDisplayCity(_ city: (String, Bool), onlyFavorite: Bool, search: String?) -> Bool {
        if onlyFavorite && !city.1 {
            return false
        }
        
        if let _search = search, !_search.isEmpty, !city.0.uppercased().contains(_search.uppercased()) {
            return false
        }
        return true
    }

}
