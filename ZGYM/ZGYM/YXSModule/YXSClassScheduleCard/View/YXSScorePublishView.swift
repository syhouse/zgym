//
//  YXSScorePublishView.swift
//  ZGYM
//
//  Created by yihao on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import NightNight

class YXSScorePublishView: YXSBasePopingView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        lbTitle.isHidden = true
        self.addSubview(imgBgTop)
        self.addSubview(tvContent)
        self.addSubview(btnDone)
        imgBgTop.snp.makeConstraints { (make) in
            make.top.left.right.bottom.equalTo(0)
//            make.width.equalTo(260*SCREEN_SCALE)
//            make.height.equalTo(305*SCREEN_SCALE)
        }
        btnDone.snp.makeConstraints { (make) in
            make.centerX.equalTo(imgBgTop.snp_centerX)
            make.bottom.equalTo(imgBgTop.snp_bottom).offset(-30)
            make.width.equalTo(50)
            make.height.equalTo(20)
        }
        tvContent.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(btnDone.snp_top).offset(-15)
            make.top.equalTo(imgBgTop.snp_centerY)
        }
        let text = NSMutableAttributedString(string: "发布成绩可以通过在电脑上操作输入www.xxxxx.com进行快捷发布哦。")
        text.yy_setTextHighlight(NSRange.init(location: 0, length: 16), color: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), backgroundColor: nil, tapAction: nil)
        text.yy_setTextHighlight(NSRange(location: 16, length: 13), color: UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), backgroundColor: nil) { [weak self](view, str, range, rect) in
            guard let weakSelf = self else {return}
        
        }
        text.yy_setTextHighlight(NSRange.init(location: 29, length: 8), color: UIColor.yxs_hexToAdecimalColor(hex: "#222222"), backgroundColor: nil, tapAction: nil)
        text.yy_font = UIFont.systemFont(ofSize: 16)
        tvContent.attributedText = text
        
        
        self.snp.remakeConstraints({ (make) in
            make.centerX.equalTo(self.panelView.snp_centerX)
            make.centerY.equalTo(self.panelView.snp_centerY).offset(0)
        })
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Action
    @objc func btnDoneClick(sender: YXSButton) {
        cancelClick()
    }
    
    // MARK: - LazyLoad
    lazy var imgBgTop: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "yxs_publish_score_popoverIcon")
        return img
    }()
    lazy var tvContent: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.backgroundColor = UIColor.clear
        tv.font = UIFont.systemFont(ofSize: 16)
        return tv
    }()
    lazy var btnDone: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("知道了", for: .normal)
        btn.setTitleColor(UIColor.yxs_hexToAdecimalColor(hex: "#5E88F7"), for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.addTarget(self, action: #selector(btnDoneClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
}
