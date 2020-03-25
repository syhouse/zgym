//
//  SLMediaView.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/3.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import NightNight
import YBImageBrowser

/// 文本+音频+图片9宫格
class SLMediaView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// 语音
    var voiceTouchedHandler:((_ voiceUlr: String, _ voiceDuration: Int)->())?
    /// 图片
    var imageTouchedHandler:((_ imageView: UIImageView, _ index:Int)->())?

    /// 视频
    var videoTouchedHandler:((_ videoUlr: String)->())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(lbContent)
        self.addSubview(voiceView)
        self.addSubview(imagesView)

        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        lbContent.snp.makeConstraints({ (make) in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.right.equalTo(0)
        })
        
        voiceView.snp.makeConstraints({ (make) in
            make.top.equalTo(lbContent.snp_bottom).offset(18)
            make.left.equalTo(0)
            make.width.equalTo(162)
            make.height.equalTo(36)
        })
        
        imagesView.snp.makeConstraints({ (make) in
            make.top.equalTo(voiceView.snp_bottom).offset(18)
            make.left.equalTo(0)
            make.right.equalTo(0)
            make.bottom.equalTo(0)
        })
    }
    
    // MARK: - Setter
    var model: SLMediaViewModel? {
        didSet {
            if self.model?.voiceUrl == nil || self.model?.voiceUrl?.count == 0 {
                voiceView.isHidden = true
                imagesView.snp.remakeConstraints { (make) in
                    make.top.equalTo(lbContent.snp_bottom).offset(18)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0)
                }
                
            } else {
                voiceView.isHidden = false
                imagesView.snp.remakeConstraints { (make) in
                    make.top.equalTo(voiceView.snp_bottom).offset(18)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                    make.bottom.equalTo(0)
                }
            }
            UIUtil.sl_setLabelParagraphText(lbContent, text: self.model?.content)
            let paragraphStye = NSMutableParagraphStyle()
            paragraphStye.lineSpacing = kMainContentLineHeight
            paragraphStye.lineBreakMode = NSLineBreakMode.byWordWrapping
            let dic = [NSAttributedString.Key.font: kTextMainBodyFont, NSAttributedString.Key.paragraphStyle:paragraphStye]
            let height = UIUtil.sl_getTextHeigh(textStr: self.model?.content, attributes: dic , width: self.width)
            if height < 20 {
                lbContent.snp.remakeConstraints { (make) in
                    make.top.equalTo(0)
                    make.left.equalTo(0)
                }
                lbContent.sizeToFit()
            }
            else {
                lbContent.snp.makeConstraints({ (make) in
                    make.top.equalTo(0)
                    make.left.equalTo(0)
                    make.right.equalTo(0)
                })
            }
            imagesView.images = self.model?.thumbnailImages
            imagesView.isVideo = self.model?.videoUrl?.count ?? 0 > 0 ? true : false
            
            let vModel = SLVoiceViewModel()
            vModel.voiceDuration = self.model?.voiceDuration
            vModel.voiceUlr = self.model?.voiceUrl
            voiceView.model = vModel
        }
    }
    
    // MARK: - Action
    func showImageBrowser(index: Int){
        let browser = YBImageBrowser()
        for url in model?.images ?? [String](){
            let imgData = YBIBImageData()
            imgData.imageURL = URL.init(string: url)
            browser.dataSourceArray.append(imgData)
        }
        browser.currentPage = index

//        browser.toolViewHandlers = [SLPhotoBrowserTool.init()]
        browser.show()
    }
    
    func showVideoBrowser() {
        UIUtil.pushOpenVideo(url: model?.videoUrl ?? "")
    }
    
    // MARK: - LazyLoad
    lazy var lbContent: SLEventCopyLabel = {
        let lb = SLEventCopyLabel()
        lb.numberOfLines = 0
        lb.mixedTextColor = MixedColor(normal: kTextMainBodyColor, night: kNightFFFFFF)
        lb.text = ""
        lb.font = UIFont.systemFont(ofSize: 16)
        return lb
    }()
    
    lazy var voiceView: SLVoiceView = {
        let vv = SLVoiceView(frame: CGRect(x: 0, y: 0, width: 162, height: 36))
        vv.completionHandler = {[weak self](voiceUrl, duration) in
            guard let weakSelf = self else {return}
            weakSelf.voiceTouchedHandler?(voiceUrl, duration)
        }
        return vv
    }()
    
    lazy var imagesView: SLHomeworkThumbnailsView = {
        let thumbnail = SLHomeworkThumbnailsView(leftMargin: 15, rightMargin: 15)
        thumbnail.touchedAtIndexBlock = {[weak self] (imageView, index) in
            guard let weakSelf = self else {return}
            
            if weakSelf.model?.videoUrl?.count ?? 0 > 0 {
                /// 视频
                weakSelf.videoTouchedHandler?(weakSelf.model?.videoUrl ?? "")
//                weakSelf.showVideoBrowser()
                
            } else {
                /// 图片
                weakSelf.showImageBrowser(index: index)
                weakSelf.imageTouchedHandler?(imageView, index)
            }

        }
        return thumbnail
    }()
}

// MARK: -
class SLMediaViewModel: NSObject {
    var content: String?
    var voiceUrl: String?
    var voiceDuration: Int?
//    var videoUrl: String?
//    var bgUrl: String?
    var thumbnailImages:[String]?
    
//    init(content: String? = nil, voiceUrl: String? = nil, voiceDuration: Int? = nil, images:[String]? = nil) {
//        super.init()
//        self.content = content
//        self.voiceUrl = voiceUrl
//        self.voiceDuration = voiceDuration
//        self.images = images
//    }
    @objc func trigger() {
        if self.bgUrl?.count ?? 0 > 0 || self.videoUrl?.count ?? 0 > 0 {
            images = [self.bgUrl ?? ""]
        }
    }
    
    var images: [String]? {
        didSet {
            var tmpArr = [String]()
            for sub in self.images ?? [String]() {
                let tmp = String(sub)
                tmpArr.append(tmp.sl_getVediUrlImage())
            }
            thumbnailImages = tmpArr
        }
    }
    
    var videoUrl: String? {
        didSet {
            trigger()
        }
    }
        
    var bgUrl: String? {
        didSet {
            trigger()
        }
    }
}
