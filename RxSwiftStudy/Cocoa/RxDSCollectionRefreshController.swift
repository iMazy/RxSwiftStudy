//
//  RxDataSourcesCollectionRefreshController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/24.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class RxDSCollectionRefreshController: BaseViewController {

    var refreshButton: UIBarButtonItem = UIBarButtonItem()
    var cancelButton: UIBarButtonItem = UIBarButtonItem()
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshButton.title = "刷新"
        navigationItem.rightBarButtonItem = refreshButton
        cancelButton.title = "取消"
        navigationItem.leftBarButtonItem = cancelButton
        
        // 定义布局及单元格大小
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 100, height: 70)
        
        // 初始化collectionView
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .white
        collectionView.register(MyCollectionViewCell.self, forCellWithReuseIdentifier: "cell_id")
        view.addSubview(collectionView)
        
        // 随机的表格数据
        let randomResult = refreshButton.rx.tap.asObservable()
            .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
            .startWith(())  //加这个为了让一开始就能自动请求一次数据
            .flatMapLatest({
                self.getRandomResult().takeUntil(self.cancelButton.rx.tap)
            })
            .share(replay: 1)
        
        // 创建数据源
        let dataSource = RxCollectionViewSectionedReloadDataSource<SectionModel<String, Int>>(configureCell: { (dataSource, collectionView, indexPath, element) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_id", for: indexPath) as! MyCollectionViewCell
            cell.label.text = "\(element)"
            return cell
        })
        
        // 绑定单元格数据
        randomResult.bind(to: collectionView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    /// 获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        let items = (0..<5).map { _ in
            Int(arc4random_uniform(100000))
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }
}
