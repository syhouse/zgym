//
//  SLHomeTableSectionView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

///首页时间(今天、更早的)
class YXSHomeTableSectionView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(yxs_label)
        yxs_label.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(18.5)
        }
    }
    
    func setSectionModel(_ model: YXSHomeSectionModel){
        yxs_label.text = model.showText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var yxs_label: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
//        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: UIColor.yxs_hexToAdecimalColor(hex: "#858E9C"))
        label.mixedTextColor = MixedColor(normal: UIColor.white, night: UIColor.white)
        return label
    }()
}
