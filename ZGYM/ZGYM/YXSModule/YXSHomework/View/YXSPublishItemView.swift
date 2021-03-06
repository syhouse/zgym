//
//  YXSPublishItemView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/27.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import NightNight

let kTitleKey = "title"
let kImageKey = "image"
let kActionKey = "action"
let kShowButton = "showButton"


/// 资源类型
public enum PublishSource: Int{
    //图片
    case image
    //当前已是最大图片
    case imageMax
    //视频
    case video
    //无
    case none
    //音频
    case audio
    //当前已是最大音频
    case audioMax
    ///当前已是最大文件
    case fileMax
}

//button 点击事件
public enum PublishViewButtonEvent{
    case accessory//附件
    case link//连接
    case audio//音频
    case image//图片
    case vedio//视频
}

private let publishViewButtonOrginTag = 303
class SLPublishViewButtonView: UIView{
    var publishType: YXSHomeType = .homework
    init(isFriend: Bool = false,type:YXSHomeType = .homework) {
        self.isFriend = isFriend
        self.publishType = type
        super.init(frame: CGRect.zero)
        for index in 0..<buttons.count{
            let button = YXSButton()
            if NightNight.theme == .night{
                button.setBackgroundImage(UIImage.init(named: buttons[index][kImageKey] as! String), for: .disabled)
                button.setBackgroundImage(UIImage.init(named: "\(buttons[index][kImageKey] as! String)_gray"), for: .normal)
            }else{
                button.setBackgroundImage(UIImage.init(named: buttons[index][kImageKey] as! String), for: .normal)
                button.setBackgroundImage(UIImage.init(named: "\(buttons[index][kImageKey] as! String)_gray"), for: .disabled)
            }
            button.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
            button.tag = index + publishViewButtonOrginTag
            addSubview(button)
            button.snp.makeConstraints { (make) in
                make.centerY.equalTo(self)
                make.size.equalTo(CGSize.init(width: 29, height: 29))
                make.left.equalTo(9 + CGFloat(29 + 14.5) * CGFloat(index))
            }
        }
    }
    public var buttonClickBlock: ((_ event:PublishViewButtonEvent) -> ())?
    
    
    /// 修改按钮状态
    /// - Parameter sourceTypes: 当前资源类型
    public func changeButtonStates(_ sourceTypes:[PublishSource]){
        for index in 0..<buttons.count{
            let button = viewWithTag(index + publishViewButtonOrginTag) as? YXSButton
            if let button = button{
                button.isEnabled = true
                let event = buttons[index][kActionKey] as! PublishViewButtonEvent
                if sourceTypes.contains(.audioMax){
                    if event == .audio || event == .vedio{
                        button.isEnabled = false
                    }
                }
                if sourceTypes.contains(.fileMax) {
                    if event == .accessory {
                        button.isEnabled = false
                    }
                }
                if sourceTypes.contains(.audio){
                    if event == .vedio{
                        button.isEnabled = false
                    }
                }
                if sourceTypes.contains(.imageMax){
                    if event == .image || event == .vedio{
                        button.isEnabled = false
                    }
                }
                if sourceTypes.contains(.image){
                    if event == .vedio{
                        button.isEnabled = false
                    }
                }
                
                if sourceTypes.contains(.video){
                    button.isEnabled = false
                }
            }
        }
        
    }
    
    /// 当前是否是朋友圈
    private var isFriend: Bool
    private var buttons: [[String: Any]]{
        get{
            var lists = [[kImageKey: "yxs_publish_image", kActionKey: PublishViewButtonEvent.image]]
            
            if self.publishType == .solitaire{
                
            }else{
                lists.append([kImageKey: "yxs_publish_vedio", kActionKey: PublishViewButtonEvent.vedio])
                if YXSPersonDataModel.sharePerson.personRole == .TEACHER && !isFriend{
                    lists.append([kImageKey: "yxs_publish_link", kActionKey: PublishViewButtonEvent.link])
                    if self.publishType == .homework || self.publishType == .notice {
                        lists.append([kImageKey: "yxs_publish_accessory", kActionKey: PublishViewButtonEvent.accessory])
                    }
                }
            }
            
            if !isFriend{
                lists.insert([kImageKey: "yxs_publish_audio", kActionKey: PublishViewButtonEvent.audio], at: 0)
                
            }
            return lists
        }
    }
    
    @objc func buttonClick(_ button: YXSButton){
        let index = button.tag - publishViewButtonOrginTag
        buttonClickBlock?(buttons[index][kActionKey] as! PublishViewButtonEvent)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class YXSPublishFileView: UIView {
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var clickCompletion:((_ model:YXSFileModel)->())?
    private var closeCompletion:(()->())?
    var model: YXSFileModel?
    init(clickCompletion:((_ model:YXSFileModel)->())? = nil,closeCompletion:(()->())? = nil) {
        super.init(frame: CGRect.zero)
        self.clickCompletion = clickCompletion
        self.closeCompletion = closeCompletion
        createUI()
        
    }
    
    func setModel(model:YXSFileModel){
        self.model = model
        self.titleLbl.setTitle(model.fileName, for: .normal)
        if let url = URL(string: model.fileUrl?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") {
            if let img = YXSFileManagerHelper.sharedInstance.getIconWithFileUrl(url) {
                self.imgIcon.image = img
                
            } else {
                let strIcon = model.bgUrl?.count ?? 0 > 0 ? model.bgUrl : model.fileUrl
                self.imgIcon.sd_setImage(with: URL(string: strIcon ?? ""), placeholderImage: kImageDefualtImage)
            }
        }
//        self.imgIcon.sd_setImage(with: URL(string: strIcon ?? ""), placeholderImage: kImageDefualtImage)
    }
    
    func createUI() {
        
        self.clipsToBounds = true
        self.cornerRadius = 2.5
        self.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNight282C3B)
        self.addSubview(self.imgIcon)
        self.addSubview(self.closeImgIcon)
        self.addSubview(self.titleLbl)
        
        self.imgIcon.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(14.5)
            make.size.equalTo(CGSize.init(width: 30, height: 30))
        })
        
        self.closeImgIcon.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-10.5)
            make.size.equalTo(CGSize.init(width: 23, height: 23))
        })
        
        self.titleLbl.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(self.imgIcon.snp_right).offset(10)
            make.right.equalTo(self.closeImgIcon.snp_left).offset(-8)
        })
    }
    
    // MARK: - Action
    @objc func close() {
        closeCompletion?()
    }
    
    @objc func titleClick(sender: YXSButton) {
        clickCompletion?(self.model!)
    }
    
    // MARK: - LazyLoad
    lazy var titleLbl: YXSButton = {
        let btn = YXSButton()
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.contentHorizontalAlignment = .left
        btn.setMixedTitleColor(MixedColor(normal: k222222Color, night: kNightFFFFFF), forState: .normal)
        btn.addTarget(self, action: #selector(titleClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var imgIcon: UIImageView = {
        let imgIcon = UIImageView()
        return imgIcon
    }()
    
    lazy var closeImgIcon: YXSButton = {
        let img = YXSButton()
        img.setImage(UIImage(named: "yxs_publish_delect_gray"), for: .normal)
        img.addTarget(self, action: #selector(close), for: .touchUpInside)
        return img
    }()
}

class SLPublishLinkView: UIView {
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var clickCompletion:(()->())?
    private var closeCompletion:(()->())?
    init(link:String = "", clickCompletion:(()->())? = nil, closeCompletion:(()->())? = nil) {
        super.init(frame: CGRect.zero)
        
        self.clickCompletion = clickCompletion
        self.closeCompletion = closeCompletion
        createUI()
        self.btnLink.setTitle(link, for: .normal)
    }
    
    func createUI() {
        
        self.clipsToBounds = true
        self.cornerRadius = 2.5
        self.mixedBackgroundColor = MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#F3F5F9"), night: kNight282C3B)
        self.addSubview(self.imgIcon)
        self.addSubview(self.btnLink)
        
        self.imgIcon.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.right.equalTo(-10.5)
            make.size.equalTo(CGSize.init(width: 23, height: 23))
        })
        
        self.btnLink.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.snp_centerY)
            make.left.equalTo(14.5)
            make.right.equalTo(-45)
        })
    }
    
    // MARK: - Action
    @objc func linkClick(sender: YXSButton) {
        clickCompletion?()
    }
    @objc func close() {
        closeCompletion?()
    }
    
    // MARK: - LazyLoad
    lazy var btnLink: YXSButton = {
        let btn = YXSButton()
        btn.setTitle("https://www.baidu.com", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        btn.titleLabel?.lineBreakMode = .byTruncatingTail
        btn.contentHorizontalAlignment = .left
        btn.setMixedTitleColor(MixedColor(normal: UIColor.yxs_hexToAdecimalColor(hex: "#575A60"), night: kNightBCC6D4), forState: .normal)
        btn.addTarget(self, action: #selector(linkClick(sender:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var imgIcon: YXSButton = {
        let img = YXSButton()
        img.setImage(UIImage(named: "yxs_publish_delect_gray"), for: .normal)
        img.addTarget(self, action: #selector(close), for: .touchUpInside)
        return img
    }()
    
}
