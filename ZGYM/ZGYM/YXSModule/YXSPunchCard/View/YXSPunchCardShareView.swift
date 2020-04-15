//
//  YXSPunchCardShareView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/2.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

class YXSPunchCardShareModel: NSObject{
    var downLoadUrl: String
    var name: String
    var avar: String
    var title: String
    var bgUrl: String
    var clockInDayCount: Int
    var percentOver: String
    init(downLoadUrl: String, name: String,avar: String,title: String,clockInDayCount: Int,percentOver: String,bgUrl: String) {
        self.downLoadUrl = downLoadUrl
        self.name = name
        self.avar = avar
        self.title = title
        self.clockInDayCount = clockInDayCount
        self.percentOver = percentOver
        self.bgUrl = bgUrl
        super.init()
    }
}

class YXSPunchCardShareView: UIView {
    @discardableResult @objc static func showAlert(shareModel: YXSPunchCardShareModel,compelect: @escaping ((_ image: UIImage) ->())) -> YXSPunchCardShareView{
        let view = YXSPunchCardShareView.init(shareModel: shareModel)
        view.compelect = compelect
        view.yxs_punchSucessBgView.sd_setImage(with: URL.init(string: shareModel.bgUrl),placeholderImage: UIImage.init(named: "yxs_punch_sucess_bg")){(image, error, type, url) in
            view.beginAnimation()
        }
        return view
    }
    var compelect:((_ image: UIImage) ->())!
    var shareModel: YXSPunchCardShareModel
    init(shareModel: YXSPunchCardShareModel){
        self.shareModel = shareModel
        super.init(frame: CGRect.zero)
        
        
        addSubview(yxs_closeButton)
        addSubview(yxs_punchSucessBgView)
        yxs_punchSucessBgView.addSubview(yxs_bottomView)
        
        yxs_bottomView.addSubview(yxs_downloadControl)
        yxs_bottomView.addSubview(yxs_shareControl)
        yxs_layout()
    }
    
    func yxs_layout(){
        yxs_punchSucessBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 319*SCREEN_SCALE, height: 532.5*SCREEN_SCALE))
        }
        
        yxs_bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(46)
        }
        yxs_closeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(yxs_punchSucessBgView)
            make.top.equalTo(yxs_punchSucessBgView.snp_bottom).offset(19)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
            make.bottom.equalTo(0)
        }
        
        yxs_downloadControl.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(yxs_bottomView).multipliedBy(0.6)
        }
        yxs_shareControl.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(yxs_bottomView).multipliedBy(0.4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(yxs_bgWindow)
        
        yxs_shareImageView.frame = UIScreen.main.bounds
        
        yxs_bgWindow.addSubview(self)
        yxs_bgWindow.addSubview(yxs_shareImageView)
        yxs_shareImageView.alpha = 0
        
        yxs_bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        self.snp.makeConstraints { (make) in
            make.center.equalTo(yxs_bgWindow)
        }
        yxs_bgWindow.alpha = 0
        UIView.animate(withDuration: 0.25, animations: {
            self.yxs_bgWindow.alpha = 1
        })
    }
    
    // MARK: -event
    
    @objc func dismiss(){
        UIView.animate(withDuration: 0.25, animations: {
            self.yxs_bgWindow.alpha = 0
        }) { finished in
            self.yxs_bgWindow.removeFromSuperview()
        }
    }
    @objc func yxs_shareClick(){
        yxs_shareImageView.alpha = 1
        compelect?(UIImage.yxs_screenSnapshot(save: false, view: yxs_shareImageView))
        yxs_shareImageView.alpha = 0
        dismiss()
    }
    @objc func yxs_savePhotoClick(){
        yxs_shareImageView.alpha = 1
        UIImage.yxs_screenSnapshot(save: true, view: yxs_shareImageView)
        yxs_shareImageView.alpha = 0
        MBProgressHUD.yxs_showMessage(message: "保存相册成功")
        dismiss()
    }
    
    
    // MARK: -getter
    
    
    lazy var yxs_closeButton : YXSButton = {
        let button = YXSButton.init()
        button.setBackgroundImage(UIImage.init(named: "yxs_publish_close_sucess"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var yxs_downloadControl: YXSButton = {
        let titleView = YXSButton()
        titleView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        titleView.setImage(UIImage.init(named: "yxs_punchCard_download"), for: .normal)
        titleView.setTitle("保存至相册", for: .normal)
        titleView.setTitleColor(UIColor.white, for: .normal)
        titleView.addTarget(self, action: #selector(yxs_savePhotoClick), for: .touchUpInside)
        titleView.yxs_addLine(position: .right, color: UIColor.white, leftMargin: 11.5, rightMargin: 11.5, lineHeight: 0.5)
        titleView.yxs_setIconInLeftWithSpacing(10)
        return titleView
    }()
    lazy var yxs_shareControl: YXSButton = {
        let titleView = YXSButton()
        titleView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        titleView.setImage(UIImage.init(named: "yxs_punchCard_share_white"), for: .normal)
        titleView.setTitle("分享", for: .normal)
        titleView.setTitleColor(UIColor.white, for: .normal)
        titleView.addTarget(self, action: #selector(yxs_shareClick), for: .touchUpInside)
        titleView.yxs_setIconInLeftWithSpacing(10)
        return titleView
    }()
    
    lazy var yxs_bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
    lazy var yxs_punchSucessBgView : YXSPunchSucessBgView = {
        let view = YXSPunchSucessBgView.init(shareModel: self.shareModel,isOverFollow: true)
        view.isUserInteractionEnabled = true
        view.cornerRadius = 5
        return view
    }()
    
    lazy var yxs_shareImageView : YXSPunchSucessBgView = {
        let view = YXSPunchSucessBgView.init(shareModel: self.shareModel)
        return view
    }()
    
    lazy var yxs_bottomView : UIView = {
        let view =  UIView()
        view.backgroundColor = kBlueColor
        return view
    }()
}

class YXSPunchSucessBgView: UIImageView{
    var yxs_shareModel: YXSPunchCardShareModel
    
    /// over label是否跟随
    var yxs_isOverFollow: Bool
    init(shareModel: YXSPunchCardShareModel,isOverFollow: Bool = false){
        self.yxs_shareModel = shareModel
        self.yxs_isOverFollow = isOverFollow
        super.init(frame: CGRect.zero)
        
        self.addSubview(yxs_topWhiteView)
        self.addSubview(yxs_midWhiteView)
        
        yxs_topWhiteView.addSubview(yxs_userIcon)
        yxs_topWhiteView.addSubview(yxs_nameLabel)
        yxs_topWhiteView.addSubview(yxs_tipsLabel)
        yxs_topWhiteView.addSubview(yxs_titleLabel)
        yxs_topWhiteView.addSubview(lineView)
        yxs_topWhiteView.addSubview(yxs_punchCardOverLabel)
        yxs_topWhiteView.addSubview(yxs_punchCardCountLabel)
        yxs_midWhiteView.addSubview(yxs_scanLabel)
        yxs_midWhiteView.addSubview(yxs_scanImageView)
        yxs_midWhiteView.addSubview(yxs_midtipsLabel)
        
        
        yxs_userIcon.sd_setImage(with: URL.init(string: shareModel.avar),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        self.sd_setImage(with: URL.init(string: shareModel.bgUrl),placeholderImage: UIImage.init(named: "yxs_punch_sucess_bg"))

        yxs_nameLabel.text = shareModel.name
        yxs_titleLabel.text = shareModel.title
        UIUtil.yxs_setLabelAttributed(yxs_punchCardCountLabel, text: ["累计打卡 ","\(shareModel.clockInDayCount)", " 天"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#747983"), night: kNightBCC6D4),MixedColor(normal: kTextMainBodyColor, night: UIColor.white), MixedColor(normal: kTextMainBodyColor, night: UIColor.white)], fonts: [UIFont.systemFont(ofSize: 13),UIFont.boldSystemFont(ofSize: 30),UIFont.systemFont(ofSize: 13)])
        UIUtil.yxs_setLabelAttributed(yxs_punchCardOverLabel, text: ["超跃全班 ","\(Int(shareModel.percentOver) ?? 0)", " %人"], colors: [MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#747983"), night: kNightBCC6D4),MixedColor(normal: kTextMainBodyColor, night: UIColor.white), MixedColor(normal: kTextMainBodyColor, night: UIColor.white)], fonts: [UIFont.systemFont(ofSize: 13),UIFont.boldSystemFont(ofSize: 30),UIFont.systemFont(ofSize: 13)])
        yxs_scanImageView.image = self.yxs_setupQRCodeImage(shareModel.downLoadUrl, image: UIImage.init(named: "yxs_logo"))
        layout()
    }
    
    func showView(image: UIImage?){
        if image != nil{
            self.alpha = 1
        }else{
            self.removeFromSuperview()
        }
    }
    
    func layout(){
        yxs_topWhiteView.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.bottom.equalTo(-174)
        }
        yxs_midWhiteView.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(105.5)
            make.bottom.equalTo(-53.5)
        }
        
        yxs_userIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(19)
            make.width.height.equalTo(46)
        }
        yxs_nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_userIcon.snp_right).offset(9)
            make.top.equalTo(24)
        }
        
        yxs_tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_nameLabel)
            make.top.equalTo(49)
        }
        yxs_titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_userIcon)
            make.top.equalTo(yxs_userIcon.snp_bottom).offset(16)
            make.right.equalTo(-15)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_userIcon)
            make.top.equalTo(yxs_titleLabel.snp_bottom).offset(16)
            make.height.equalTo(1)
            make.right.equalTo(-15)
        }
        yxs_punchCardCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(yxs_userIcon)
            make.top.equalTo(lineView.snp_bottom).offset(16)
        }
        yxs_punchCardOverLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom).offset(16)
            if yxs_isOverFollow{
                make.left.equalTo(yxs_punchCardCountLabel.snp_right).offset(20)
            }else{
                make.left.equalTo(yxs_punchCardCountLabel.snp_right).offset(30)
                make.width.equalTo(yxs_punchCardCountLabel)
            }
            
            make.bottom.equalTo(-27).priorityHigh()
        }
        
        yxs_midtipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(27.5)
        }
        yxs_scanLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(yxs_midtipsLabel.snp_bottom).offset(11.5)
            make.height.equalTo(25)
            make.width.equalTo(150)
        }
        
        yxs_scanImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(yxs_midWhiteView)
            make.size.equalTo(CGSize.init(width: 78, height: 78))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var yxs_topWhiteView : UIView = {
        let view =  UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight282C3B)
        view.cornerRadius = 15
        return view
    }()
    
    lazy var yxs_midWhiteView : UIView = {
        let view =  UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight282C3B)
        view.cornerRadius = 15
        return view
    }()
    
    lazy var yxs_userIcon: UIImageView = {
        let yxs_userIcon = UIImageView()
        yxs_userIcon.cornerRadius = 23
        yxs_userIcon.contentMode = .scaleAspectFill
        return yxs_userIcon
    }()
    
    lazy var yxs_nameLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var yxs_tipsLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        label.text = "我刚刚在 [ 优学业 ] 上完成了打卡"
        return label
    }()
    
    
    lazy var yxs_titleLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var yxs_punchCardCountLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var yxs_punchCardOverLabel: YXSLabel = {
        let label = YXSLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var yxs_scanImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = kLineColor
        return lineView
    }()
    
    lazy var yxs_midtipsLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "优学业, 优成长"
        return label
    }()
    
    lazy var yxs_scanLabel: YXSLabel = {
        let label = YXSLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.cornerRadius = 12.5
        label.textColor = UIColor.white
        label.backgroundColor = kBlueColor
        label.text = "扫描二维码, 下载app"
        label.clipsToBounds = true
        label.textAlignment = .center
        return label
    }()
}
