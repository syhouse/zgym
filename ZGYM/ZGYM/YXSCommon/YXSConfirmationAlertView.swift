//
//  ConfirmationAlertView.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/22.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

/// 带标题副标题/确认/取消 的弹窗
class YXSConfirmationAlertView: UIView {
    
    var complete: ((_ sender: UIButton,_ view: YXSConfirmationAlertView)->())?
    var hasCancel: Bool!
    static func showIn(target: UIView, hasCancel:Bool = true, complete:((_ sender: UIButton, _ view: YXSConfirmationAlertView)->())?) -> YXSConfirmationAlertView{
        let view = YXSConfirmationAlertView(hasCancel: hasCancel)
        view.complete = complete
        view.hasCancel = hasCancel
        
        target.addSubview(view.panelView)
        view.panelView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
        return view
    }
    
    init(hasCancel:Bool) {
        super.init(frame: CGRect.zero)
        self.hasCancel = hasCancel
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight383E56)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        
        self.addSubview(self.lbTitle)
        self.addSubview(self.lbContent)
        self.addSubview(self.btnDone)
        if hasCancel {
            self.addSubview(self.btnCancel)
        }
        
        self.panelView.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.centerX.equalTo(panelView.snp_centerX)
            make.centerY.equalTo(panelView.snp_centerY).offset(-30)
            make.width.equalTo(260)
        })
        
        layout()
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
        
    func layout() {
        self.lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(24)
            make.left.equalTo(self.snp_left).offset(0)
            make.right.equalTo(self.snp_right).offset(0)
        })
        
        self.lbContent.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lbTitle.snp_bottom).offset(24)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        })
        
        if hasCancel {
            self.btnCancel.snp.makeConstraints({ (make) in
                make.top.equalTo(lbContent.snp_bottom).offset(20)
                make.bottom.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(self.btnDone.snp_left)
                make.width.equalTo(130)
                make.height.equalTo(49)
            })
                
            
            self.btnDone.snp.makeConstraints({ (make) in
                make.bottom.equalTo(0)
                make.left.equalTo(self.btnCancel.snp_right)
                make.right.equalTo(0)
                make.width.equalTo(130)
                make.height.equalTo(49)
            })
            
        } else {
            self.btnDone.snp.makeConstraints({ (make) in
                make.top.equalTo(lbContent.snp_bottom).offset(20)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.bottom.equalTo(0)
                make.height.equalTo(49)
            })
        }
    }
        
        // MARK: - Action
        @objc private func doneClick(sender: UIButton) {
            self.complete!(sender, self)
        }
        
        @objc private func cancelClick(sender: UIButton) {
            close()
            self.complete!(sender, self)
        }
    
        @objc func close() {
            self.panelView.removeFromSuperview()
        }
        
        // MARK: - LazyLoad
        lazy var lbTitle: YXSLabel = {
            let lb = YXSLabel()
            lb.mixedTextColor = MixedColor(normal: 0x000000, night: 0xffffff)
            lb.text = "提示"
            lb.font = UIFont.systemFont(ofSize: 17)
            lb.textAlignment = .center
            return lb
        }()
        
    
        lazy var lbContent: YXSLabel = {
            let lb = YXSLabel()
            lb.mixedTextColor = MixedColor(normal: 0x727478, night: 0xffffff)
            lb.text = ""
            lb.numberOfLines = 0
            lb.font = UIFont.systemFont(ofSize: 15)
            lb.textAlignment = .center
            return lb
        }()
    
        lazy var btnCancel: UIButton = {
            let btn = UIButton()
            btn.setTitle("取消", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x383E56)
            btn.setMixedTitleColor(MixedColor(normal: 0x797B7E, night: 0xBCC6D4), forState: .normal)
            btn.addTarget(self, action: #selector(cancelClick(sender:)), for: .touchUpInside)
            btn.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
            btn.yxs_addLine(position: LinePosition.right, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
            return btn

        }()
        
        lazy var btnDone: UIButton = {
            let btn = UIButton()
            btn.setTitle("确认", for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            btn.mixedBackgroundColor = MixedColor(normal: 0xffffff, night: 0x383E56)
            btn.setMixedTitleColor(MixedColor(normal: 0x5E88F7, night: 0xBCC6D4), forState: .normal)
            btn.addTarget(self, action: #selector(doneClick(sender:)), for: .touchUpInside)
            btn.yxs_addLine(position: LinePosition.top, color: UIColor.yxs_hexToAdecimalColor(hex: "#E6EAF3"), leftMargin: 0, rightMargin: 0, lineHeight: 0.5)
            return btn
        }()
        
        lazy var panelView: UIView = {
            let mask = UIView()
            mask.backgroundColor = UIColor(white: 0.252, alpha: 0.7)
            return mask
        }()
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
