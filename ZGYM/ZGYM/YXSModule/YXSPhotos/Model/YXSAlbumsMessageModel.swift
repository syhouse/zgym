//
//  YXSAlbumsMessageModel.swift
//  ZGYM
//
//  Created by sy_mac on 2020/6/17.
//  Copyright © 2020 zgym. All rights reserved.
//


import Foundation
import ObjectMapper


class YXSAlbumsMessageModel : NSObject, NSCoding, Mappable{

    var albumId : Int?
    var attachment : String?
    var classId : Int?
    var commentId : Int?
    var content : String?
    var createTime : String?
    var id : Int?
    var operatorId : Int?
    var operatorAvatar : String?
    var operatorName : String?
    var operatorType : String?
    var recipient : Int?
    var recipientType : String?
    var resourceId : Int?
    var type : String?


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        albumId <- map["albumId"]
        attachment <- map["attachment"]
        classId <- map["classId"]
        commentId <- map["commentId"]
        content <- map["content"]
        createTime <- map["createTime"]
        id <- map["id"]
        operatorId <- map["operator"]
        operatorAvatar <- map["operatorAvatar"]
        operatorName <- map["operatorName"]
        operatorType <- map["operatorType"]
        recipient <- map["recipient"]
        recipientType <- map["recipientType"]
        resourceId <- map["resourceId"]
        type <- map["type"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         albumId = aDecoder.decodeObject(forKey: "albumId") as? Int
         attachment = aDecoder.decodeObject(forKey: "attachment") as? String
         classId = aDecoder.decodeObject(forKey: "classId") as? Int
         commentId = aDecoder.decodeObject(forKey: "commentId") as? Int
         content = aDecoder.decodeObject(forKey: "content") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
         operatorId = aDecoder.decodeObject(forKey: "operator") as? Int
         operatorAvatar = aDecoder.decodeObject(forKey: "operatorAvatar") as? String
         operatorName = aDecoder.decodeObject(forKey: "operatorName") as? String
         operatorType = aDecoder.decodeObject(forKey: "operatorType") as? String
         recipient = aDecoder.decodeObject(forKey: "recipient") as? Int
         recipientType = aDecoder.decodeObject(forKey: "recipientType") as? String
         resourceId = aDecoder.decodeObject(forKey: "resourceId") as? Int
         type = aDecoder.decodeObject(forKey: "type") as? String

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
        if attachment != nil{
            aCoder.encode(attachment, forKey: "attachment")
        }
        if classId != nil{
            aCoder.encode(classId, forKey: "classId")
        }
        if commentId != nil{
            aCoder.encode(commentId, forKey: "commentId")
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
        if operatorId != nil{
            aCoder.encode(operatorId, forKey: "operatorId")
        }
        if operatorAvatar != nil{
            aCoder.encode(operatorAvatar, forKey: "operatorAvatar")
        }
        if operatorName != nil{
            aCoder.encode(operatorName, forKey: "operatorName")
        }
        if operatorType != nil{
            aCoder.encode(operatorType, forKey: "operatorType")
        }
        if recipient != nil{
            aCoder.encode(recipient, forKey: "recipient")
        }
        if recipientType != nil{
            aCoder.encode(recipientType, forKey: "recipientType")
        }
        if resourceId != nil{
            aCoder.encode(resourceId, forKey: "resourceId")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }

    }

}
