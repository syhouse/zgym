//
//  LoginTipsAlert.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/14.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import SnapKit
import NightNight

enum LoginAlertTipsType {
    case service  //服务
    case privacy //隐私
    case agreement //同意
    case notagreement  //不同意
}

class YXSLoginTipsAlertView: UIView {
    
    /// 展示
    /// - Parameter complete: 点击所有按钮回调
    static func showAlert(complete:(( _ type: LoginAlertTipsType) ->())?) -> YXSLoginTipsAlertView{
        let view = YXSLoginTipsAlertView()
        view.complete = complete
        view.beginAnimation()
        return view
    }
    private let title: String = "服务协议及隐私政策"
    private let message: String = "请您务必仔细阅读以下“用户协议”、“用户隐私政策”等内容，并审慎点击同意；如您点击同意，则表示您充分理解并同意协议条款内容。"
    private let service: String = "《优学业软件用户服务协议》"
    private let privacy: String = "《优学业用户隐私保护政策》"
    private let leftTitle: String = "不同意"
    private let rightTitle: String = "同意"
    private var complete:((_ type: LoginAlertTipsType) ->())?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(titleLabel)
        self.addSubview(messageLabel)
        self.addSubview(serviceButton)
        self.addSubview(privacyButton)
        self.addSubview(leftButton)
        self.addSubview(rightButton)
        layout()
    }
    
    func layout(){
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(34.5)
        }
        messageLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(titleLabel.snp_bottom).offset(27.5)
        }
        
        serviceButton.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(messageLabel.snp_bottom).offset(28)
        }
        privacyButton.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.top.equalTo(serviceButton.snp_bottom).offset(14.5)
        }
        
        leftButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.bottom.equalTo(-34.5).priorityHigh()
            make.top.equalTo(privacyButton.snp_bottom).offset(35)
            make.left.equalTo(29)
        }
        rightButton.snp.makeConstraints { (make) in
            make.height.equalTo(48)
            make.top.equalTo(leftButton)
            make.right.equalTo(-30)
            make.left.equalTo(leftButton.snp_right).offset(14)
            make.width.equalTo(leftButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -public
    public func beginAnimation() {
        let superVc: UIViewController = UIUtil.TopViewController()//.presentedViewController ?? UIUtil.currentNav()
        superVc.view.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        self.mixedBackgroundColor = MixedColor(normal: 0xFFFFFF, night: 0x282C3B)
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        
        self.snp.makeConstraints { (make) in
            make.left.equalTo(37.5)
            make.right.equalTo(-37.5)
            make.centerY.equalTo(bgWindow)
        }
        bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 1
        })
    }
    
    @objc public  func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
        }
    }
    
    
    // MARK: -event

    @objc func buttonClick(button: YXSButton){
        var type = LoginAlertTipsType.service
        switch button {
        case rightButton:
            type = .agreement
        case leftButton:
            type = .notagreement
        case serviceButton:
            type = .service
            let vc = YXSBaseWebViewController()
            vc.loadUrl = "\(sericeType.getH5Url())yhxy.html"
            UIUtil.TopViewController().navigationController?.pushViewController(vc)
            return
            
        case privacyButton:
            type = .privacy
            let vc = YXSBaseWebViewController()
            vc.loadUrl = "\(sericeType.getH5Url())yszc.html"
            UIUtil.TopViewController().navigationController?.pushViewController(vc)
            return
            
        default:
            type = LoginAlertTipsType.service
        }
        complete?(type)
        dismiss()
    }
    
    
    // MARK: -getter
    
    lazy var titleLabel : YXSLabel = {
        let view = YXSLabel()
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
//        view.textColor = kTextBlackColor
        view.mixedTextColor = MixedColor(normal: 0x333333, night: 0xFFFFFF)
        view.text = title
        return view
    }()
    
    lazy var messageLabel : YXSLabel = {
        let view = YXSLabel()
        view.font = UIFont.systemFont(ofSize: 15)
        view.numberOfLines = 0
//        view.textColor = kTextLightBlackColor
        view.mixedTextColor = MixedColor(normal: 0x575A60, night: 0xFFFFFF)
        view.text = message
        return view
    }()
    
    lazy var serviceButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle(service, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
    lazy var privacyButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(kBlueColor, for: .normal)
        button.setTitle(privacy, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var leftButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(leftTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        button.mixedBackgroundColor = MixedColor(normal: 0xC4CDDA, night: 0x383E56)
//        button.backgroundColor = UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA")
        button.layer.cornerRadius = 22
        return button
    }()
    
    lazy var rightButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle(rightTitle, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        button.backgroundColor = kBlueColor
        button.layer.cornerRadius = 22
        return button
    }()
    
    lazy var bgWindow : UIControl = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.252, alpha: 0.7)
        return view
    }()
}
