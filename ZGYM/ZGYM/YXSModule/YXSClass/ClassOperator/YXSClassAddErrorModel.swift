//
//  YXSClassAddErrorModel.swift
//  ZGYM
//
//  Created by zgjy_mac on 2019/12/18.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class YXSClassAddErrorModel : NSObject, Mappable{
    
    var gradeId : Int?
    var account : String?
    var childrenId : Int?
    var id : Int?
    var realName : String?
    var relationship : String?
    var userId : Int?
    
    
    var relationships: [String]?
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        gradeId <- map["gradeId"]
        account <- map["account"]
        realName <- map["realName"]
        relationship <- map["relationship"]
        childrenId <- map["childrenId"]
        id <- map["id"]
        userId <- map["userId"]
    }
}
