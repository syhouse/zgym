//
//  SLPhotoAlbumsModel.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/3/2.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper


class SLPhotoAlbumsModel : NSObject, NSCoding, Mappable{
    var albumName : String?
    var classId : Int?
    var coverUrl : String?
    var createTime : String?
    var createUserId : Int?
    var id : Int?
    var resourceCount : Int?
    var updateTime : String?
    
    
    /// 系统创建按钮
    var isSystemCreateItem: Bool = false
    

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        albumName <- map["albumName"]
        classId <- map["classId"]
        coverUrl <- map["coverUrl"]
        createTime <- map["createTime"]
        createUserId <- map["createUserId"]
        id <- map["id"]
        resourceCount <- map["resourceCount"]
        updateTime <- map["updateTime"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         albumName = aDecoder.decodeObject(forKey: "albumName") as? String
         classId = aDecoder.decodeObject(forKey: "classId") as? Int
         coverUrl = aDecoder.decodeObject(forKey: "coverUrl") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         createUserId = aDecoder.decodeObject(forKey: "createUserId") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         resourceCount = aDecoder.decodeObject(forKey: "resourceCount") as? Int
         updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if albumName != nil{
            aCoder.encode(albumName, forKey: "albumName")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if coverUrl != nil{
            aCoder.encode(coverUrl, forKey: "coverUrl")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if createUserId != nil{
            aCoder.encode(createUserId, forKey: "createUserId")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if resourceCount != nil{
            aCoder.encode(resourceCount, forKey: "resourceCount")
        }
        if updateTime != nil{
            aCoder.encode(updateTime, forKey: "updateTime")
        }

    }

}
