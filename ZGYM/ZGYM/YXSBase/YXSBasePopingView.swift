//
//  SLPopingView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/4.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSBasePopingView: UIView, UIGestureRecognizerDelegate {
    
    var complete: ((_ sender: UIButton)->())?
    /// 点击空白关闭
    var dismissWithTouchBlank: Bool = false
    
    func showIn(target: UIView){
        target.addSubview(panelView)
        panelView.snp.makeConstraints({ (make) in
            make.edges.equalTo(0)
        })
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.mixedBackgroundColor = MixedColor(normal: kTableViewBackgroundColor, night: kNight282C3B)
        self.clipsToBounds = true
        self.layer.cornerRadius = 15
        
        self.addSubview(self.lbTitle)
        self.lbTitle.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.height.equalTo(50)
            make.left.equalTo(self.snp_left).offset(0)
            make.right.equalTo(self.snp_right).offset(0)
        })
        
        self.panelView.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.centerX.equalTo(self.panelView.snp_centerX)
            make.centerY.equalTo(self.panelView.snp_centerY).offset(-88)
        })
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
        
    @objc func cancelClick(sender: UIButton? = nil) {
        self.panelView.removeFromSuperview()
    }
    
    @objc func blankClick(sender: UIButton?) {
        if dismissWithTouchBlank {
            cancelClick(sender: sender)
        }
    }
    
    private func layout() {
    }
    
    // MARK: - LazyLoad
    lazy var lbTitle: YXSLabel = {
        let lb = YXSLabel()
        lb.mixedTextColor = MixedColor(normal: k000000Color, night: kNightFFFFFF)
        lb.text = "提示"
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textAlignment = .center
        return lb
    }()
    
    /// 灰色蒙板
    lazy var panelView: UIView = {
        let mask = UIView()
        mask.mixedBackgroundColor = MixedColor(normal: UIColor(white: 0.1, alpha: 0.7), night: UIColor.yxs_hexToAdecimalColor(hex: "#383E56", alpha: 0.7))
        mask.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(blankClick(sender:)))
        tap.delegate = self
        mask.addGestureRecognizer(tap)
        return mask
    }()
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let p = touch.location(in: gestureRecognizer.view)
        if self.frame.contains(p) {
            return false
        } else {
            return true
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
