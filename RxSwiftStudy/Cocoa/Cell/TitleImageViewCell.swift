//
//  TitleImageViewCell.swift
//  RxSwiftStudy
//
//  Created by Mazy on 2018/4/20.
//  Copyright © 2018年 Happy Iterating Inc. All rights reserved.
//

import UIKit

class TitleImageViewCell: UITableViewCell {

    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
