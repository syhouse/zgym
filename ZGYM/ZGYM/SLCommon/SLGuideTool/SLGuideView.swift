//
//  SLGuideView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2020/1/3.
//  Copyright © 2020 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight


/// 首页logo指引试图(logo 标题 内容)
class SLGuideView: UIView {
    var title: String
    var desTitle: String
    var icon: String
    init(title: String,desTitle: String, icon: String = "sl_logo") {
        self.title = title
        self.desTitle = desTitle
        self.icon = icon
        super.init(frame: CGRect.zero)
        self.cornerRadius = 15
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        
        addSubview(titleLabel)
        addSubview(desLabel)
        addSubview(iconImageView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(17)
            make.top.equalTo(19)
        }
        desLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.right.equalTo(-103)
            make.top.equalTo(46)
            make.bottom.equalTo(-19)
        }
        iconImageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(self)
            make.right.equalTo(-17)
            make.width.height.equalTo(58)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: UIColor.white)
        label.text = title
        return label
    }()
    
    lazy var desLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        label.text = desTitle
        label.numberOfLines = 0
        return label
    }()
    
    lazy var iconImageView: UIImageView = {
        let iconImageView = UIImageView.init(image: UIImage.init(named: icon))
        iconImageView.cornerRadius = 5
        return iconImageView
    }()
}


