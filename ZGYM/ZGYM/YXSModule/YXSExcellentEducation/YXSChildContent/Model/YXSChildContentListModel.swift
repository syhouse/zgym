//
//  YXSChildContentListModel.swift
//  ZGYM
//
//  Created by yihao on 2020/4/24.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSChildContentHomeListModel: NSObject, NSCoding, Mappable {
    private override init(){}
    required init?(map: Map){}
    
    /// 封面图
    var cover: String?
    
    var id: Int?
    
    /// 标题
    var title: String?
    var publishTime: String?
    
    /// 优期刊的期数
    var numPeriods: Int?
    
    /// 文章类型（1:育儿好文 2:优期刊）
    var type: Int?

    func mapping(map: Map) {
        cover <- map["cover"]
        id <- map["id"]
        title <- map["title"]
        publishTime <- map["publishTime"]
        numPeriods <- map["numPeriods"]
        type <- map["type"]
    }
    
    @objc required init(coder aDecoder: NSCoder)
    {
        cover = aDecoder.decodeObject(forKey: "cover") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        title = aDecoder.decodeObject(forKey: "title") as? String
        publishTime = aDecoder.decodeObject(forKey: "publishTime") as? String
        numPeriods = aDecoder.decodeObject(forKey: "numPeriods") as? Int
        type = aDecoder.decodeObject(forKey: "type") as? Int
    }
    
    @objc func encode(with aCoder: NSCoder)
    {
        if cover != nil{
            aCoder.encode(cover, forKey: "cover")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if publishTime != nil{
            aCoder.encode(publishTime, forKey: "publishTime")
        }
        if numPeriods != nil{
            aCoder.encode(numPeriods, forKey: "numPeriods")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
    }
}


class YXSChildContentHomeTypeModel: NSObject, Mappable {
    private override init(){}
    required init?(map: Map){}
    
    /// 创建时间
    var createTime: String?
    
    /// 类型id
    var id: Int?
    
    /// 类型名称
    var name: String?

    func mapping(map: Map) {
        createTime <- map["createTime"]
        id <- map["id"]
        name <- map["name"]
    }
}
