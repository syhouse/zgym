//
//  YXSButton.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/4.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNight898F9A), forState: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
