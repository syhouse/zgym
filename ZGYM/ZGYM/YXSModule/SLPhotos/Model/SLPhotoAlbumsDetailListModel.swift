//
//  SLPhotoAlbumsDetailListModel.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/3/7.
//  Copyright © 2020 hmym. All rights reserved.
//
import Foundation
import ObjectMapper


class SLPhotoAlbumsDetailListModel : NSObject, NSCoding, Mappable{
    var albumId : Int?
    var bgUrl : String?
    var createTime : String?
    var fileMd5 : String?
    var id : Int?
//    资源类型(0图片 1视频)
    var resourceType : Int?
    var resourceUrl : String?
    var updateTime : String?
    var uploadUserId : Int?
    var videoDuration : Int?
    
    var isSelected: Bool = false
    
    
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        albumId <- map["albumId"]
        bgUrl <- map["bgUrl"]
        createTime <- map["createTime"]
        fileMd5 <- map["fileMd5"]
        id <- map["id"]
        resourceType <- map["resourceType"]
        resourceUrl <- map["resourceUrl"]
        updateTime <- map["updateTime"]
        uploadUserId <- map["uploadUserId"]
        videoDuration <- map["videoDuration"]
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         albumId = aDecoder.decodeObject(forKey: "albumId") as? Int
         bgUrl = aDecoder.decodeObject(forKey: "bgUrl") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         fileMd5 = aDecoder.decodeObject(forKey: "fileMd5") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         resourceType = aDecoder.decodeObject(forKey: "resourceType") as? Int
         resourceUrl = aDecoder.decodeObject(forKey: "resourceUrl") as? String
         updateTime = aDecoder.decodeObject(forKey: "updateTime") as? String
         uploadUserId = aDecoder.decodeObject(forKey: "uploadUserId") as? Int
         videoDuration = aDecoder.decodeObject(forKey: "videoDuration") as? Int
    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if albumId != nil{
            aCoder.encode(albumId, forKey: "albumId")
        }
        if bgUrl != nil{
            aCoder.encode(bgUrl, forKey: "bgUrl")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if fileMd5 != nil{
            aCoder.encode(fileMd5, forKey: "fileMd5")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if resourceType != nil{
            aCoder.encode(resourceType, forKey: "resourceType")
        }
        if resourceUrl != nil{
            aCoder.encode(resourceUrl, forKey: "resourceUrl")
        }
        if updateTime != nil{
            aCoder.encode(updateTime, forKey: "updateTime")
        }
        if uploadUserId != nil{
            aCoder.encode(uploadUserId, forKey: "uploadUserId")
        }
        if videoDuration != nil{
            aCoder.encode(videoDuration, forKey: "videoDuration")
        }

    }

}
