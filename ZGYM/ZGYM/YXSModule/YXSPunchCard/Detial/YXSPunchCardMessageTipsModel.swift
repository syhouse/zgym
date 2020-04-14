//
//  YXSPunchCardMessageTipsModel.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/4/8.
//  Copyright © 2020 hmym. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper


class YXSPunchCardMessageTipsModel : NSObject, Mappable{

    var commentsUserInfo : CommentsUserInfo?
    var count : Int?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        commentsUserInfo <- map["commentsUserInfo"]
        count <- map["count"]
        
    }
}

import Foundation
import ObjectMapper


class CommentsUserInfo : NSObject, Mappable{

    var userId : Int?
    var userName : String?
    var userType : String?
    var avatar: String?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        userId <- map["userId"]
        userName <- map["userName"]
        userType <- map["userType"]
        avatar <- map["avatar"]
        
    }
}
