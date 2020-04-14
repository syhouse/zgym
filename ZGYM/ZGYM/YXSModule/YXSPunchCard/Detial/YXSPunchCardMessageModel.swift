//
//  YXSPunchCardMessageModel.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/4/8.
//  Copyright © 2020 hmym. All rights reserved.
//

import Foundation
import ObjectMapper

class YXSPunchCardMessageModel: NSObject, Mappable {
    var clockInCommentsId : Int?
    var clockInCommitId : Int?
    var clockInId : Int?
    var createTime : String?
    var id : Int?
    var receiveCommentsJsonObject : YXSReceiveCommentsJsonObject?
    var receiveUserId : Int?
    var imageUrl: String?
    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        clockInCommentsId <- map["clockInCommentsId"]
        clockInCommitId <- map["clockInCommitId"]
        clockInId <- map["clockInId"]
        createTime <- map["createTime"]
        id <- map["id"]
        receiveCommentsJsonObject <- map["receiveCommentsJsonObject"]
        receiveUserId <- map["receiveUserId"]
        imageUrl <- map["imageUrl"]
    }
}

class YXSReceiveCommentsJsonObject : NSObject, Mappable{
    var content : String?
    var createTime : Int?
    var id : Int?
    var ruserId : Int?
    var ruserName : String?
    var ruserType : String?
    var type : String?
    var userId : Int?
    var userName : String?
    var userType : String?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        content <- map["content"]
        createTime <- map["createTime"]
        id <- map["id"]
        ruserId <- map["ruserId"]
        ruserName <- map["ruserName"]
        ruserType <- map["ruserType"]
        type <- map["type"]
        userId <- map["userId"]
        userName <- map["userName"]
        userType <- map["userType"]
        
    }
}
