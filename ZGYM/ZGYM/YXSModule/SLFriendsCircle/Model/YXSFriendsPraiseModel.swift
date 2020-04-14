//
//  SLFriendsPraiseModel.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/11/13.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import UIKit
import ObjectMapper

class YXSFriendsPraiseModel : NSObject, NSCoding, Mappable{

    var classCircleId : Int?
    var createTime : String?
    var id : Int?
    var userId : Int?
    var userName : String?
    var userType : String?
    
    
    /// 是我当前id 身份操作
    var isMyOperation: Bool{
        return userId == yxs_user.id && userType == yxs_user.type
    }

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        classCircleId <- map["classCircleId"]
        createTime <- map["createTime"]
        id <- map["id"]
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
         classCircleId = aDecoder.decodeObject(forKey: "classCircleId") as? Int
         createTime = aDecoder.decodeObject(forKey: "createTime") as? String
         id = aDecoder.decodeObject(forKey: "id") as? Int
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
        if classCircleId != nil{
            aCoder.encode(classCircleId, forKey: "classCircleId")
        }
        if createTime != nil{
            aCoder.encode(createTime, forKey: "createTime")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
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
