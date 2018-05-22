//
//  SwitchViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/1.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class SwitchViewController: BaseViewController {

    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    @IBOutlet weak var activityView: UIActivityIndicatorView!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var stepper: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        slider.rx.value.subscribe(onNext: {
            print("当前slider值为: \($0)")
        }).disposed(by: disposeBag)
        
        
        stepper.rx.value.subscribe(onNext: {
            print("当前stepper值为: \($0)")
        }).disposed(by: disposeBag)
        
        /// slider 与 stepper 绑定
        // slider -> stepper
        slider.rx.value.map{ Double($0) }.bind(to: stepper.rx.value).disposed(by: disposeBag)
        
        // stepper -> slider
        stepper.rx.value.map{ Float($0) }
            .bind(to: slider.rx.value)
            .disposed(by: disposeBag)
    }
    
    func switchRx() {
        `switch`.rx.value
            .bind(to: activityView.rx.isAnimating)
            .disposed(by: disposeBag)
        
        `switch`.rx.isOn
            .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
    }
    
    func segmentControlRx()  {
        segmentControl.rx.selectedSegmentIndex.subscribe(onNext: {
            print("当前页: \($0)")
        }).disposed(by: disposeBag)
        
        segmentControl.rx.selectedSegmentIndex.asObservable().subscribe(onNext: {
            print("当前页1: \($0)")
        }).disposed(by: disposeBag)
    }
    
    func buttonRx() {
        /// 监听switch 的开和关
        `switch`.rx.isOn.asObservable().subscribe(onNext: {
            print("当前开关的状态: \($0)")
        }).disposed(by: disposeBag)
        
        /// 按钮和switch 之间的绑定
        `switch`.rx.isOn.bind(to: button.rx.isEnabled).disposed(by: disposeBag)
    }

}
