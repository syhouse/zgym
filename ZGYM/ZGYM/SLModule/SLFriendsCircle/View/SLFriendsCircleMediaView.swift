//
//  SLSingleMediaView.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/15.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import YBImageBrowser

let kMaxImageCount = 9
let kImageOrginTag = 101

class HMNineMediaView: UIView{


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
    
    public var medias: [SLFriendsMediaModel]?{
        didSet{
            for index in 0 ..< kMaxImageCount{
                let imageView = viewWithTag(kImageOrginTag + index)!
                imageView.isHidden = true
                imageView.cornerRadius = 2.5
                imageView.snp.removeConstraints()
            }
            
            let rowCount: Int = 3
            let imageWidth = (self.width - edges.left - edges.right  - CGFloat(rowCount - 1)*padding)/CGFloat(rowCount)
            if let imgs = medias{
                if imgs.count == 1{//1个资源
                    
                    for index in 0 ..< imgs.count{
                        let imageView = viewWithTag(kImageOrginTag + index) as! HMSingleMediaView
                        imageView.isHidden = false
                        imageView.setVieModel(imgs[index])
                        imageView.snp.remakeConstraints { (make) in
                            make.left.equalTo(edges.left)
                            make.top.equalTo(0)
                            if imgs[index].type == .serviceVedio{
                                make.size.height.equalTo(SLFriendsConfigHelper.helper.videoSize)
                            }else{
                                make.width.height.equalTo(imageWidth)
                            }
                            make.bottom.equalTo(0)
                        }
                        
                    }
                    
                }else{
                    var lastView: UIView?
                    for index in 0..<imgs.count{
                        let imageView = viewWithTag(kImageOrginTag + index) as! HMSingleMediaView
                        imageView.isHidden = false
                        imageView.setVieModel(imgs[index])
                        let row = index % rowCount
                        let low = index / rowCount
                        imageView.snp.remakeConstraints { (make) in
                            if row == 0{
                                if low == 0{
                                    make.top.equalTo(0)
                                }else{
                                    make.top.equalTo(lastView!.snp_bottom).offset(5)
                                }
                                make.left.equalTo(edges.left)
                            }
                            else {
                                make.top.equalTo(lastView!)
                                make.left.equalTo(lastView!.snp_right).offset(5)
                                
                            }
                            make.width.height.equalTo(imageWidth)
                            if index == imgs.count - 1{
                                make.bottom.equalTo(0)
                            }
                            
                        }
                        lastView = imageView
                    }
                }
            }
            
        }
    }
    
    @objc func imageClick(_ tap: UITapGestureRecognizer){
        let index = (tap.view?.tag ?? kImageOrginTag) - kImageOrginTag
        if let medias = medias{
            let browser = YBImageBrowser()
            for model in medias{
                if model.type == .serviceVedio{
                    UIUtil.pushOpenVideo(url: model.url ?? "")
                    return
                }else{
                    let imgData = YBIBImageData()
                    if model.type == .serviceImg {
                        imgData.imageURL = URL.init(string: model.url ?? "")
                    }else{
                        imgData.image = {
                            return UIImage.init(named: model.url ?? "")
                        }
                    }
                    
                    browser.dataSourceArray.append(imgData)
                }
                
            }
            browser.currentPage = index
            browser.delegate = self
            browser.show()
        }
    }
}

extension HMNineMediaView: YBImageBrowserDelegate{
    func yb_imageBrowser(_ imageBrowser: YBImageBrowser, beginTransitioningWithIsShow isShow: Bool) {
        //        if !isShow{
        //            changePlayerStatus(true)
        //        }else{
        //            for model in model.imgs!{
        //                if model.type == "1"{
        //                    changePlayerStatus(false)
        //                }
        //            }
        //        }
    }
}




class HMSingleMediaView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(playerView)
        imageView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
        
        playerView.snp.makeConstraints { (make) in
            make.center.equalTo(imageView)
            make.size.equalTo(CGSize.init(width: 55, height: 55))
        }
        
    }
    
    var model: SLFriendsMediaModel!
    func setVieModel(_ model: SLFriendsMediaModel){
        self.model = model
        imageView.isHidden = true
        playerView.isHidden = true
        
        if model.type == .serviceVedio{
            imageView.isHidden = false
            playerView.isHidden = false
            imageView.sl_setImageWithURL(url: URL.init(string: (model.url ?? "").sl_getVediUrlImage()), placeholder:kImageDefualtMixedImage)
            
        }else if model.type == .serviceImg{
            imageView.isHidden = false
            imageView.sl_setImageWithURL(url: URL.init(string: (model.url ?? "") + NSUtil.sl_imageThumbnail(width: 200, height: 200)), placeholder: kImageDefualtMixedImage)
        }else{
            imageView.isHidden = false
            imageView.image = UIImage.init(named: model.url ?? "")
        }
    }
    // 先暂停滚动播放
    /// 停止滑动后播放
    func cheackPlayer(){
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    lazy var playerView: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "sl_publish_play"))
        return imageView
    }()

}
