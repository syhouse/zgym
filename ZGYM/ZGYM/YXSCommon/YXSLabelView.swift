//
//  SLPunchCardItemView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/28.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

/// 颜色标签label
class YXSLabelView: UIView{
    var color: UIColor
    var title: String
    init(_ color: UIColor = kBlueColor, title: String){
        self.color = color
        self.title = title
        super.init(frame: CGRect.zero)
        
        addSubview(leftView)
        addSubview(titleLabel)
        leftView.snp.makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(self)
            make.size.equalTo(CGSize.init(width: 6, height: 16.5))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(leftView.snp_right).offset(10.5)
            make.right.equalTo(0)
            make.top.equalTo(0)
            make.bottom.equalTo(0).priorityHigh()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var leftView: UIView = {
        let imageView = UIView()
        imageView.backgroundColor = color
        imageView.cornerRadius = 2
        return imageView
    }()
    
    lazy var titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kTextMainBodyColor)
        label.text = title
        return label
    }()
    
}
