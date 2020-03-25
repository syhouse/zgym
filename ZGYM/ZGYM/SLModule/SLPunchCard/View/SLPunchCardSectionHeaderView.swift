//
//  SLPunchCardSectionHeaderView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/28.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLPunchCardSectionHeaderView: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(bgView)
        bgView.addSubview(labelView)
        contentView.backgroundColor = UIColor.sl_hexToAdecimalColor(hex: "#A5C8FF")
        
        bgView.snp.makeConstraints { (make) in
            make.left.equalTo(20.5)
            make.right.equalTo(-20.5)
            make.top.bottom.equalTo(0)
        }
        
        labelView.snp.makeConstraints { (make) in
            make.left.equalTo(15.5)
            make.centerY.equalTo(contentView)
        }
        bgView.sl_addLine(position: .bottom,mixedBackgroundColor: MixedColor(normal: kLineColor, night: kLineColor),leftMargin: 15.5, rightMargin: 15.5)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var labelView: HMLabelView = {
        let labelView = HMLabelView.init(title: "打卡详情")
        return labelView
    }()
    
    lazy var bgView: UIView = {
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        bgView.sl_addRoundedCorners(corners: [.topLeft,.topRight], radii: CGSize.init(width: 5, height: 5), rect: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 41, height: 56.5))
        return bgView
    }()
}
