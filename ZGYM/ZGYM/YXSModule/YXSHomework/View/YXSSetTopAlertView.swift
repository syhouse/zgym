//
//  YXSSetTopAlertView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/25.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSSetTopAlertView: UIView {

        var complete: ((_ sender: YXSButton)->())?
    var topButtonTitle: String
        @discardableResult static func showIn(target: UIView,topButtonTitle: String = "置顶", complete:((_ sender: YXSButton)->())?) -> YXSSetTopAlertView{
            let view = YXSSetTopAlertView(topButtonTitle: topButtonTitle)
            view.complete = complete
            
            target.addSubview(view.panelView)
            view.panelView.snp.makeConstraints({ (make) in
                make.edges.equalTo(0)
            })
            return view
        }
        
        init(topButtonTitle: String) {
            self.topButtonTitle = topButtonTitle
            super.init(frame: CGRect.zero)
            
            self.addSubview(self.btnCancel)
            self.addSubview(self.btnSetTop)
            
            self.panelView.addSubview(self)
            self.snp.makeConstraints({ (make) in
                make.bottom.equalTo(self.panelView.snp_bottom).offset(-kSafeBottomHeight)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(105)
            })
            
            layout()
        }
        
        required init?(coder: NSCoder) {
                fatalError("init(coder:) has not been implemented")
        }
            
        func layout() {
            
            self.btnCancel.snp.makeConstraints({ (make) in
                make.bottom.equalTo(0)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(50)
            })
            
            self.btnSetTop.snp.makeConstraints({ (make) in
                make.bottom.equalTo(self.btnCancel.snp_top)
                make.left.equalTo(0)
                make.right.equalTo(0)
                make.height.equalTo(55)
            })
        }
            
            // MARK: - Action
            @objc func setTopClick(sender: YXSButton) {
                self.complete?(sender)
                self.panelView.removeFromSuperview()
            }
            
            @objc func cancelClick(_ sender: YXSButton = YXSButton()) {
                self.complete?(sender)
                self.panelView.removeFromSuperview()
            }
            
            // MARK: - LazyLoad
            lazy var btnCancel: YXSButton = {
                let btn = YXSButton()
                btn.setTitle("取消", for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                btn.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
                btn.setMixedTitleColor(MixedColor(normal: kNight5E88F7, night: kNight898F9A), forState: .normal)
                btn.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
                return btn

            }()
            
            lazy var btnSetTop: YXSButton = {
                let btn = YXSButton()
                btn.setTitle(topButtonTitle, for: .normal)
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
                btn.mixedBackgroundColor = MixedColor(normal: kNightFFFFFF, night: kNight383E56)
                btn.setMixedTitleColor(MixedColor(normal: k575A60Color, night: kNightFFFFFF), forState: .normal)
                btn.addTarget(self, action: #selector(setTopClick(sender:)), for: .touchUpInside)
                btn.yxs_addLine(position: LinePosition.bottom, color: UIColor.yxs_hexToAdecimalColor(hex: "#F2F5F9"), leftMargin: 0, rightMargin: 0, lineHeight: 5)
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
