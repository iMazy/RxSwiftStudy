//
//  RxDataSourcesCollectionController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/23.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class RxDataSourcesCollectionController: BaseViewController {

    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 定义布局和大小
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        
        flowLayout.headerReferenceSize = CGSize(width: view.bounds.width, height: 40)
        
        // 初始化collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        
        // 注册单元格
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell_id")
        
        collectionView.register(CustomSectionHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "section_id")
        
        view.addSubview(collectionView)
        
        // 初始化数据
        let items = Observable.just([
                SectionModel(model: "脚本语言", items: ["Python", "JavaScript", "PHP"]),
                SectionModel(model: "高级语言", items: ["Swift","Java", "C++", "C#"])
            ])
        
        // 自定义的sectionModel
//        let _ = Observable.just([CustomSection(header: "", items: ["Swift", "Python", "PHP", "Ruby", "Java", "C++", "OC"])])
        
        // 创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, collectionView, indexPath, element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        }, configureSupplementaryView: { (dataSource, collectionView, kind, indexPath) in
            let section = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "section_id", for: indexPath) as! CustomSectionHeader
            section.label.text = "\(dataSource[indexPath.section].model)"
            return section
            
        })
        
        // 绑定单元格数据
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }

    
    // 单个section
    func singleSectionCollectionView() {
        // 定义布局和大小
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        
        // 初始化collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        
        // 注册单元格
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell_id")
        view.addSubview(collectionView)
        
        // 初始化数据
        let items = Observable.just([SectionModel(model: "", items: ["Swift", "Python", "PHP", "Ruby", "Java", "C++", "OC"])])
        
        // 自定义的sectionModel
        let _ = Observable.just([CustomSection(header: "", items: ["Swift", "Python", "PHP", "Ruby", "Java", "C++", "OC"])])
        
        // 创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, collectionView, indexPath, element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        })
        
        // 绑定单元格数据
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
}

class CustomSectionHeader: UICollectionReusableView {
    
    var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        label = UILabel(frame: frame)
        label.textColor = .white
        label.textAlignment = .center
        addSubview(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
}


// 自定义 section
struct CustomSection {
    var header: String
    var items: [Item]
}

extension CustomSection: AnimatableSectionModelType {
    
    
    typealias Item = String
    
    typealias Identity = String
    
    var identity: String {
        return header
    }
    
    init(original: CustomSection, items: [String]) {
        self = original
        self.items = items
    }
}

