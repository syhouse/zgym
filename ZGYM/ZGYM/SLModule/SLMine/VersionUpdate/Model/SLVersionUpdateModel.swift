//
//  SLVersionUpdateModel.swift
//  ZGYM
//
//  Created by sl_mac on 2019/12/27.
//  Copyright © 2019 hnsl_mac. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper


class SLVersionUpdateModel : NSObject, NSCoding, Mappable{
    
    var code : Int?
    var content : String?
    var createTime : String?
    var id : Int?
    var platform : String?
    var url : String?
    var version : String?
    var forceUpdate : String?
    
    
    private override init(){}
    required init?(map: Map){}
    
    func mapping(map: Map)
    {
        code <- map["code"]
        content <- map["content"]
        createTime <- map["createTime"]
        id <- map["id"]
        platform <- map["platform"]
        url <- map["url"]
        version <- map["version"]
        forceUpdate <- map["forceUpdate"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? Int
        content = aDecoder.decodeObject(forKey: "content") as? String
        createTime = aDecoder.decodeObject(forKey: "createTime") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        platform = aDecoder.decodeObject(forKey: "platform") as? String
        url = aDecoder.decodeObject(forKey: "url") as? String
        version = aDecoder.decodeObject(forKey: "version") as? String
        forceUpdate = aDecoder.decodeObject(forKey: "forceUpdate") as? String
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if platform != nil{
            aCoder.encode(platform, forKey: "platform")
        }
        if url != nil{
            aCoder.encode(url, forKey: "url")
        }
        if version != nil{
            aCoder.encode(version, forKey: "version")
        }
        if forceUpdate != nil{
            aCoder.encode(forceUpdate, forKey: "forceUpdate")
        }
    }
    
}
