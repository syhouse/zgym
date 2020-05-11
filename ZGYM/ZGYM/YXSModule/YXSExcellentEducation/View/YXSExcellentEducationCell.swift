//
//  YXSExcellentEducationCell.swift
//  ZGYM
//
//  Created by yihao on 2020/4/20.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSExcellentEducationCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(backgroundImageV)
        contentView.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightForegroundColor)
        backgroundImageV.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.width.equalTo(SCREEN_WIDTH - 30)
            make.height.equalTo(110)
            make.bottom.equalTo(0)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    lazy var backgroundImageV: UIImageView = {
        let imgV = UIImageView()
        return imgV
    }()
    
}
