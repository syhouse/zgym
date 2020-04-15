//
//  YXSBannerModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/4/11.
//  Copyright © 2020 hmym. All rights reserved.
//


import Foundation
import ObjectMapper


class YXSBannerModel : NSObject, NSCoding, Mappable{

    var bannerContentId : Int?
    var bannerContentTitle : String?
    var bannerContentType : Int?
    var bannerCoverUrl : String?
    var bannerTitle : String?
    var createdAt : Int?
    var id : Int?
    var isPaid : Int?
    var kind : String?
    var operationCategoryId : Int?
    var redirectUrl : String?
    var shortTitle : String?
    var updatedAt : Int?


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        bannerContentId <- map["banner_content_id"]
        bannerContentTitle <- map["banner_content_title"]
        bannerContentType <- map["banner_content_type"]
        bannerCoverUrl <- map["banner_cover_url"]
        bannerTitle <- map["banner_title"]
        createdAt <- map["created_at"]
        id <- map["id"]
        isPaid <- map["is_paid"]
        kind <- map["kind"]
        operationCategoryId <- map["operation_category_id"]
        redirectUrl <- map["redirect_url"]
        shortTitle <- map["short_title"]
        updatedAt <- map["updated_at"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         bannerContentId = aDecoder.decodeObject(forKey: "banner_content_id") as? Int
         bannerContentTitle = aDecoder.decodeObject(forKey: "banner_content_title") as? String
         bannerContentType = aDecoder.decodeObject(forKey: "banner_content_type") as? Int
         bannerCoverUrl = aDecoder.decodeObject(forKey: "banner_cover_url") as? String
         bannerTitle = aDecoder.decodeObject(forKey: "banner_title") as? String
         createdAt = aDecoder.decodeObject(forKey: "created_at") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         isPaid = aDecoder.decodeObject(forKey: "is_paid") as? Int
         kind = aDecoder.decodeObject(forKey: "kind") as? String
         operationCategoryId = aDecoder.decodeObject(forKey: "operation_category_id") as? Int
         redirectUrl = aDecoder.decodeObject(forKey: "redirect_url") as? String
         shortTitle = aDecoder.decodeObject(forKey: "short_title") as? String
         updatedAt = aDecoder.decodeObject(forKey: "updated_at") as? Int

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if bannerContentId != nil{
            aCoder.encode(bannerContentId, forKey: "banner_content_id")
        }
        if bannerContentTitle != nil{
            aCoder.encode(bannerContentTitle, forKey: "banner_content_title")
        }
        if bannerContentType != nil{
            aCoder.encode(bannerContentType, forKey: "banner_content_type")
        }
        if bannerCoverUrl != nil{
            aCoder.encode(bannerCoverUrl, forKey: "banner_cover_url")
        }
        if bannerTitle != nil{
            aCoder.encode(bannerTitle, forKey: "banner_title")
        }
        if createdAt != nil{
            aCoder.encode(createdAt, forKey: "created_at")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isPaid != nil{
            aCoder.encode(isPaid, forKey: "is_paid")
        }
        if kind != nil{
            aCoder.encode(kind, forKey: "kind")
        }
        if operationCategoryId != nil{
            aCoder.encode(operationCategoryId, forKey: "operation_category_id")
        }
        if redirectUrl != nil{
            aCoder.encode(redirectUrl, forKey: "redirect_url")
        }
        if shortTitle != nil{
            aCoder.encode(shortTitle, forKey: "short_title")
        }
        if updatedAt != nil{
            aCoder.encode(updatedAt, forKey: "updated_at")
        }

    }

}
