//
//  RxDS_PickerViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/24.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources

class RxDS_PickerViewController: BaseViewController {

    var pickerView: UIPickerView!
    
    // 最简单的pickerView适配器 (显示普通文本)
    private let stringPickerAdapter = RxPickerViewStringAdapter<[String]>(
        components: [],
        numberOfComponents: { (_, _, _) in 1 },
        numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count
        },
        titleForRow: { (_, _, items, row, _)  -> String? in
            return items[row]
    })
    
    private let multiStringPickerAdapter = RxPickerViewStringAdapter<[[String]]>(
        components: [],
        numberOfComponents: { (dataSource, pickerView, components) in components.count },
        numberOfRowsInComponent: { (_, _, components, component) -> Int in
            return components[component].count
        },
        titleForRow: { (_, _, components, row, component)  -> String? in
            return components[component][row]
    })
    
    //设置文字属性的pickerView适配器
    private let attrStringPickerAdapter = RxPickerViewAttributedStringAdapter<[String]>(
        components: [],
        numberOfComponents: { _,_,_  in 1 },
        numberOfRowsInComponent: { (_, _, items, _) -> Int in
            return items.count}
    ){ (_, _, items, row, _) -> NSAttributedString? in
        return NSAttributedString(string: items[row],
                                  attributes: [
                                    NSAttributedStringKey.foregroundColor: UIColor.orange, //橙色文字
                                    NSAttributedStringKey.underlineStyle:
                                        NSUnderlineStyle.styleDouble.rawValue, //双下划线
                                    NSAttributedStringKey.textEffect:
                                        NSAttributedString.TextEffectStyle.letterpressStyle
            ])
    }
    
    private let viewPickerAdapter = RxPickerViewViewAdapter<[UIColor]>(components: [], numberOfComponents: { (_, _, _) -> Int in
        1
    }, numberOfRowsInComponent: { (_, _, items, _) -> Int in
        return items.count
    }) { (_, _, items, row, _, view) -> UIView in
        let componentView = view ?? UIView()
        componentView.backgroundColor = items[row]
        return componentView
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建pickerView
        pickerView = UIPickerView()
        view.addSubview(pickerView)
        
        // 绑定pickerView数据
        Observable.just([["One", "Two", "Three"], ["A", "B", "C", "D"]])
            .bind(to: pickerView.rx.items(adapter: multiStringPickerAdapter))
            .disposed(by: disposeBag)
        
        // 建立一个按钮 点击是获取选择框被选择的索引
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.center = view.center
        button.backgroundColor = .blue
        button.setTitle("获取信息", for: .normal)
        
        // 按钮点击事件
        button.rx.tap.subscribe(onNext: { [weak self] in
            self?.getMultiPickerViewValue()
        }).disposed(by: disposeBag)
        
        view.addSubview(button)
        
    }
    
    func getPickerViewValue() {
        let message = String(pickerView.selectedRow(inComponent: 0))
        let alertVC = UIAlertController(title: "被选中的索引为", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }

    func getMultiPickerViewValue() {
        let message = String(pickerView.selectedRow(inComponent: 0)) + "-" + String(pickerView.selectedRow(inComponent: 1))
        let alertVC = UIAlertController(title: "被选中的索引为", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alertVC, animated: true, completion: nil)
    }
    
    func diyPickerViewAdapter() {
        
    }
    
    func singleRowPicker() {
        // 创建pickerView
        pickerView = UIPickerView()
        view.addSubview(pickerView)
        
        // 绑定pickerView数据
        Observable.just(["One", "Two", "Three"])
            .bind(to: pickerView.rx.items(adapter: stringPickerAdapter))
            .disposed(by: disposeBag)
        
        // 建立一个按钮 点击是获取选择框被选择的索引
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        button.center = view.center
        button.backgroundColor = .blue
        button.setTitle("获取信息", for: .normal)
        
        // 按钮点击事件
        button.rx.tap.subscribe(onNext: { [weak self] in
            self?.getPickerViewValue()
        }).disposed(by: disposeBag)
        
        view.addSubview(button)
    }
}
