//
//  SLPunchCardShareView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/12/2.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight

class PunchCardShareModel: NSObject{
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

class SLPunchCardShareView: UIView {
    @discardableResult @objc static func showAlert(shareModel: PunchCardShareModel,compelect: @escaping ((_ image: UIImage) ->())) -> SLPunchCardShareView{
        let view = SLPunchCardShareView.init(shareModel: shareModel)
        view.compelect = compelect
        view.punchSucessBgView.sd_setImage(with: URL.init(string: shareModel.bgUrl),placeholderImage: UIImage.init(named: "sl_punch_sucess_bg")){(image, error, type, url) in
            view.beginAnimation()
        }
        return view
    }
    var compelect:((_ image: UIImage) ->())!
    var shareModel: PunchCardShareModel
    init(shareModel: PunchCardShareModel){
        self.shareModel = shareModel
        super.init(frame: CGRect.zero)
        
        
        addSubview(closeButton)
        addSubview(punchSucessBgView)
        punchSucessBgView.addSubview(bottomView)
        
        bottomView.addSubview(downloadControl)
        bottomView.addSubview(shareControl)
        layout()
    }
    
    func layout(){
        punchSucessBgView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.size.equalTo(CGSize.init(width: 319*SCREEN_SCALE, height: 532.5*SCREEN_SCALE))
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(46)
        }
        closeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(punchSucessBgView)
            make.top.equalTo(punchSucessBgView.snp_bottom).offset(19)
            make.size.equalTo(CGSize.init(width: 36, height: 36))
            make.bottom.equalTo(0)
        }
        
        downloadControl.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(0)
            make.width.equalTo(bottomView).multipliedBy(0.6)
        }
        shareControl.snp.makeConstraints { (make) in
            make.right.top.bottom.equalTo(0)
            make.width.equalTo(bottomView).multipliedBy(0.4)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func beginAnimation() {
        UIApplication.shared.keyWindow?.addSubview(bgWindow)
        
        shareImageView.frame = UIScreen.main.bounds
        
        bgWindow.addSubview(self)
        bgWindow.addSubview(shareImageView)
        shareImageView.alpha = 0
        
        bgWindow.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        self.snp.makeConstraints { (make) in
            make.center.equalTo(bgWindow)
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
    @objc func shareClick(){
        shareImageView.alpha = 1
        compelect?(UIImage.sl_screenSnapshot(save: false, view: shareImageView))
        shareImageView.alpha = 0
        dismiss()
    }
    @objc func savePhotoClick(){
        shareImageView.alpha = 1
        UIImage.sl_screenSnapshot(save: true, view: shareImageView)
        shareImageView.alpha = 0
        MBProgressHUD.sl_showMessage(message: "保存相册成功")
        dismiss()
    }
    
    
    // MARK: -getter
    
    
    lazy var closeButton : SLButton = {
        let button = SLButton.init()
        button.setBackgroundImage(UIImage.init(named: "sl_publish_close_sucess"), for: .normal)
        button.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return button
    }()
    
    lazy var downloadControl: SLButton = {
        let titleView = SLButton()
        titleView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        titleView.setImage(UIImage.init(named: "sl_punchCard_download"), for: .normal)
        titleView.setTitle("保存至相册", for: .normal)
        titleView.setTitleColor(UIColor.white, for: .normal)
        titleView.addTarget(self, action: #selector(savePhotoClick), for: .touchUpInside)
        titleView.sl_addLine(position: .right, color: UIColor.white, leftMargin: 11.5, rightMargin: 11.5, lineHeight: 0.5)
        titleView.sl_setIconInLeftWithSpacing(10)
        return titleView
    }()
    lazy var shareControl: SLButton = {
        let titleView = SLButton()
        titleView.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        titleView.setImage(UIImage.init(named: "sl_punchCard_share_white"), for: .normal)
        titleView.setTitle("分享", for: .normal)
        titleView.setTitleColor(UIColor.white, for: .normal)
        titleView.addTarget(self, action: #selector(shareClick), for: .touchUpInside)
        titleView.sl_setIconInLeftWithSpacing(10)
        return titleView
    }()
    
    lazy var bgWindow : UIControl! = {
        let view = UIControl()
        view.backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        return view
    }()
    lazy var punchSucessBgView : PunchSucessBgView = {
        let view = PunchSucessBgView.init(shareModel: self.shareModel,isOverFollow: true)
        view.isUserInteractionEnabled = true
        view.cornerRadius = 5
        return view
    }()
    
    lazy var shareImageView : PunchSucessBgView = {
        let view = PunchSucessBgView.init(shareModel: self.shareModel)
        return view
    }()
    
    lazy var bottomView : UIView = {
        let view =  UIView()
        view.backgroundColor = kBlueColor
        return view
    }()
}

class PunchSucessBgView: UIImageView{
    var shareModel: PunchCardShareModel
    
    /// over label是否跟随
    var isOverFollow: Bool
    init(shareModel: PunchCardShareModel,isOverFollow: Bool = false){
        self.shareModel = shareModel
        self.isOverFollow = isOverFollow
        super.init(frame: CGRect.zero)
        
        self.addSubview(topWhiteView)
        self.addSubview(midWhiteView)
        
        topWhiteView.addSubview(userIcon)
        topWhiteView.addSubview(nameLabel)
        topWhiteView.addSubview(tipsLabel)
        topWhiteView.addSubview(titleLabel)
        topWhiteView.addSubview(lineView)
        topWhiteView.addSubview(punchCardOverLabel)
        topWhiteView.addSubview(punchCardCountLabel)
        midWhiteView.addSubview(scanLabel)
        midWhiteView.addSubview(scanImageView)
        midWhiteView.addSubview(midTipsLabel)
        
        
        userIcon.sd_setImage(with: URL.init(string: shareModel.avar),placeholderImage: kImageUserIconStudentDefualtImage, completed: nil)
        self.sd_setImage(with: URL.init(string: shareModel.bgUrl),placeholderImage: UIImage.init(named: "sl_punch_sucess_bg"))

        nameLabel.text = shareModel.name
        titleLabel.text = shareModel.title
        UIUtil.sl_setLabelAttributed(punchCardCountLabel, text: ["累计打卡 ","\(shareModel.clockInDayCount)", " 天"], colors: [MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#747983"), night: kNightBCC6D4),MixedColor(normal: kTextMainBodyColor, night: UIColor.white), MixedColor(normal: kTextMainBodyColor, night: UIColor.white)], fonts: [UIFont.systemFont(ofSize: 13),UIFont.boldSystemFont(ofSize: 30),UIFont.systemFont(ofSize: 13)])
        UIUtil.sl_setLabelAttributed(punchCardOverLabel, text: ["超跃全班 ","\(Int(shareModel.percentOver) ?? 0)", " %人"], colors: [MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#747983"), night: kNightBCC6D4),MixedColor(normal: kTextMainBodyColor, night: UIColor.white), MixedColor(normal: kTextMainBodyColor, night: UIColor.white)], fonts: [UIFont.systemFont(ofSize: 13),UIFont.boldSystemFont(ofSize: 30),UIFont.systemFont(ofSize: 13)])
        scanImageView.image = self.sl_setupQRCodeImage(shareModel.downLoadUrl, image: UIImage.init(named: "sl_logo"))
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
        topWhiteView.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.bottom.equalTo(-174)
        }
        midWhiteView.snp.makeConstraints { (make) in
            make.left.equalTo(21)
            make.right.equalTo(-21)
            make.height.equalTo(105.5)
            make.bottom.equalTo(-53.5)
        }
        
        userIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(19)
            make.width.height.equalTo(46)
        }
        nameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon.snp_right).offset(9)
            make.top.equalTo(24)
        }
        
        tipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(nameLabel)
            make.top.equalTo(49)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon)
            make.top.equalTo(userIcon.snp_bottom).offset(16)
            make.right.equalTo(-15)
        }
        lineView.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon)
            make.top.equalTo(titleLabel.snp_bottom).offset(16)
            make.height.equalTo(1)
            make.right.equalTo(-15)
        }
        punchCardCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(userIcon)
            make.top.equalTo(lineView.snp_bottom).offset(16)
        }
        punchCardOverLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom).offset(16)
            if isOverFollow{
                make.left.equalTo(punchCardCountLabel.snp_right).offset(20)
            }else{
                make.left.equalTo(punchCardCountLabel.snp_right).offset(30)
                make.width.equalTo(punchCardCountLabel)
            }
            
            make.bottom.equalTo(-27).priorityHigh()
        }
        
        midTipsLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(27.5)
        }
        scanLabel.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.top.equalTo(midTipsLabel.snp_bottom).offset(11.5)
            make.height.equalTo(25)
            make.width.equalTo(150)
        }
        
        scanImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-16)
            make.centerY.equalTo(midWhiteView)
            make.size.equalTo(CGSize.init(width: 78, height: 78))
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var topWhiteView : UIView = {
        let view =  UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight282C3B)
        view.cornerRadius = 15
        return view
    }()
    
    lazy var midWhiteView : UIView = {
        let view =  UIView()
        view.mixedBackgroundColor = MixedColor(normal: UIColor.white, night: kNight282C3B)
        view.cornerRadius = 15
        return view
    }()
    
    lazy var userIcon: UIImageView = {
        let userIcon = UIImageView()
        userIcon.cornerRadius = 23
        userIcon.contentMode = .scaleAspectFill
        return userIcon
    }()
    
    lazy var nameLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        return label
    }()
    
    lazy var tipsLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#898F9A"), night: kNightBCC6D4)
        label.text = "我刚刚在 [ 优学生 ] 上完成了打卡"
        return label
    }()
    
    
    lazy var titleLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.systemFont(ofSize: 17)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var punchCardCountLabel: SLLabel = {
        let label = SLLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var punchCardOverLabel: SLLabel = {
        let label = SLLabel()
        label.mixedTextColor = MixedColor(normal: UIColor.sl_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4)
        return label
    }()
    
    lazy var scanImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var lineView: UIView = {
        let lineView = UIView()
        lineView.backgroundColor = kLineColor
        return lineView
    }()
    
    lazy var midTipsLabel: SLLabel = {
        let label = SLLabel()
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: UIColor.white)
        label.text = "优学生, 优成长"
        return label
    }()
    
    lazy var scanLabel: SLLabel = {
        let label = SLLabel()
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
