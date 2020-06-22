//
//  YXSPhotoPreviewCommentModel.swift
//  ZGYM
//
//  Created by Liu Jie on 2020/6/1.
//  Copyright © 2020 zgym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSPhotoPreviewCommentModel : NSObject, NSCoding, Mappable{

    var avatar : String?
    var content : String?
    var createTime : Int?
    var id : Int?
    var reUserId : Int?
    var reUserName : String?
    var reUserType : String?
    var type : String?
    var userId : Int?
    var userName : String?
    var userType : String?
    
    var isMyPublish: Bool{
        return userId == self.yxs_user.id && userType == self.yxs_user.type
    }


    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        content <- map["content"]
        createTime <- map["createTime"]
        id <- map["id"]
        reUserId <- map["reUserId"]
        reUserName <- map["reUserName"]
        reUserType <- map["reUserType"]
        type <- map["type"]
        userId <- map["userId"]
        userName <- map["userName"]
        userType <- map["userType"]
        
    }

    /**
    * NSCoding required initializer.
    * Fills the data from the passed decoder
    */
    @objc required init(coder aDecoder: NSCoder)
    {
         avatar = aDecoder.decodeObject(forKey: "avatar") as? String
         content = aDecoder.decodeObject(forKey: "content") as? String
         createTime = aDecoder.decodeObject(forKey: "createTime") as? Int
         id = aDecoder.decodeObject(forKey: "id") as? Int
         reUserId = aDecoder.decodeObject(forKey: "reUserId") as? Int
         reUserName = aDecoder.decodeObject(forKey: "reUserName") as? String
         reUserType = aDecoder.decodeObject(forKey: "reUserType") as? String
         type = aDecoder.decodeObject(forKey: "type") as? String
         userId = aDecoder.decodeObject(forKey: "userId") as? Int
         userName = aDecoder.decodeObject(forKey: "userName") as? String
         userType = aDecoder.decodeObject(forKey: "userType") as? String

    }

    /**
    * NSCoding required method.
    * Encodes mode properties into the decoder
    */
    @objc func encode(with aCoder: NSCoder)
    {
        if avatar != nil{
            aCoder.encode(avatar, forKey: "avatar")
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
        if reUserId != nil{
            aCoder.encode(reUserId, forKey: "reUserId")
        }
        if reUserName != nil{
            aCoder.encode(reUserName, forKey: "reUserName")
        }
        if reUserType != nil{
            aCoder.encode(reUserType, forKey: "reUserType")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "userId")
        }
        if userName != nil{
            aCoder.encode(userName, forKey: "userName")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "userType")
        }

    }

}
