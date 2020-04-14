//
//  SLFriendCircleUserInfoModel.swift
//  HNYMEducation
//
//  Created by zgjy_mac on 2019/12/17.
//  Copyright © 2019 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper


class SLFriendCircleUserInfoModel : NSObject, Mappable{
    
    var account : String?
    var attachment : String?
    var children : [YXSChildrenModel]?
    var id : Int?
    var name : String?
    var type : String?
    var avatar : String?
    var imid : String?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        account <- map["account"]
        attachment <- map["attachment"]
        children <- map["children"]
        id <- map["id"]
        name <- map["name"]
        type <- map["type"]
        avatar <- map["avatar"]
        imid <- map["imid"]
    }
}

