//
//  RxDataSourcesWithHeaderController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/20.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class RxDataSourcesWithHeaderController: BaseViewController {

    var tableView: UITableView!
    var dataSource: RxTableViewSectionedAnimatedDataSource<XMSection>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell_id")
        view.addSubview(tableView)
        
        // 初始化数据
        let sections = Observable.just([
            XMSection(header: "基本控件", items: [
                "UILabel 的用法",
                "UIButtin 的用法",
                "UITextField 的用法"
                ]),
            XMSection(header: "高级控件", items: [
                "UITableView 的用法",
                "UICollectionView 的用法"
                ]),
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedAnimatedDataSource<XMSection>(configureCell: {
            dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell_id", for: indexPath)
            cell.textLabel?.text = "\(indexPath.row): \(item)"
            return cell
        },
        titleForHeaderInSection: { dataSource, index in
            return dataSource.sectionModels[index].header
        },
        titleForFooterInSection: { dataSource, index in
            return "共有\(dataSource[index].items.count)个控件"
        })
        
        self.dataSource = dataSource
        
        // 绑定单元格数据
        sections.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        // 设置代理
        tableView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

// MARK: - UITableViewDelegate
extension RxDataSourcesWithHeaderController: UITableViewDelegate {
    // 设置单元格高度
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = dataSource?[indexPath], let _ = dataSource?[indexPath.section] else {
            return 0.0
        }
        return 60
    }
    
    // 设置分区头的高度
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    // 是分区头部视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .black
        let titleLabel = UILabel()
        titleLabel.text = self.dataSource?[section].header
        titleLabel.textColor = .white
        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: view.bounds.width / 2, y: 20)
        headerView.addSubview(titleLabel)
        return headerView
    }
}

struct XMSection {
    var header: String
    var items: [Item]
}

extension XMSection: AnimatableSectionModelType {
    
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: XMSection, items: [Item]) {
        self = original
        self.items = items
    }
}
