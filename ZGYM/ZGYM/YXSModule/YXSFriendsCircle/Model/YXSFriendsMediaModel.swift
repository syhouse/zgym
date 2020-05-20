//
//  SLFriendsMediaModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/11/15.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import ObjectMapper

enum FriendsMediaType: Int{
    case serviceImg
    case locailImg
    case serviceVedio
}

class YXSFriendsMediaModel : NSObject, NSCoding{
    ///媒体资源地址
    var url : String?
    /// 0 img  1 vedio
    var type : FriendsMediaType
    
    ///视频的封面地址 现在除优成长模块的都需要设置(以前是根据视频的上传地址去取  但是地址规范后 取不到了)
    var bgUrl: String?
    
    init(url : String?, type : FriendsMediaType) {
        self.url = url
        self.type = type
        super.init()
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        
        url = aDecoder.decodeObject(forKey: "url") as? String
        type = FriendsMediaType.init(rawValue: aDecoder.decodeInteger(forKey: "type")) ?? .serviceVedio
        
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if let url = url{
            aCoder.encode(url, forKey: "url")
        }
        aCoder.encode(type.rawValue, forKey: "type")
    }
}
