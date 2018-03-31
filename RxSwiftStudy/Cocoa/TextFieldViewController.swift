//
//  TextFieldViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/3/31.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift

class TextFieldViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建文本输入框
        let codeLabel = UILabel(frame: CGRect(x: 10, y: 80, width: 50, height: 30))
        codeLabel.text = "区号:"
        codeLabel.textAlignment = .right
        let inputField1 = UITextField(frame: CGRect(x: 70, y: 80, width: 200, height: 30))
        inputField1.borderStyle = UITextBorderStyle.roundedRect
        view.addSubview(codeLabel)
        view.addSubview(inputField1)
        
        // 创建文本输出框
        let numberLabel = UILabel(frame: CGRect(x: 10, y: 150, width: 50, height: 30))
        numberLabel.text = "号码:"
        numberLabel.textAlignment = .right
        let inputField2 = UITextField(frame: CGRect(x: 70, y:150, width:200, height:30))
        inputField2.borderStyle = UITextBorderStyle.roundedRect
        view.addSubview(inputField2)
        view.addSubview(numberLabel)
        
        // 创建文本标签
        let label = UILabel(frame:CGRect(x: 20, y: 200, width: 300, height: 30))
        view.addSubview(label)
        
        Observable.combineLatest(inputField1.rx.text.orEmpty, inputField2.rx.text.orEmpty) {
            textValue1, textValue2 -> String in
                return "你输入的号码是: \(textValue1)-\(textValue2)"
            }.map{ $0 }
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        //
        /// 事件监听
        //（1）通过 rx.controlEvent 可以监听输入框的各种事件，且多个事件状态可以自由组合。除了各种 UI 控件都有的 touch 事件外，输入框还有如下几个独有的事件：
        // - editingDidBegin：开始编辑（开始输入内容）
        // - editingChanged：输入内容发生改变
        // - editingDidEnd：结束编辑
        // - editingDidEndOnExit：按下 return 键结束编辑
        // - allEditingEvents：包含前面的所有编辑相关事件

        
        inputField1.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: {
            print("开始编辑")
        }).disposed(by: disposeBag)
        
        inputField1.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: {
            inputField2.becomeFirstResponder()
        }).disposed(by: disposeBag)
        
        inputField2.rx.controlEvent([.editingDidEndOnExit]).subscribe(onNext: {
            inputField2.resignFirstResponder()
        }).disposed(by: disposeBag)
    }

    func bindToOtherKit() {
        // 创建文本输入框
        let inputField = UITextField(frame: CGRect(x:10, y:80, width:200, height:30))
        inputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(inputField)
        
        // 创建文本输出框
        let outputField = UITextField(frame: CGRect(x:10, y:150, width:200, height:30))
        outputField.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(outputField)
        
        // 创建文本标签
        let label = UILabel(frame:CGRect(x:20, y:190, width:300, height:30))
        self.view.addSubview(label)
        
        // 创建按钮
        let button:UIButton = UIButton(type:.system)
        button.frame = CGRect(x:20, y:230, width:40, height:30)
        button.setTitle("提交", for:.normal)
        self.view.addSubview(button)
        
        // 当文本框内容发生改变时,
        let input = inputField.rx.text
            .orEmpty
            .asDriver() // 将普通序列转换为 Driver
            .throttle(0.3) // 在主线程中操作，0.3秒内值若多次改变，取最后一次
        
        // 将内容绑定到另一个输入框中
        input.drive(outputField.rx.text).disposed(by: disposeBag)
        
        // 内容绑定到文本便签中
        input.map({ "当前字数: \($0.count)" })
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        // 根据内容字数决定按钮是否可以点击
        input.map({ $0.count > 5 })
            .drive(button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    func beseBindForTextField()  {
        // 创建文本输入框
        let textField = UITextField(frame: CGRect(x: 20, y: 80, width: 200, height: 30))
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        
        // 当文本框内容发生改变时, 将内容输出到控制台
        textField.rx.text.orEmpty.asObservable().subscribe(onNext: {
            print("你输入的是: \($0)")
        }).disposed(by: disposeBag)
        
        
        // 第二种方式
        textField.rx.text.orEmpty.changed.subscribe(onNext: {
            print("你输入的是1: \($0)")
        }).disposed(by: disposeBag)
    }
    
    /// UITextView 独有的方法
    //（1）UITextView 还封装了如下几个委托回调方法：
    // - didBeginEditing：开始编辑
    // - didEndEditing：结束编辑
    // - didChange：编辑内容发生改变
    // - didChangeSelection：选中部分发生变化
    func textViewEditingAction() {
        let textView = UITextView()
        textView.rx.didBeginEditing.subscribe(onNext: {
            print("开始编辑")
        }).disposed(by: disposeBag)
        
        textView.rx.didEndEditing.subscribe(onNext: {
            print("结束编辑")
        }).disposed(by: disposeBag)
        
        textView.rx.didChange.subscribe(onNext: {
            print("内容发生改变")
        }).disposed(by: disposeBag)
        
        textView.rx.didChangeSelection.subscribe(onNext: {
            print("选中部分发生改变")
        }).disposed(by: disposeBag)
    }
}






