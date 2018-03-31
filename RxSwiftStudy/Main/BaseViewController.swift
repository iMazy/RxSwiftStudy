//
//  BaseViewController.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/3/31.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseViewController: UIViewController {
    
    /// ARC & Rx 垃圾回收
    let disposeBag = DisposeBag()
}
