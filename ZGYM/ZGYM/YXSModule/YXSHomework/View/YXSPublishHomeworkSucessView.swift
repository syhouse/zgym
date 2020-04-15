//
//  YXSPublishHomeworkSucessView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/26.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSPublishHomeworkSucessView: UIView {
    @discardableResult @objc static func showAlert(compelect: @escaping (() ->())) -> YXSPublishHomeworkSucessView{
        let view = YXSPublishHomeworkSucessView()
        view.compelect = compelect
        view.beginAnimation()
        return view
    }
    var compelect:(() ->())!
    override init(frame: CGRect){
        super.init(frame: frame)
        
        self.addSubview(whiteBg)
        whiteBg.addSubview(publishSucessImage)
        whiteBg.addSubview(titleLabel)
        whiteBg.addSubview(desLabel)
        whiteBg.addSubview(certainButton)
        self.addSubview(closeButton)
        layout()
    }
    
    func layout(){
        whiteBg.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(338)
        }
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(whiteBg)
            make.top.equalTo(whiteBg.snp_bottom).offset(18.5)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
            make.bottom.equalTo(0)
        }
        publishSucessImage.snp.makeConstraints { (make) in
            make.centerX.equalTo(whiteBg)
            make.top.equalTo(25)
            make.size.equalTo(CGSize.init(width: 225, height: 171))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(whiteBg)
            make.top.equalTo(publishSucessImage.snp_bottom).offset(9)
        }
        desLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(whiteBg)
            make.top.equalTo(titleLabel.snp_bottom).offset(12)
        }
        certainButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(whiteBg)
            make.top.equalTo(desLabel.snp_bottom).offset(18)
            make.size.equalTo(CGSize.init(width: 200, height: 49))
        }
        
        if !WXApi.isWXAppInstalled(){
            certainButton.isHidden = true
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        bgWindow.addSubview(self)
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
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
    
    @objc func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.bgWindow.alpha = 0
        }) { finished in
            self.bgWindow.removeFromSuperview()
        }
    }
    @objc func certainClick(){
        compelect()
        dismiss()
    }
    
    
    // MARK: -getter
    lazy var whiteBg : UIView = {
        let view =  UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight282C3B)
        view.cornerRadius = 15
        return view
    }()
    
    lazy var publishSucessImage: UIImageView = {
        let imageView = UIImageView()
        imageView.mixedImage = MixedImage(normal: "yxs_publish_sucess_bg", night: "yxs_publish_sucess_bg_night")
        return imageView
    }()
    
    lazy var titleLabel : UILabel = {
        let view = getLabel(text: "作业发送成功")
        view.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        view.font = UIFont.boldSystemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()
    lazy var desLabel : UILabel = {
        let view = getLabel(text: "分享到微信家长群，及时了解已阅情况")
        view.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#C4CDDA"), night: kNightBCC6D4)
        view.font = UIFont.systemFont(ofSize: 13)
        view.numberOfLines = 0
        view.textAlignment = NSTextAlignment.center
        return view
    }()

    
    lazy var closeButton : YXSButton = {
        let button = YXSButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_publish_close_sucess"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var certainButton : YXSButton = {
        let button = YXSButton.init()
        button.setTitleColor(UIColor.white, for: .normal)
        button.setTitle("分享到微信", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 24.5
        button.clipsToBounds = true
        button.yxs_gradualBackground(frame: CGRect.init(x: 0, y: 0, width: 200, height: 49), startColor: UIColor.yxs_hexToAdecimalColor(hex: "#4B73F6"), endColor: UIColor.yxs_hexToAdecimalColor(hex: "#77A3F8"), cornerRadius: 24.5)
        button.addShadow(ofColor: UIColor.yxs_hexToAdecimalColor(hex: "#4C74F6"), radius: 7.5, offset: CGSize(width: 0, height: 3), opacity: 0.5)
        button.addTarget(self, action: #selector(certainClick), for: .touchUpInside)
        return button
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
}
