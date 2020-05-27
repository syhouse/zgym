//
//  YXSTemplateTabModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/5/27.
//  Copyright © 2020 zgym. All rights reserved.
//


import Foundation
import ObjectMapper


class YXSTemplateTabModel : NSObject, NSCoding, Mappable{

    var icon : String?
    var id : Int?
    var isRecommend : Int?
    var tabName : String?
    var templateList : [YXSTemplateListModel]?


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        icon <- map["icon"]
        id <- map["id"]
        isRecommend <- map["isRecommend"]
        tabName <- map["tabName"]
        templateList <- map["templateList"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         icon = aDecoder.decodeObject(forKey: "icon") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isRecommend = aDecoder.decodeObject(forKey: "isRecommend") as? Int
         tabName = aDecoder.decodeObject(forKey: "tabName") as? String
         templateList = aDecoder.decodeObject(forKey: "templateList") as? [YXSTemplateListModel]

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if icon != nil{
            aCoder.encode(icon, forKey: "icon")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isRecommend != nil{
            aCoder.encode(isRecommend, forKey: "isRecommend")
        }
        if tabName != nil{
            aCoder.encode(tabName, forKey: "tabName")
        }
        if templateList != nil{
            aCoder.encode(templateList, forKey: "templateList")
        }

    }

}
