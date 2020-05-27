//
//  YXSMediaModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/16.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import Photos

class YXSMediaModel: NSObject, NSCoding {
    override init() {
        super.init()
    }
    /// 类型
    var type: PHAssetMediaType = .image
    
    //图片先设置image
    var showImg: UIImage?{
        didSet{
            if let showImg = showImg{
                let newSize = showImg.yxs_scaleImage(image: showImg, imageLength: 500)
                thumbnailImage = showImg.yxs_resizeImage(image: showImg, newSize: newSize)
            }
            
        }
    }
    var videoUrl: URL?
    
    //缩略图用于展示
    var thumbnailImage: UIImage?

    /// 设置asset 后自动初始化图片、 缩略图成功回调
    var imageSetSucessBlock: ((_ showImg: UIImage?, _ thumbnailImage: UIImage?) ->())?
    
    /// 相册资源  这个会自动设置图片 缩略图  会有延迟
    var asset: PHAsset!{
        didSet{
            type = asset.mediaType
            if showImg == nil{
                if type == .image{
                    DispatchQueue.global().async {
                        UIUtil.PHAssetToImage(self.asset){
                            (result) in
                            self.showImg = result
                            
                            let newSize = result.yxs_scaleImage(image: result, imageLength: 500)
                            self.thumbnailImage = result.yxs_resizeImage(image: result, newSize: newSize)
                            DispatchQueue.main.async {
                                self.imageSetSucessBlock?(result , self.thumbnailImage)
                            }
                        }
                    }
                }else if type == .video{
                    DispatchQueue.global().async {
                        PHCachingImageManager().requestAVAsset(forVideo: self.asset, options:nil, resultHandler: { (asset, audioMix, info)in
                            let avAsset = asset as? AVURLAsset
                            self.videoUrl = avAsset?.url
                            self.showImg = UIImage.yxs_getScreenShotImage(fromVideoUrl: avAsset?.url)
                            DispatchQueue.main.async {
                                self.imageSetSucessBlock?(self.showImg, self.showImg)
                            }
                        })
                    }
                }
            }
            localIdentifiers = asset.localIdentifier
        }
    }
    
    
    /// 相册资源本地标识
    var localIdentifiers: String?
    
    var fileName: String{
        get{
            if asset != nil {
                let strs = (asset.value(forKey: "filename") as? String ?? "").split(separator: ".")
                return String(strs.first ?? "")
            } else {
                let timeStamp = NSDate().timeIntervalSince1970
                let num = NSNumber.init(value: timeStamp)
                return String(num.int64Value)
            }
        }
    }
    var fileType: String{
        get{
            let strs = (asset.value(forKey: "filename") as? String ?? "").split(separator: ".")
            return String(strs.last ?? "")
        }
    }
    
    static func getMediaModels(assets: [PHAsset]) -> [YXSMediaModel]{
        var models = [YXSMediaModel]()
        for asset in assets{
            let model = YXSMediaModel()
            model.asset = asset
            models.append(model)
        }
        return models
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        videoUrl = aDecoder.decodeObject(forKey: "videoUrl") as? URL
        localIdentifiers = aDecoder.decodeObject(forKey: "localIdentifiers") as? String

        if let localIdentifiers = localIdentifiers{
            let asset = PHAsset.fetchAssets(withLocalIdentifiers: [(localIdentifiers)], options: nil).firstObject
            self.asset = asset
            type = asset?.mediaType ?? .image
        }
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if videoUrl != nil{
            aCoder.encode(videoUrl, forKey: "videoUrl")
        }
      
        if localIdentifiers != nil{
            aCoder.encode(localIdentifiers, forKey: "localIdentifiers")
        }
    }
}

class SLPublishMediaModel: YXSMediaModel {
    /// 视频的第一帧
    var showImageUrl: String?{
        didSet{
            if showImageUrl != nil{
                type = .video
            }
        }
    }
    
    /// 资源的服务器地址
    var serviceUrl: String?
    
    /// 是否是服务器资源
    var isService: Bool{
        return serviceUrl == nil ? false : true
    }
    
    override init() {
        super.init()
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        showImageUrl = aDecoder.decodeObject(forKey: "serviceUrl") as? String
        serviceUrl = aDecoder.decodeObject(forKey: "serviceUrl") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        if showImageUrl != nil{
            aCoder.encode(showImageUrl, forKey: "showImageUrl")
        }
      
        if serviceUrl != nil{
            aCoder.encode(serviceUrl, forKey: "serviceUrl")
        }
    }
}
