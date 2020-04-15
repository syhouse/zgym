//
//  SLSingleMediaView.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import YBImageBrowser

let kMaxImageCount = 9
let kImageOrginTag = 10001
let kHomeworkPictureGraffitiEvent = "HomeworkPictureGraffitiEvent"
///九宫格(图片+视频)
class SLNineMediaView: UIView{
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        for index in 0 ..< kMaxImageCount{
            let imageView = HMSingleMediaView()
            imageView.tag = kImageOrginTag + index
            imageView.addTaget(target: self, selctor: #selector(imageClick))
            imageView.isHidden = true
            addSubview(imageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public var edges: UIEdgeInsets = UIEdgeInsets.zero
    public var padding: CGFloat = 5
    
    /// 是否能编辑涂鸦（老师对家长提交的作业进行批改）
    public var isGraffiti: Bool = false
    
    public var medias: [YXSFriendsMediaModel]?{
        didSet{
            for index in 0 ..< kMaxImageCount{
                let imageView = viewWithTag(kImageOrginTag + index)!
                imageView.isHidden = true
                imageView.cornerRadius = 2.5
                imageView.snp.removeConstraints()
            }
            
            let rowCount: Int = 3
            
            if self.width == 0{
                assert(false, "视图宽度为空")
            }
            
            var imageWidth = (self.width - edges.left - edges.right  - CGFloat(rowCount - 1)*padding)/CGFloat(rowCount)
            var imageHeight = imageWidth
            if let imgs = medias{
                var lastView: UIView?
                for index in 0..<imgs.count{
                    let model = imgs[index]
                    let imageView = viewWithTag(kImageOrginTag + index) as! HMSingleMediaView
                    imageView.isGraffiti = isGraffiti
                    imageView.isHidden = false
                    imageView.setVieModel(model)
                    let row = index % rowCount
                    if model.type == .serviceVedio{
                        imageWidth = YXSFriendsConfigHelper.helper.videoSize.width
                        imageHeight = YXSFriendsConfigHelper.helper.videoSize.height
                    }
                    
                    imageView.snp.remakeConstraints { (make) in
                        if index == 0{
                            make.top.equalTo(0).priorityHigh()
                        }else if row == 0{
                            make.top.equalTo(lastView!.snp_bottom).offset(5)
                        }else{
                             make.top.equalTo(lastView!)
                        }
                        if index == imgs.count - 1{
                            make.bottom.equalTo(0).priorityHigh()
                        }
                        
                        if row == 0{
                            make.left.equalTo(edges.left)
                        }else{
                            make.left.equalTo(lastView!.snp_right).offset(5)
                        }
                        
                        make.size.equalTo(CGSize.init(width: imageWidth, height: imageHeight))
                    }
                    imageView.imageSize = CGSize.init(width: imageWidth, height: imageHeight)
                    lastView = imageView
                }
            }
            
        }
    }
    
    @objc func imageClick(_ tap: UITapGestureRecognizer){
        let index = (tap.view?.tag ?? kImageOrginTag) - kImageOrginTag
        if let medias = medias{
            let browser = YBImageBrowser()
            var urls = [URL]()
            var images = [YBIBImageBlock]()
            for model in medias{
                if model.type == .serviceVedio{
                    UIUtil.pushOpenVideo(url: model.url ?? "")
                    return
                }else{
                    let imgData = YBIBImageData()
                    if model.type == .serviceImg {
                        urls.append(URL.init(string: model.url ?? "")!)
                    }else{
                        images.append { () -> UIImage? in
                            return UIImage.init(named: model.url ?? "")
                        }
                    }
                    
                    browser.dataSourceArray.append(imgData)
                }
                
            }
            
            YXSShowBrowserHelper.showImage(urls: urls, images: images, curruntIndex: index)
        }
    }
}

class HMSingleMediaView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(playerView)
        self.addSubview(graffitiBtn)
        playerView.snp.makeConstraints { (make) in
            make.center.equalTo(self)
            make.size.equalTo(CGSize.init(width: 55, height: 55))
        }
        graffitiBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.right.equalTo(imageView.snp_right)
            make.bottom.equalTo(imageView.snp_bottom)
        }
        
    }
    
    var imageSize: CGSize = CGSize.zero{
        didSet{
            imageView.snp.remakeConstraints { (make) in
                make.center.equalTo(self)
                make.size.equalTo(imageSize)
            }
        }
    }
    
    /// 是否能编辑涂鸦（老师对家长提交的作业进行批改）
    public var isGraffiti: Bool = false
    
    var model: YXSFriendsMediaModel!
    func setVieModel(_ model: YXSFriendsMediaModel){
        self.model = model
        imageView.isHidden = true
        playerView.isHidden = true
        graffitiBtn.isHidden = !isGraffiti
        if model.type == .serviceVedio{
            imageView.isHidden = false
            playerView.isHidden = false
            imageView.yxs_setImageWithURL(url: URL.init(string: (model.url ?? "").yxs_getVediUrlImage()), placeholder:kImageDefualtMixedImage)
            
        }else if model.type == .serviceImg{
            imageView.isHidden = false
            imageView.yxs_setImageWithURL(url: URL.init(string: (model.url ?? "") + NSUtil.yxs_imageThumbnail(width: 200, height: 200)), placeholder: kImageDefualtMixedImage)
        }else{
            imageView.isHidden = false
            imageView.image = UIImage.init(named: model.url ?? "")
        }
    }
    // 先暂停滚动播放
    /// 停止滑动后播放
    func cheackPlayer(){
    }
    
    @objc func graffitiClick() {
        next?.yxs_routerEventWithName(eventName: kHomeworkPictureGraffitiEvent, info: ["imgModel":self.model!,"imgIndex":self.tag])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var playerView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "yxs_publish_play"))
        return imageView
    }()
    
    lazy var graffitiBtn: YXSButton = {
        let button = YXSButton.init()
        let imgV = UIImageView.init()
        imgV.image = UIImage.init(named: "yxs_homework_ graffiti")
        imgV.contentMode = .scaleAspectFill
        imgV.size = CGSize(width: 26, height: 26)
        button.addSubview(imgV)
        imgV.snp.makeConstraints { (make) in
            make.center.equalTo(button.snp.center)
        }
//        button.setImage(UIImage.init(named: "yxs_homework_ graffiti"), for: .normal)
        button.addTarget(self, action: #selector(graffitiClick), for: .touchUpInside)
        button.isHidden = true
        return button
    }()

}
