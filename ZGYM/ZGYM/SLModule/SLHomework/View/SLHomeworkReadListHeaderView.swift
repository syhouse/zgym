//
//  SLHomeworkReadListHeaderView.swift
//  ZGYM
//
//  Created by sl_mac on 2019/11/25.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class HomeworkReadCommitListHeaderViewModel: NSObject {
    var percent: CGFloat = 0.0
    var title: String?
    var fristTitle: String?
    var secondTitle: String?
}

/// 阅读列表头部
class HomeworkReadCommitListHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        let cl = NightNight.theme == .night ? kNightBackgroundColor : kTableViewBackgroundColor
        self.sl_addLine(position: .bottom, color: cl, leftMargin: 0, rightMargin: 0, lineHeight: 10)
        
        self.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNightForegroundColor)
        self.addSubview(self.progressView)
        self.addSubview(self.lbPercent)
        self.addSubview(self.lbType)
        self.addSubview(self.btnDot1)
        self.addSubview(self.btnDot2)
        self.addSubview(self.lbTitle1)
        self.addSubview(self.lbTitle2)
        
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var model: HomeworkReadCommitListHeaderViewModel? {
        didSet {
            if self.model?.percent != nil {
                self.lbPercent.text = "\(Int((self.model?.percent ?? 0)*100))%"
                progressView.progress = self.model?.percent ?? 0.0
            }
            self.lbType.text = self.model?.title ?? ""
            self.lbTitle1.text = self.model?.fristTitle ?? ""
            self.lbTitle2.text = self.model?.secondTitle ?? ""
        }
    }
    
    func layout() {
        self.progressView.snp.makeConstraints({ (make) in
            make.top.equalTo(30)
            make.centerX.equalTo(self.snp_centerX)
            make.width.height.equalTo(125)
        })
        
        self.lbPercent.snp.makeConstraints({ (make) in
            make.top.equalTo(73)
            make.centerX.equalTo(snp_centerX)
        })
        
        self.lbType.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbPercent.snp_bottom).offset(6)
            make.centerX.equalTo(snp_centerX)
        })
        
        self.lbTitle1.snp.makeConstraints({ (make) in
            make.bottom.equalTo(-28)
            make.right.equalTo(snp_centerX).offset(-14)
        })
        
        
        self.btnDot1.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.lbTitle1.snp_centerY)
            make.right.equalTo(self.lbTitle1.snp_left).offset(-10)
            make.width.height.equalTo(12)
        })
        
        
        self.btnDot2.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.lbTitle1.snp_centerY)
            make.left.equalTo(self.snp_centerX).offset(20)
            make.width.height.equalTo(12)
        })
        
        
        self.lbTitle2.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.lbTitle1.snp_bottom)
            make.left.equalTo(self.btnDot2.snp_right).offset(6)
        })
    }
    
    // MARK: - LazyLoad
    lazy var lbPercent: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: k575A60Color, night: k575A60Color)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 21)
        return lb
    }()
    
    ///
    lazy var lbType: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: 0xC4CDDA, night: 0xC4CDDA)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var btnDot1: SLButton = {
        let btn = SLButton()
        btn.mixedBackgroundColor = MixedColor(normal: 0x5E88F7, night: 0x5E88F7)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 6
        return btn
    }()
    
    lazy var btnDot2: SLButton = {
        let btn = SLButton()
        btn.mixedBackgroundColor = MixedColor(normal: 0xE6EAF3, night: 0xE6EAF3)
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 6
        return btn
    }()
    
    lazy var lbTitle1: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNightBCC6D4)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var lbTitle2: SLLabel = {
        let lb = SLLabel()
        lb.mixedTextColor = MixedColor(normal: kNight898F9A, night: kNightBCC6D4)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var progressView: SLCirleProgressView = {
        let progress = SLCirleProgressView()
        progress.excircleLineWith = 9
        progress.isShowTitle = false
        progress.isShowRestColor = true
        progress.foregroundColor = UIColor.sl_hexToAdecimalColor(hex: "#5E88F7")
        progress.restColor = UIColor.sl_hexToAdecimalColor(hex: "#E6EAF3")
        progress.progress = 0.0
        return progress
    }()
}
