//
//  SLCommonAlertView.swift
//  EducationShop
//
//  Created by hnsl_mac on 2019/10/11.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class SLCommonAlertView: UIView {
    
    /// 全局弹出试图
    /// - Parameters:
    ///   - title: 标题   全黑粗体 17
    ///   - message: 消息 淡黑粗体 15
    ///   - leftTitle: 左边按钮标题
    ///   - leftTitleColor: 左边按钮颜色
    ///   - leftClick: 左边按钮点击回调
    ///   - rightTitle: 右边按钮标题
    ///   - rightClick: 右边按钮点击回调
    ///   - superView: 从哪个父视图展示 默认appdelegate root
    @discardableResult @objc static func showAlert(title: String = "", message: String = "", leftTitle: String = "取消",leftTitleColor: UIColor = UIColor.sl_hexToAdecimalColor(hex: "#797B7E"),leftClick:(() ->())? = nil, rightTitle: String = "确定",rightClick:(() ->())? = nil, superView: UIView! = UIUtil.RootController().view) -> SLCommonAlertView{
        let view = SLCommonAlertView.init(title: title, message: message, leftTitle: leftTitle, rightTitle: rightTitle,superView: superView)
        view.rightClick = rightClick
        view.leftClick = leftClick
        view.beginAnimation()
        return view
    }
    let title: String
    let message: String
    let leftTitle: String
    let rightTitle: String
    let leftTitleColor: UIColor
    weak var alertSuperView: UIView? = UIUtil.RootController().view
    var rightClick:(() ->())?
    var leftClick:(() ->())?
    init(title: String = "", message: String = "", leftTitle: String = "",leftTitleColor: UIColor = UIColor.sl_hexToAdecimalColor(hex: "#797B7E"), rightTitle: String = "", superView: UIView!) {
        self.title = title
        self.message = message
        self.leftTitle = leftTitle
        self.leftTitleColor = leftTitleColor
        self.rightTitle = rightTitle
        self.alertSuperView = superView
        super.init(frame: CGRect.zero)
        
        self.addSubview(titleLabel)
        self.addSubview(messageLabel)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        
        leftButton.sl_addLine(position: .top, lineHeight: 0.5)
        rightButton.sl_addLine(position: .top, lineHeight: 0.5)
        if !leftTitle.isEmpty{
            leftButton.sl_addLine(position: .right, lineHeight: 0.5)
        }
        layout()
    }
    
    func layout(){
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(24)
        }
        let hasMessage: Bool = message.count > 0
        if hasMessage{
            messageLabel.snp.makeConstraints { (make) in
                make.left.equalTo(30)
                make.right.equalTo(-30)
                make.top.equalTo(titleLabel.snp_bottom).offset(24)
                make.height.greaterThanOrEqualTo(28)
            }
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(hasMessage ? messageLabel.snp_bottom:titleLabel.snp_bottom).offset(23.5)
            make.left.equalTo(0)
        }
        rightButton.snp.makeConstraints { (make) in
            make.height.equalTo(56)
            make.bottom.equalTo(0).priorityHigh()
            make.top.equalTo(leftButton)
            make.right.equalTo(0)
            if leftTitle.isEmpty {
                make.left.equalTo(0)
            }else{
                make.left.equalTo(leftButton.snp_right)
                make.width.equalTo(leftButton)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func beginAnimation() {
        alertSuperView?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNightBackgroundColor)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.equalTo(57.5)
            make.right.equalTo(-57.5)
            make.centerY.equalTo(bgWindow)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc public func dismiss(){
        self.bgWindow.removeFromSuperview()
        self.removeFromSuperview()
        self.bgWindow = nil
        self.alertSuperView = nil
        //        UIView.animate(withDuration: 0.25, animations: {
        //            self.bgWindow.alpha = 0
        //        }) { finished in
        //
        //
        //        }
    }
    
    @objc private func certainClick(){
        dismiss()
        rightClick?()
        
    }
    
    @objc private func cancelClick(){
        dismiss()
        leftClick?()
        
    }
    
    // MARK: -getter
    
    lazy var titleLabel : UILabel = {
        let view = getLabel(text: self.title)
        view.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#000000"), night: kNight898F9A)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    lazy var messageLabel : UILabel = {
        let view = getLabel(text: self.message)
        view.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNight898F9A)
        view.font = UIFont.boldSystemFont(ofSize: 15)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    
    
    lazy var leftButton : UIButton = {
        let button = UIButton.init()
        button.setMixedTitleColor(MixedColor(normal: leftTitleColor, night: kNight898F9A), forState: .normal)
        button.setTitle(self.leftTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelClick), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton : UIButton = {
        let button = UIButton.init()
        button.setMixedTitleColor(MixedColor(normal: kBlueColor, night: kBlueColor), forState: .normal)
        button.setTitle(self.rightTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.3, alpha: 0.7)
        return view
    }()
}
