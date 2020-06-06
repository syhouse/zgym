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
    
    var videoUrl: URL?
    
    ///相册图片的image or 相册视频的第一帧
    private var assetImage: UIImage?
    
    //缩略图用于展示
    private var thumbnailImage: UIImage?
    
    /// 相册资源  这个会自动设置图片 缩略图  会有延迟
    var asset: PHAsset!{
        didSet{
            type = asset.mediaType
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
    
    // MARK: - tool
    ///设置媒体资源图片
    public func setAssetImage(image: UIImage?){
        self.assetImage = image
        if let showImg = assetImage{
            let newSize = showImg.yxs_scaleImage(image: showImg, imageLength: 500)
            thumbnailImage = showImg.yxs_resizeImage(image: showImg, newSize: newSize)
        }
    }
    
    
    public func getThumbnailImage(completHandle: @escaping((_ image: UIImage?) ->())){
        if let thumbnailImage = thumbnailImage{
            completHandle(thumbnailImage)
        }else{
            getImage(isThumbnail: true, completHandle: completHandle)
            
        }
    }
    
    public func getAssetImage(completHandle: @escaping((_ image: UIImage?) ->())){
        if let assetImage = assetImage{
            completHandle(assetImage)
        }else{
            getImage(isThumbnail: false, completHandle: completHandle)
            
        }
    }
    
    private func getImage(isThumbnail: Bool ,completHandle: @escaping((_ image: UIImage?) ->())){
        if self.asset != nil{
            YXSMediaHelper.PHAssetToImage(self.asset){
                (result) in
                self.assetImage = result
                let newSize = result.yxs_scaleImage(image: result, imageLength: 500)
                self.thumbnailImage = result.yxs_resizeImage(image: result, newSize: newSize)
                DispatchQueue.main.async {
                    completHandle(isThumbnail ? self.thumbnailImage : self.assetImage)
                }
            }
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


class SLPublishEditMediaModel: SLPublishMediaModel {
    /// 是否是添加按钮
    var isAddItem: Bool = false
    
    init(isAddItem: Bool = false) {
        self.isAddItem = isAddItem
        super.init()
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        isAddItem = aDecoder.decodeBool(forKey: "isAddItem")
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc override func encode(with aCoder: NSCoder)
    {
        super.encode(with: aCoder)
        
        aCoder.encode(isAddItem, forKey: "isAddItem")
    }
}
