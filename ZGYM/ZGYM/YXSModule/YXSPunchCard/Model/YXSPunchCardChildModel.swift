//
//  YXSPunchCardChildModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/13.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//
import Foundation
import ObjectMapper


class YXSPunchCardChildModel : NSObject, Mappable{
    var account : String?
    var avatar : String?
    var childrenId : Int?
    
    /// 家长id
    var custodianId : Int?
    var realName : String?
    var relationship : String?

    required init?(map: Map){}
    private override init(){}

    func mapping(map: Map)
    {
        account <- map["account"]
        avatar <- map["avatar"]
        childrenId <- map["childrenId"]
        custodianId <- map["custodianId"]
        realName <- map["realName"]
        relationship <- map["relationship"]
        
    }
}
