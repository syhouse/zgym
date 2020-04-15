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
    var url : String?
    /// 0 img  1 vedio
    var type : FriendsMediaType
    
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
