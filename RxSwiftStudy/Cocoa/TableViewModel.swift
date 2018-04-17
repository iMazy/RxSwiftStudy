//
//  TableViewModel.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/17.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit

enum TableEditingCommand {
    case setItems(items: [String]) // 设置表格数据
    case addItem(item: String) // 添加数据
    case moveItem(from: IndexPath, to: IndexPath) // 移动数据
    case deleteItem(IndexPath) // 删除数据
}

struct TableViewModel {
    
    // 表格数据项
    var items: [String]
    
    init(items: [String] = []) {
        self.items = items
    }
    
    func execute(command: TableEditingCommand) -> TableViewModel {
        switch command {
        case .setItems(let items): // 设置表格数据
            return TableViewModel(items: items)
        case .addItem(let item): // 新增数据源
            var _items = self.items
            _items.append(item)
            return TableViewModel(items: _items)
        case .moveItem(let from, let to): // 移动数据源
            var _items = self.items
            _items.insert(_items.remove(at: from.row), at: to.row)
            return TableViewModel(items: _items)
        case .deleteItem(let indexPath): // 删除数据源
            var _items = self.items
            _items.remove(at: indexPath.row)
            return TableViewModel(items: _items)
        }
    }
}
