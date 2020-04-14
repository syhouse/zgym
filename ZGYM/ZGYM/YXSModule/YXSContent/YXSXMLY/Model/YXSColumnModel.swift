//
//  YXSColumnModel.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSColumnModel : NSObject, NSCoding, Mappable{

    var contentNum : Int?
    var contentType : Int?
    var coverUrlLarge : String?
    var coverUrlMiddle : String?
    var coverUrlSmall : String?
    var createdAt : Int?
    var dimensionTags : [YXSDimensionTag]?
    var id : Int?
    var kind : String?
    var operationCategory : YXSOperationCategory?
    var title : String?
    var updatedAt : Int?


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        contentNum <- map["content_num"]
        contentType <- map["content_type"]
        coverUrlLarge <- map["cover_url_large"]
        coverUrlMiddle <- map["cover_url_middle"]
        coverUrlSmall <- map["cover_url_small"]
        createdAt <- map["created_at"]
        dimensionTags <- map["dimension_tags"]
        id <- map["id"]
        kind <- map["kind"]
        operationCategory <- map["operation_category"]
        title <- map["title"]
        updatedAt <- map["updated_at"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         contentNum = aDecoder.decodeObject(forKey: "content_num") as? Int
         contentType = aDecoder.decodeObject(forKey: "content_type") as? Int
         coverUrlLarge = aDecoder.decodeObject(forKey: "cover_url_large") as? String
         coverUrlMiddle = aDecoder.decodeObject(forKey: "cover_url_middle") as? String
         coverUrlSmall = aDecoder.decodeObject(forKey: "cover_url_small") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         dimensionTags = aDecoder.decodeObject(forKey: "dimension_tags") as? [YXSDimensionTag]
         id = aDecoder.decodeObject(forKey: "id") as? Int
         kind = aDecoder.decodeObject(forKey: "kind") as? String
         operationCategory = aDecoder.decodeObject(forKey: "operation_category") as? YXSOperationCategory
         title = aDecoder.decodeObject(forKey: "title") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if contentNum != nil{
            aCoder.encode(contentNum, forKey: "content_num")
        }
        if contentType != nil{
            aCoder.encode(contentType, forKey: "content_type")
        }
        if coverUrlLarge != nil{
            aCoder.encode(coverUrlLarge, forKey: "cover_url_large")
        }
        if coverUrlMiddle != nil{
            aCoder.encode(coverUrlMiddle, forKey: "cover_url_middle")
        }
        if coverUrlSmall != nil{
            aCoder.encode(coverUrlSmall, forKey: "cover_url_small")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if dimensionTags != nil{
            aCoder.encode(dimensionTags, forKey: "dimension_tags")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if kind != nil{
            aCoder.encode(kind, forKey: "kind")
        }
        if operationCategory != nil{
            aCoder.encode(operationCategory, forKey: "operation_category")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }

    }

}
