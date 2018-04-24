//
//  RxDS_DIYCollectionViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/24.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class RxDS_DIYCollectionViewController: BaseViewController {

    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 定义布局
        let flowLayout = UICollectionViewFlowLayout()
        
        // 创建集合视图
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell_id")
        view.addSubview(collectionView)
        
        // 初始化数据
        let items = Observable.just([SectionModel(model: "",
                                                  items: ["Swift",
                                                          "Python",
                                                          "PHP",
                                                          "Ruby",
                                                          "Java",
                                                          "C++",
                                                          "OC"])])
        
        // 创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, String>>(configureCell: { (dataSource, collectionView, indexPath, element) -> UICollectionViewCell in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        })
        
        // 绑定单元格数据
        items.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
        // 设置代理
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
}

extension RxDS_DIYCollectionViewController: UICollectionViewDelegateFlowLayout {
    // 设置单元格大小
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let cellWidth = (width - 30) / 4
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
}
