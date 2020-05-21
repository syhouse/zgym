//
//  YXSPeriodicalListModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/15.
//  Copyright © 2020 zgym. All rights reserved.
//

import UIKit
import ObjectMapper

class YXSPeriodicalListModel: NSObject, NSCoding, Mappable {
    private override init(){}
    required init?(map: Map){}
    
    /// 封面图
    var cover: String?
    
    var id: Int?
    
    var publishTime: String?
    
    var theme: String?
    ///期数
    var numPeriods: Int?
    
    
    var articles: [YXSChildContentHomeListModel]?
    
    func mapping(map: Map) {
        cover <- map["cover"]
        id <- map["id"]
        publishTime <- map["publishTime"]
        theme <- map["theme"]
        numPeriods <- map["numPeriods"]
        articles <- map["articles"]
    }
    
    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        cover = aDecoder.decodeObject(forKey: "cover") as? String
        id = aDecoder.decodeObject(forKey: "id") as? Int
        numPeriods = aDecoder.decodeObject(forKey: "numPeriods") as? Int
        publishTime = aDecoder.decodeObject(forKey: "publishTime") as? String
        theme = aDecoder.decodeObject(forKey: "theme") as? String
        articles = aDecoder.decodeObject(forKey: "articles") as? [YXSChildContentHomeListModel]
    }
    
    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if cover != nil{
            aCoder.encode(cover, forKey: "cover")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if numPeriods != nil{
            aCoder.encode(numPeriods, forKey: "numPeriods")
        }
        if publishTime != nil{
            aCoder.encode(publishTime, forKey: "publishTime")
        }
        if theme != nil{
            aCoder.encode(theme, forKey: "theme")
        }
        if articles != nil{
            aCoder.encode(articles, forKey: "articles")
        }
    }
    
}
