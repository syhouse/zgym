//
//  SLFriendsTipsModel.swift
//  HNYMEducation
//
//  Created by sy_mac on 2020/2/18.
//  Copyright © 2020 zgjy_mac. All rights reserved.
//

import Foundation
import ObjectMapper

class SLFriendsTipsModel: NSObject, Mappable{
    var avatar : String?
    var count : Int?
    var type : String?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map)
    {
        avatar <- map["avatar"]
        count <- map["count"]
        type <- map["type"]
    }
}
