//
//  SLMediaModel.swift
//  ZGYM
//
//  Created by hnsl_mac on 2019/11/16.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import Photos

class SLMediaModel: NSObject, NSCoding {
    override init() {
        super.init()
    }
    /// 类型
    var type: PHAssetMediaType = .image
    
    //图片先设置image
    var showImg: UIImage?
    var videoUrl: URL?

    
    /// 相册资源
    var asset: PHAsset!{
        didSet{
            type = asset.mediaType
            if showImg == nil{
                if type == .image{
                    DispatchQueue.global().async {
                        UIUtil.PHAssetToImage(self.asset){
                            (result) in
                            self.showImg = result
                        }
                    }
                }else if type == .video{
                    PHCachingImageManager().requestAVAsset(forVideo: asset, options:nil, resultHandler: { (asset, audioMix, info)in
                        let avAsset = asset as? AVURLAsset
                        self.videoUrl = avAsset?.url
                        self.showImg = UIImage.sl_getScreenShotImage(fromVideoUrl: avAsset?.url)
                    })
                    
                }
            }
            localIdentifiers = asset.localIdentifier
        }
    }
    
    
    /// 相册资源本地标识
    var localIdentifiers: String?
    
    var fileName: String{
        get{
            let strs = (asset.value(forKey: "filename") as? String ?? "").split(separator: ".")
            return String(strs.first ?? "")
        }
    }
    var fileType: String{
        get{
            let strs = (asset.value(forKey: "filename") as? String ?? "").split(separator: ".")
            return String(strs.last ?? "")
        }
    }
    
    static func getMediaModels(assets: [PHAsset]) -> [SLMediaModel]{
        var models = [SLMediaModel]()
        for asset in assets{
            let model = SLMediaModel()
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

class SLPublishMediaModel: SLMediaModel {
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
