//
//  YXSXMCommonFooterView.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/27.
//  Copyright © 2020 zgym. All rights reserved.
//


import UIKit
import NightNight

class YXSXMCommonFooterView: UICollectionReusableView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(midLabel)
        addSubview(leftLine)
        addSubview(rightLine)
        
        midLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self)
        }
        leftLine.snp.makeConstraints { (make) in
            make.right.equalTo(midLabel.snp_left).offset(-4)
            make.centerY.equalTo(midLabel)
            make.size.equalTo(CGSize.init(width: 25.5, height: 0.5))
        }
        
        rightLine.snp.makeConstraints { (make) in
            make.left.equalTo(midLabel.snp_right).offset(4)
            make.centerY.equalTo(midLabel)
            make.size.equalTo(CGSize.init(width: 25.5, height: 0.5))
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    lazy var midLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.yxs_hexToAdecimalColor(hex: "#AAB1BC")
        label.text = "没有更多了"
        return label
    }()
    
    lazy var leftLine: UIView = {
       let leftLine = UIView()
        leftLine.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDD9")
        return leftLine
    }()
    
    lazy var rightLine: UIView = {
       let rightLine = UIView()
        rightLine.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDD9")
        return rightLine
    }()
    
}
