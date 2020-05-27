//
//  YXSTemplateDetialModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/26.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSTemplateDetialModel : NSObject, NSCoding, Mappable{

    var content : String?
    var id : Int?
    var imageUrl : String?
    var isRecommend : Int?
    var link : String?
    var period : String?
    var reminder : Int?
    var serviceType : Int?
    var tabId : Int?
    var title : String?
    var totalDay : Int?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        content <- map["content"]
        id <- map["id"]
        imageUrl <- map["imageUrl"]
        isRecommend <- map["isRecommend"]
        link <- map["link"]
        period <- map["period"]
        reminder <- map["reminder"]
        serviceType <- map["serviceType"]
        tabId <- map["tabId"]
        title <- map["title"]
        totalDay <- map["totalDay"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         content = aDecoder.decodeObject(forKey: "content") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         imageUrl = aDecoder.decodeObject(forKey: "imageUrl") as? String
         isRecommend = aDecoder.decodeObject(forKey: "isRecommend") as? Int
         link = aDecoder.decodeObject(forKey: "link") as? String
         period = aDecoder.decodeObject(forKey: "period") as? String
         reminder = aDecoder.decodeObject(forKey: "reminder") as? Int
         serviceType = aDecoder.decodeObject(forKey: "serviceType") as? Int
         tabId = aDecoder.decodeObject(forKey: "tabId") as? Int
         title = aDecoder.decodeObject(forKey: "title") as? String
         totalDay = aDecoder.decodeObject(forKey: "totalDay") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if content != nil{
            aCoder.encode(content, forKey: "content")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if imageUrl != nil{
            aCoder.encode(imageUrl, forKey: "imageUrl")
        }
        if isRecommend != nil{
            aCoder.encode(isRecommend, forKey: "isRecommend")
        }
        if link != nil{
            aCoder.encode(link, forKey: "link")
        }
        if period != nil{
            aCoder.encode(period, forKey: "period")
        }
        if reminder != nil{
            aCoder.encode(reminder, forKey: "reminder")
        }
        if serviceType != nil{
            aCoder.encode(serviceType, forKey: "serviceType")
        }
        if tabId != nil{
            aCoder.encode(tabId, forKey: "tabId")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if totalDay != nil{
            aCoder.encode(totalDay, forKey: "totalDay")
        }

    }

}
