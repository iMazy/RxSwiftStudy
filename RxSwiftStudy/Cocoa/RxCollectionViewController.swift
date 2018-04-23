//
//  RxCollectionViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/21.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class RxCollectionViewController: BaseViewController {

    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 定义布局方式以及单元格大小
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        
        // 创建几何视图
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        
        // 注册单元格
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell_id")
        view.addSubview(collectionView)
        
        // 初始化单元格数据
        let items = Observable.just(["Swift", "Python", "PHP", "Ruby", "Java", "C++", "OC"])
        
        // 设置单元格数据
        items.bind(to: collectionView.rx.items) { collectionView, row, element in
            let indexPath = IndexPath(item: row, section: 0)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(row): \(element)"
            return cell
        }.disposed(by: disposeBag)
        
        // 单元格选中事件响应
        collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
            print("选中项的indexPath为: \(indexPath)")
        }).disposed(by: disposeBag)
        
        // 获取选中项的内容
        collectionView.rx.modelSelected(String.self).subscribe(onNext: { item in
            print("选中项的内容是: \(item)")
        }).disposed(by: disposeBag)
        
        // 同时获取选中项的索引和内容
        Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(String.self)).bind { indexPath, item in
            print("~选中项的indexPath为: \(indexPath)")
            print("~选中项的内容是: \(item)")
        }.disposed(by: disposeBag)
        
        // 单元格取消选中事件响应
        // 获取被取消选中的单元格的索引
        collectionView.rx.itemDeselected.subscribe(onNext: { indexPath in
            print("被取消选中项的indexPath: \(indexPath)")
        }).disposed(by: disposeBag)
        
        // 获取被取消选中的单元格的内容
        collectionView.rx.modelDeselected(String.self).subscribe(onNext: { item in
            print("被取消选中项的内容: \(item)")
        }).disposed(by: disposeBag)
        
        // 同时获取被取消选中项的索引和内容
        Observable.zip(collectionView.rx.itemDeselected, collectionView.rx.modelDeselected(String.self)).bind { indexPath, item in
            print("~被取消选中项的indexPath: \(indexPath)")
            print("~被取消选中项的内容: \(item)")
        }.disposed(by: disposeBag)
        
        // 单元格高亮完成后的事件响应
        collectionView.rx.itemHighlighted.subscribe(onNext: { indexPath in
            print("高亮单元格的indexPath: \(indexPath)")
        }).disposed(by: disposeBag)
        
        // 高亮转成非高亮完成的事件响应
        collectionView.rx.itemUnhighlighted.subscribe(onNext: { indexPath in
            print("高亮转正常单元格的indexPath: \(indexPath)")
        }).disposed(by: disposeBag)
        
        // 单元格将要显示出来的事件响应
        collectionView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
            print("将要显示的单元格 indexPath: \(indexPath)")
            print("将要显示单元格的 cell: \(cell)")
        }).disposed(by: disposeBag)
        
        // 分区头部、尾部将要显示出来的事件响应
        collectionView.rx.willDisplaySupplementaryView.subscribe(onNext: { view, kind, indexPath in
            print("将要显示分区indexPath: \(indexPath)")
            print("将要显示的头部或者尾部类型: \(kind)")
            print("将要显示头部或尾部视图: \(view)")
        }).disposed(by: disposeBag)
    }

}


class MyCollectionViewCell: UICollectionViewCell {
    
    var label: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .orange
        
        label.frame = frame
        label.textAlignment = .center
        label.textColor = .white
        contentView.addSubview(label)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
