//
//  SLBottomButton.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/3/5.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit
import NightNight

/// 家长端作业详情底部按钮
class YXSBottomBtnView: UIView {
    
    init() {
        super.init(frame: CGRect.zero)
        
        self.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightBackgroundColor)
        
        self.addSubview(btnCommit)
        self.addSubview(topLineView)
        btnCommit.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(42)
        })
        topLineView.snp.makeConstraints({ (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(0.5)
        })
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LazyLoad
    lazy var btnCommit: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("去提交", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        btn.setMixedTitleColor(MixedColor(normal: kNightFFFFFF, night: kNightFFFFFF), forState: .normal)
//        btn.yxs_gradualBackground(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 21)
//        btn.yxs_shadow(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH - 30, height: 42), color: UIColor.gray, cornerRadius: 21, offset: CGSize(width: 4, height: 4))
        btn.layer.cornerRadius = 21
        return btn
    }()

    lazy var topLineView: UIView = {
        let topLineView = UIView()
        topLineView.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), night: kNight2F354B)
        return topLineView
    }()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
