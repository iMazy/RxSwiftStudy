//
//  RxDataSourcesMultiCellController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/20.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class RxDataSourcesMultiCellController: BaseViewController {

    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        view.addSubview(tableView)
        tableView.register(UINib(nibName: "TitleImageViewCell", bundle: nil), forCellReuseIdentifier: "TitleImageViewCell")
        tableView.register(UINib(nibName: "TitleSwitchViewCell", bundle: nil), forCellReuseIdentifier: "TitleSwitchViewCell")
        
        // 初始化数据
        let sections = Observable.just([
                MySection(header: "我是第一个分区", items: [
                    .TitleImageSectionItem(title: "PHP", image: #imageLiteral(resourceName: "php")),
                    .TitleImageSectionItem(title: "React", image: #imageLiteral(resourceName: "react")),
                    .TitleSwitchSectionItem(title: "Switch on", enabled: true)
                    ]),
            MySection(header: "我是第二个分区", items: [
                .TitleSwitchSectionItem(title: "Switch off", enabled: false),
                .TitleSwitchSectionItem(title: "Switch on", enabled: true),
                .TitleImageSectionItem(title: "Swift", image: #imageLiteral(resourceName: "swift"))
                ])
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection>(
            configureCell: { (dataSource, tableView, indexPath, item) in
                switch dataSource[indexPath] {
                case let .TitleImageSectionItem(title, image):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TitleImageViewCell", for: indexPath) as! TitleImageViewCell
                    cell.leftTitleLabel.text = title
                    cell.iconImageView.image = image
                    return cell
                case let .TitleSwitchSectionItem(title, enabled):
                    let cell = tableView.dequeueReusableCell(withIdentifier: "TitleSwitchViewCell", for: indexPath) as! TitleSwitchViewCell
                    cell.leftTitleLabel.text = title
                    cell.rightSwitch.isOn = enabled
                    return cell
                }
            },
            // 设置分区头标题
            titleForHeaderInSection: { dataSource, index in
                return dataSource.sectionModels[index].header
            })
        
        // 绑定单元格数据
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}


enum SectionItem {
    case TitleImageSectionItem(title: String, image: UIImage)
    case TitleSwitchSectionItem(title: String, enabled: Bool)
}

struct MySection {
    var header: String
    var items: [SectionItem]
}

extension MySection: SectionModelType {
    typealias Item = SectionItem
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
